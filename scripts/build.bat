@echo off
setlocal
for %%i in ("%file_dir%\*.vbp") do (
    del "%log_file%" > nul 2>&1
    "%Vb6%" /make "%%i" /out "%log_file%" /outdir "%bin_dir%"
    findstr /r /c:"Build of '.*' succeeded" "%log_file%" || (type "%log_file%" 1>&2 & exit /b 1)
)
echo Done.
