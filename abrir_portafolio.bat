@echo off
setlocal

cd /d "%~dp0"
set "PORT=5510"
set "URL=http://127.0.0.1:%PORT%/index.html"
set "PYTHON_EXE="

for /f "delims=" %%P in ('where py 2^>nul') do (
  set "PYTHON_EXE=%%P"
  goto :found_python
)

for /f "delims=" %%P in ('where python 2^>nul') do (
  set "PYTHON_EXE=%%P"
  goto :found_python
)

if exist "C:\Users\santa\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe" (
  set "PYTHON_EXE=C:\Users\santa\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe"
  goto :found_python
)

echo No se encontro Python para iniciar el servidor local.
echo Puedes abrir index.html directamente, pero YouTube puede bloquear el reel por falta de referrer HTTP.
pause
exit /b 1

:found_python
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Invoke-WebRequest -Uri 'http://127.0.0.1:%PORT%/index.html' -UseBasicParsing -TimeoutSec 1 | Out-Null; exit 0 } catch { exit 1 }"
if errorlevel 1 (
  start "Servidor Portafolio" /min "%PYTHON_EXE%" -m http.server %PORT% --bind 127.0.0.1
  timeout /t 2 /nobreak >nul
)

start "" "%URL%"
exit /b 0
