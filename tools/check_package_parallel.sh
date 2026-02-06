#!/bin/bash

# Multi-processing version of check_package.sh
# Usage: check_package_parallel.sh <LIBDIR> <SAMPLEDIR> <COMPILERBIN> [QUICKTEST] [MAX_PROCESSES]

#test with command line:
# ./tools/check_package_parallel.sh ./tools/distrib/jallib-dev/lib ./tools/distrib/jallib-dev/sample compiler/jalv2-i686

LIBDIR=$1
SAMPLEDIR=$2
COMPILERBIN=$3
QUICKTEST=${4:-test-all} # Default to test-all instead of test-one (for makefile testing) if not specified
MAX_PROCESSES=${5:-16}  # Default to 16 processes if not specified

if [ -z "$LIBDIR" ] || [ -z "$SAMPLEDIR" ] || [ -z "$COMPILERBIN" ]; then
    echo "ERROR: Missing required arguments."
    echo "Usage: $0 <LIBDIR> <SAMPLEDIR> <COMPILERBIN> [QUICKTEST] [MAX_PROCESSES]"
    exit 2
fi

if [ ! -d "$LIBDIR" ]; then
    echo "ERROR: LIBDIR does not exist: $LIBDIR"
    exit 2
fi

if [ ! -d "$SAMPLEDIR" ]; then
    echo "ERROR: SAMPLEDIR does not exist: $SAMPLEDIR"
    exit 2
fi

if [ ! -x "$COMPILERBIN" ]; then
    echo "ERROR: COMPILERBIN is not executable: $COMPILERBIN"
    exit 2
fi

TMPFILE=$HOME/tmp/compile.log
FAILED=$HOME/tmp/failed.log
PARALLEL_TMPDIR=$HOME/tmp/parallel_compile

# Clean up previous runs
rm -f $FAILED
rm -rf $PARALLEL_TMPDIR
mkdir -p $PARALLEL_TMPDIR

mainstatus=0
total_files=0
failed_files=0
total_errors=0
total_warnings=0

# Function to compile a single file
compile_file() {
    local file=$1
    local file_id=$2
    local tmp_file="$PARALLEL_TMPDIR/compile_${file_id}.log"
    local status_file="$PARALLEL_TMPDIR/status_${file_id}.txt"
    local errors_file="$PARALLEL_TMPDIR/errors_${file_id}.txt"
    local warnings_file="$PARALLEL_TMPDIR/warnings_${file_id}.txt"
    
    # Run the compiler
    "$COMPILERBIN" -s "$LIBDIR" "$file" > "$tmp_file" 2>&1
    local status=$?
    
    # Extract errors and warnings from output
    local errors_match=$(grep -o "[0-9]* errors" "$tmp_file" | tail -1)
    local warnings_match=$(grep -o "[0-9]* warnings" "$tmp_file" | tail -1)
    local errors=$(echo "$errors_match" | grep -o "[0-9]*")
    local warnings=$(echo "$warnings_match" | grep -o "[0-9]*")
    local summary_missing=0
    if [ -z "$errors_match" ] || [ -z "$warnings_match" ]; then
        summary_missing=1
        # If we can't parse the summary lines from compiler output, treat as a failure.
        errors=1
        warnings=0
    fi
    
    # Default to 0 if not found (shouldn't normally happen now; summary_missing handles the main case)
    errors=${errors:-0}
    warnings=${warnings:-0}
    
    # Write status to files
    echo "$status" > "$status_file"
    echo "$errors" > "$errors_file"
    echo "$warnings" > "$warnings_file"

    # Verify .hex output exists for successful compiles.
    # (Only check when compile looks successful and summary was parsed.)
    local hex_missing=0
    local hex_file="${file%.jal}.hex"
    local HEX_file="${file%.jal}.HEX"
    if [ "$status" -eq 0 ] && [ "$summary_missing" -eq 0 ] && [ "$errors" -eq 0 ] && [ "$warnings" -eq 0 ]; then
        if [ ! -f "$hex_file" ] && [ ! -f "$HEX_file" ]; then
            hex_missing=1
            errors=1
            echo "$errors" > "$errors_file"
        fi
    fi
    
    # Check if compilation failed.
    # - Fail on any errors/warnings
    # - Fail on non-zero exit status
    # - Fail if we couldn't find the compiler summary lines
    # - Fail if expected .hex output is missing after an otherwise successful compile
    if [ "$errors" -gt 0 ] || [ "$warnings" -gt 0 ] || [ "$status" -ne 0 ] || [ "$summary_missing" -eq 1 ] || [ "$hex_missing" -eq 1 ]; then
        echo "$file failed ! (Errors: $errors, Warnings: $warnings)" >> "$PARALLEL_TMPDIR/failed_${file_id}.log"
        if [ "$summary_missing" -eq 1 ]; then
            echo "ERROR: Unable to parse compiler output summary ('<N> errors' / '<N> warnings' not found)." >> "$PARALLEL_TMPDIR/failed_${file_id}.log"
        fi
        if [ "$status" -ne 0 ]; then
            echo "ERROR: Compiler exit status was non-zero ($status)." >> "$PARALLEL_TMPDIR/failed_${file_id}.log"
        fi
        if [ "$hex_missing" -eq 1 ]; then
            echo "ERROR: Expected .hex output was not created: ${hex_file}" >> "$PARALLEL_TMPDIR/failed_${file_id}.log"
        fi
        cat "$tmp_file" >> "$PARALLEL_TMPDIR/failed_${file_id}.log"
        echo >> "$PARALLEL_TMPDIR/failed_${file_id}.log"
    fi
    
    # Clean up individual temp files
    rm -f "$tmp_file"
}

