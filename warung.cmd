@echo off
setlocal
cd /d "%~dp0"
rem Konsol UTF-8 supaya motif (≈♦┌╔▒) tampil benar (DESIGN §3.1–3.2).
chcp 65001 >nul
set "INDK_PATH=%~dp0."
"%~dp0.tools\indk\indk-windows\indk.exe" "%~dp0utama.idk" %*
