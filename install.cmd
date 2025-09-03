@echo off
%WINDIR%\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Update-WSL.ps1"
exit /b %ERRORLEVEL%
