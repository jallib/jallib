jalparser -noinclude %1 >>all.txt
IF ERRORLEVEL 1 goto error
goto end

: error
rem wc all.txt
pause

:end
