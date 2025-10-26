#!/usr/bin/env python3
"""
Script to find duplicate _blink_ samples between sample/ and sample/blink/ directories
Author: Matthew Schinkel
"""

import os
import sys
from pathlib import Path

def find_duplicate_blink_samples(base_dir):
    """
    Find all blink samples that exist in both sample/ and sample/blink/
    
    Args:
        base_dir: Base jallib directory path
    """
    sample_dir = Path(base_dir) / "sample"
    blink_dir = sample_dir / "blink"
    
    # Check if directories exist
    if not sample_dir.exists():
        print(f"ERROR: Sample directory does not exist: {sample_dir}")
        return []
    
    if not blink_dir.exists():
        print(f"INFO: Blink subdirectory does not exist: {blink_dir}")
        print(f"INFO: No duplicates to find.")
        return []
    
    # Find all blink samples in main sample directory (not in subdirectories)
    main_blink_samples = set()
    for file in sample_dir.iterdir():
        if file.is_file() and "_blink_" in file.name and file.name.endswith(".jal"):
            main_blink_samples.add(file.name)
    
    # Find all blink samples in blink subdirectory
    blink_subdir_samples = set()
    for file in blink_dir.glob("*.jal"):
        if file.is_file() and "_blink_" in file.name:
            blink_subdir_samples.add(file.name)
    
    # Find duplicates
    duplicates = main_blink_samples & blink_subdir_samples
    
    # Print results
    print(f"\n{'='*80}")
    print(f"DUPLICATE BLINK SAMPLE FINDER")
    print(f"{'='*80}\n")
    
    print(f"Main sample directory: {sample_dir}")
    print(f"Blink subdirectory:    {blink_dir}\n")
    
    print(f"Blink samples in main directory:  {len(main_blink_samples)}")
    print(f"Blink samples in blink directory: {len(blink_subdir_samples)}")
    print(f"Duplicate files found:            {len(duplicates)}\n")
    
    if duplicates:
        print(f"{'='*80}")
        print(f"DUPLICATE FILES:")
        print(f"{'='*80}\n")
        
        for filename in sorted(duplicates):
            main_path = sample_dir / filename
            blink_path = blink_dir / filename
            
            # Get file sizes
            main_size = main_path.stat().st_size if main_path.exists() else 0
            blink_size = blink_path.stat().st_size if blink_path.exists() else 0
            
            print(f"  {filename}")
            print(f"    Main:  {main_path} ({main_size} bytes)")
            print(f"    Blink: {blink_path} ({blink_size} bytes)")
            
            if main_size == blink_size:
                print(f"    Status: Same size")
            else:
                print(f"    Status: DIFFERENT SIZE (Δ {abs(main_size - blink_size)} bytes)")
            print()
    else:
        print("No duplicate files found.\n")
    
    return sorted(duplicates)

def main():
    # Determine base directory
    script_dir = Path(__file__).parent.parent
    
    if len(sys.argv) > 1:
        base_dir = Path(sys.argv[1])
    else:
        base_dir = script_dir
    
    print(f"Searching in: {base_dir.absolute()}")
    
    duplicates = find_duplicate_blink_samples(base_dir)
    
    if duplicates:
        print(f"{'='*80}")
        print(f"SUMMARY: Found {len(duplicates)} duplicate blink sample(s)")
        print(f"{'='*80}\n")
        sys.exit(1)  # Exit with error code if duplicates found
    else:
        print(f"{'='*80}")
        print(f"SUMMARY: No duplicates found")
        print(f"{'='*80}\n")
        sys.exit(0)

if __name__ == "__main__":
    main()