# Function to process files in parallel
process_files_parallel() {
    local files=("$@")
    local file_count=${#files[@]}
    local current_jobs=0
    local file_index=0
    
    echo "Processing $file_count files with up to $MAX_PROCESSES parallel processes..."
    echo "Progress: "
    
    while [ $file_index -lt $file_count ] || [ $current_jobs -gt 0 ]; do
        # Start new jobs if we have capacity and files remaining
        while [ $current_jobs -lt $MAX_PROCESSES ] && [ $file_index -lt $file_count ]; do
            local file="${files[$file_index]}"
            compile_file "$file" "$file_index" &
            ((file_index++))
            ((current_jobs++))
        done
        
        # Wait for any job to complete
        if [ $current_jobs -gt 0 ]; then
            wait -n
            ((current_jobs--))
            echo -n "."
        fi
    done
    
    echo
    echo "All compilation jobs completed."
}

# Check if test-one mode is enabled
if [ "$QUICKTEST" = "test-one" ]; then
    # Use only 18f4620_large_array.jal for quick testing
    files=($(find $SAMPLEDIR -name 18f4620_large_array.jal))
elif [ "$QUICKTEST" = "test-all" ]; then
    # Normal mode - test all .jal files
    files=($(find $SAMPLEDIR -name \*.jal))
else
    # Normal mode - test all .jal files
    files=($(find $SAMPLEDIR -name \*.jal))
fi

total_files=${#files[@]}

if [ $total_files -eq 0 ]; then
    echo "No .jal files found in $SAMPLEDIR"
    exit 0
fi

echo "Found $total_files files to compile"
echo "Using $MAX_PROCESSES parallel processes"

# Start timing
start_time=$(date +%s)

# Process files in parallel
process_files_parallel "${files[@]}"

# Calculate elapsed time
end_time=$(date +%s)
elapsed_time=$((end_time - start_time))

# Collect results
echo "Collecting results..."

# Check status of all files and collect error/warning counts
for i in $(seq 0 $((total_files - 1))); do
    status_file="$PARALLEL_TMPDIR/status_${i}.txt"
    errors_file="$PARALLEL_TMPDIR/errors_${i}.txt"
    warnings_file="$PARALLEL_TMPDIR/warnings_${i}.txt"
    
    if [ -f "$status_file" ]; then
        status=$(cat "$status_file")
        errors=$(cat "$errors_file" 2>/dev/null || echo "0")
        warnings=$(cat "$warnings_file" 2>/dev/null || echo "0")
        
        # Add to totals
        total_errors=$((total_errors + errors))
        total_warnings=$((total_warnings + warnings))
        
        # Check if compilation failed (errors/warnings > 0 OR non-zero exit status).
        if [ "$errors" -gt 0 ] || [ "$warnings" -gt 0 ] || [ "$status" -ne 0 ]; then
            ((failed_files++))
            mainstatus=1
        fi
    fi
done

# Merge all failed logs
for i in $(seq 0 $((total_files - 1))); do
    failed_log="$PARALLEL_TMPDIR/failed_${i}.log"
    if [ -f "$failed_log" ]; then
        cat "$failed_log" >> $FAILED
        rm -f "$failed_log"
    fi
done

# Clean up parallel temp directory
rm -rf $PARALLEL_TMPDIR

# Display summary
echo
echo "=== COMPILATION SUMMARY ==="
echo "Total files compiled: $total_files"
echo "Failed compilations: $failed_files"
echo "Successful compilations: $((total_files - failed_files))"
echo "Total errors: $total_errors"
echo "Total warnings: $total_warnings"
echo "Parallel processes used: $MAX_PROCESSES"
echo "Total compilation time: ${elapsed_time} seconds"

if [ $mainstatus -eq 0 ]; then
    echo "All compilations successful! (No errors or warnings)"
    rm -f $FAILED
else
    echo "Some compilations failed due to errors or warnings. See details below:"
    echo "--------------------------------"
    echo $FAILED
    cat $FAILED
fi

exit $mainstatus
