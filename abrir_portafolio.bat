@echo off
setlocal

cd /d "%~dp0"
set "PORT=5510"
set "URL=http://127.0.0.1:%PORT%/index.html"
set "CHECK_URL=http://127.0.0.1:%PORT%/portfolio-root.txt"
set "PYTHON_EXE=C:\Users\santa\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe"

if not exist "%PYTHON_EXE%" (
  for /f "delims=" %%P in ('where python 2^>nul') do (
    set "PYTHON_EXE=%%P"
    goto :found_python
  )
)

if exist "%PYTHON_EXE%" goto :found_python

echo No se encontro Python para iniciar el servidor local.
echo Puedes abrir index.html directamente, pero YouTube puede bloquear el reel por falta de referrer HTTP.
pause
exit /b 1

:found_python
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { $r = Invoke-WebRequest -Uri '%CHECK_URL%' -UseBasicParsing -TimeoutSec 1; if ($r.Content.Trim() -eq 'Portafolio_Web') { exit 0 } else { exit 1 } } catch { exit 1 }"
if errorlevel 1 (
  start "Servidor Portafolio Web" /min cmd /c ""%PYTHON_EXE%" -m http.server %PORT% --bind 127.0.0.1"
  ping -n 3 127.0.0.1 >nul
)

start "" "%URL%"
exit /b 0
