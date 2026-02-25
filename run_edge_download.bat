@echo off
cd /d "%~dp0"

REM Node user binaries (npx) temporär in PATH aufnehmen
set "PATH=%APPDATA%\npm;%PATH%"

echo Starting Supabase Edge Function download...
python "%~dp0download_edge_functions.py"

echo.
echo Fertig. Taste drücken zum Schließen.
pause >nul