@echo off
setlocal enabledelayedexpansion

:: ========================================================
:: INICIO DE COPIA DE SEGURIDAD REAL
:: ========================================================
echo ========================================================
echo [2/2] INICIANDO COPIA DE SEGURIDAD REAL...
echo ========================================================
echo Usando destino verificado: %DESTINO%
echo ========================================================
echo.

:: Guardar configuración de red
echo Guardando configuracion de red...
ipconfig /all > "%DESTINO%\Configuracion_IP.txt"
echo Contenido del archivo de configuracion de red:
echo --------------------------------------------------------
type "%DESTINO%\Configuracion_IP.txt"
echo --------------------------------------------------------
echo.

:: =======================================================
:: RECORDATORIOS PARA EL USUARIO
:: =======================================================
echo =======================================================
echo REVISA Y APUNTA AHORA EN TU PARTE VISUAL:
echo - Unidades de red mapeadas (net use)
echo - Certificados personales (certmgr.msc)
echo - Configuracion de impresoras (control printers)
echo =======================================================
echo.

:: =======================================================
:: PARÁMETROS DE ROBOCOPY
:: =======================================================
set "ROBOCOPY_OPTS=/L /E /R:1 /W:1 /MT:8 /XJ /NFL /NDL"
echo Params de Robocopy: %ROBOCOPY_OPTS%
echo.

:: Copiar todas las carpetas
set "CARPETAS=Desktop Documents Downloads Pictures Favorites"
for %%C in (%CARPETAS%) do (
    echo Copiando %%C...
    robocopy "%USERPROFILE%\%%C" "%DESTINO%\%%C" %ROBOCOPY_OPTS%
)

:: =======================================================
:: FINALIZACIÓN
:: =======================================================
echo ========================================================
echo MIGRACION DE %USERNAME% FINALIZADA OK.
echo ========================================================

echo =======================================================
echo REVISA Y APUNTA:
echo - Unidades de red mapeadas, tipicamente F:// y G:// Windows+E, Este equipo / ubicaciones de red
echo - Unidades de almacenamiento locales, USB y de red
echo - Certificados personales del usuario. Windows+R 'certmgr.msc' en Personal / Certificados.
echo - Configuracion de impresoras y puertos. Windows+R 'control printers'.
echo =======================================================

pause