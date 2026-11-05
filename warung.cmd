@echo off
setlocal
cd /d "%~dp0"
set "INDK_PATH=%~dp0."
"%~dp0.tools\indk\indk-windows\indk.exe" "%~dp0utama.idk" %*
