@echo off
setlocal enabledelayedexpansion

:: ========================================================
:: CONFIGURACIÓN INICIAL
:: ========================================================
echo ========================================================
echo [1/2] ANALIZANDO ORIGEN Y PREPARANDO DESTINO...
echo ========================================================
echo  Username:       %USERNAME%
set "ORIGEN=%USERPROFILE%"
echo  Origen:         %ORIGEN%
set "UNIDAD_DESTINO=D:"
echo  Unidad destino: %UNIDAD_DESTINO%
set "DESTINO=%UNIDAD_DESTINO%\Backup_Migracion\%USERNAME%"
echo  Destino:        %DESTINO%
echo ========================================================
echo.

:: Crear carpetas de destino
echo Creando carpetas de destino si no existen...
set "CARPETAS=Desktop Documents Downloads Pictures Favorites"
for %%C in (%CARPETAS%) do (
    if not exist "%DESTINO%\%%C" mkdir "%DESTINO%\%%C"
)
echo.

:: ========================================================
:: CÁLCULO DE TAMAÑOS (Simulación con robocopy /L)
:: ========================================================
echo ========================================================
echo CALCULANDO SIZES REALES (Simulacion con /L)
echo ========================================================

set "ROBOCOPY_OPTS=/L /E /NFL /NDL /NJH"

for %%C in (%CARPETAS%) do (
    echo Size %%C:
    robocopy "%ORIGEN%\%%C" "%DESTINO%\%%C" %ROBOCOPY_OPTS%
    echo --------------------------------------------------------
)

echo ========================================================
echo.
echo ANALISIS FINALIZADO. Revisa las tablas de arriba.
echo Deja esta ventana abierta para ejecutar copia_01.bat
echo.
pause