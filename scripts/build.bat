@echo off
setlocal
for %%i in ("%~dp0.") do set "file_dir=%%~dpnxi"
for %%i in ("%file_dir%\..\src\.") do set "src_dir=%%~dpnxi"
for %%i in ("%file_dir%\..\bin\.") do set "bin_dir=%%~dpnxi"
set "VbCodeLines=%bin_dir%\VbCodeLines.exe"
set "Vb6=%ProgramFiles%\Microsoft Visual Studio\VB98\VB6.EXE"
if not exist "%Vb6%" set "Vb6=%ProgramFiles(x86)%\Microsoft Visual Studio\VB98\VB6.EXE"
set "log_file=%file_dir%\compile.out"

echo Cleanup %file_dir%...
if exist "%bin_dir%\SampleVB.dll" start "" /w regsvr32 /u /s "%bin_dir%\SampleVB.dll"
for %%i in ("%file_dir%\*.*") do (if not "%%~nxi"=="build.bat" del "%%i" > nul)
@REM rd /s /q "%file_dir%\Connectors" 2>&1
@REM mkdir "%file_dir%\Connectors"
@REM rd /s /q "%file_dir%\Protocols" 2>&1
@REM mkdir "%file_dir%\Protocols"
@REM rd /s /q "%file_dir%\Shared" 2>&1
@REM mkdir "%file_dir%\Shared"
echo Copy sources from %file_dir%...
for %%i in ("%file_dir%\*.bas";"%file_dir%\*.cls";"%file_dir%\*.frm";"%file_dir%\*.frx";"%file_dir%\*.vbp") do (copy "%%i" "%file_dir%" > nul)
@REM echo Copy sources from %src_dir%\Connectors...
@REM for %%i in ("%src_dir%\Connectors\*.bas";"%src_dir%\Connectors\*.cls") do (copy "%%i" "%file_dir%\Connectors" > nul)
@REM echo Copy sources from %src_dir%\Protocols...
@REM for %%i in ("%src_dir%\Protocols\*.bas";"%src_dir%\Protocols\*.cls") do (copy "%%i" "%file_dir%\Protocols" > nul)
@REM echo Copy sources from %src_dir%\Shared...
@REM for %%i in ("%src_dir%\Shared\*.bas";"%src_dir%\Shared\*.cls") do (copy "%%i" "%file_dir%\Shared" > nul)
echo Put lines to sources in %file_dir%...
for %%i in ("%file_dir%\*.vbp") do (start "" /w "%VbCodeLines%" %%i)
echo Compiling to %bin_dir%...
attrib -r "%bin_dir%\*.*"
for %%i in ("%file_dir%\*.vbp") do (
    del "%log_file%" > nul 2>&1
    "%Vb6%" /make "%%i" /out "%log_file%" /outdir "%bin_dir%"
    findstr /r /c:"Build of '.*' succeeded" "%log_file%" || (type "%log_file%" 1>&2 & exit /b 1)
)
echo Done.