@echo off
color 1E
echo.

:: Get username and password without showing password and mapdrive
powershell -ExecutionPolicy Bypass -file mapdrivelab.ps1 %1 >nul
