@echo off
chcp 65001 >nul
echo.
echo  =========================================
echo   Atlas Lite ^| Instalacion
echo  =========================================
echo.
echo  Iniciando instalacion. Esto tomara menos de un minuto...
echo.

powershell -ExecutionPolicy Bypass -NoProfile -File "%~dp0installer\windows\install-atlas.ps1"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo  =========================================
    echo   ERROR: La instalacion ha fallado.
    echo   Lee los mensajes anteriores para el detalle.
    echo  =========================================
    echo.
    pause
    exit /b 1
)

echo.
echo  =========================================
echo   Atlas Lite instalado correctamente.
echo   Puedes cerrar esta ventana.
echo  =========================================
echo.
pause
