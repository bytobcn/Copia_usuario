@echo off
echo ========================================================
echo [2/2] INICIANDO COPIA DE SEGURIDAD REAL...
echo ========================================================
echo Usando destino verificado: %DESTINO%
echo ========================================================
echo.

:: Registro red equipo original
echo Guardando configuracion de red...
ipconfig /all > "%DESTINO%\Configuracion_IP.txt"
echo Contenido del archivo de configuracion de red:
echo --------------------------------------------------------
type "%DESTINO%\Configuracion_IP.txt"
echo --------------------------------------------------------
echo.

echo =======================================================
echo REVISA Y APUNTA AHORA EN TU PARTE VISUAL:
echo - Unidades de red mapeadas (net use)
echo - Certificados personales (certmgr.msc)
echo - Configuracion de impresoras (control printers)
echo =======================================================
echo.

:: Parámetros de Robocopy:
:: /E     : Copia subdirectorios, incluidos los vacíos
:: /R:1   : 1 reintento si el archivo está bloqueado
:: /W:1   : Tiempo de espera de 1 segundo entre reintentos
:: /MT:8  : Multihilo (8 hilos paralelos)
:: /XJ    : Excluye puntos de unión (junction points) para evitar bucles infinitos
:: /NFL   : (Opcional) No muestra lista de archivos en el log para agilizar la consola
:: /NDL   : (Opcional) No muestra nombres de carpetas en el log
:: Parámetros optimizados para Robocopy
:: /L : List only - Simula la copia, no crea ni copia ningún archivo
echo Params de Robocopy: /L /E /R:1 /W:1 /MT:8 /XJ /NFL /NDL
echo.

echo Copiando Desktop...
robocopy "%USERPROFILE%\Desktop" "%DESTINO%\Desktop" /L /E /R:1 /W:1 /MT:8 /XJ /NFL /NDL

echo Copiando Documents...
robocopy "%USERPROFILE%\Documents" "%DESTINO%\Documents" /L /E /R:1 /W:1 /MT:8 /XJ /NFL /NDL

echo Copiando Downloads...
robocopy "%USERPROFILE%\Downloads" "%DESTINO%\Downloads" /L /E /R:1 /W:1 /MT:8 /XJ /NFL /NDL

echo Copiando Pictures...
robocopy "%USERPROFILE%\Pictures" "%DESTINO%\Pictures" /L /E /R:1 /W:1 /MT:8 /XJ /NFL /NDL

echo Copiando Favorites...
robocopy "%USERPROFILE%\Favorites" "%DESTINO%\Favorites" /L /E /R:1 /W:1 /MT:8 /XJ /NFL /NDL

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
