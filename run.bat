@echo off
echo ========================================
echo   EJECUTANDO INVENTLOOK
echo ========================================
echo.

cd /d "%~dp0"

java -cp "target (1)\classes (1);%USERPROFILE%\.m2\repository\*" com.inventlook.InventlookApplication

pause
