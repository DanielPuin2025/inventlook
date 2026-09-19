@echo off
REM ===================================================
REM Script de configuración inicial para InventLook (Windows)
REM ===================================================

echo.
echo ========================================
echo   Configuracion Inicial de InventLook
echo ========================================
echo.

REM Verificar si .env ya existe
if exist .env (
    echo Advertencia: El archivo .env ya existe.
    set /p overwrite="¿Deseas sobrescribirlo? (s/n): "
    if /i not "%overwrite%"=="s" (
        echo Cancelado. Usando .env existente.
        exit /b 0
    )
)

echo Creando archivo .env...
echo.

REM Solicitar datos
set /p db_password="Ingresa la contraseña de MySQL (default: inventlook2024): "
if "%db_password%"=="" set db_password=inventlook2024

set /p mail_username="Ingresa tu correo de Gmail: "
set /p mail_password="Ingresa tu contraseña de aplicacion de Gmail: "

REM Crear archivo
(
echo # Base de datos MySQL (Produccion^)
echo DB_PASSWORD=%db_password%
echo.
echo # Configuracion de correo Gmail
echo MAIL_USERNAME=%mail_username%
echo MAIL_PASSWORD=%mail_password%
) > .env

echo.
echo ========================================
echo   Archivo .env creado exitosamente
echo ========================================
echo.
echo Proximos pasos:
echo 1. Verifica que .env tenga los datos correctos
echo 2. Ejecuta: mvnw.cmd spring-boot:run
echo 3. Accede a: http://localhost:8080
echo.
echo IMPORTANTE: .env NO se subira a GitHub (esta en .gitignore^)
echo.
pause
