@echo off
echo ========================================================
echo [2/2] INICIANDO VOLCADO REAL DE DATOS EN EL EQUIPO...
echo ========================================================
echo Usando origen verificado:  %ORIGEN%
echo Usando destino verificado: %DESTINO%
echo ========================================================
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

echo Restaura Desktop...
robocopy "%ORIGEN%\Desktop" "%DESTINO%\Desktop" /L /E /R:1 /W:1 /MT:8 /XJ /NFL /NDL

echo Restaura Documents...
robocopy "%ORIGEN%\Documents" "%DESTINO%\Documents" /L /E /R:1 /W:1 /MT:8 /XJ /NFL /NDL

echo Restaura Downloads...
robocopy "%ORIGEN%\Downloads" "%DESTINO%\Downloads" /L /E /R:1 /W:1 /MT:8 /XJ /NFL /NDL

echo Restaura Pictures...
robocopy "%ORIGEN%\Pictures" "%DESTINO%\Pictures" /L /E /R:1 /W:1 /MT:8 /XJ /NFL /NDL

echo Restaura Favorites...
robocopy "%ORIGEN%\Favorites" "%DESTINO%\Favorites" /L /E /R:1 /W:1 /MT:8 /XJ /NFL /NDL
echo.

echo ========================================================
if exist "%ORIGEN%\Configuracion_IP.txt" (
    type "%ORIGEN%\Configuracion_IP.txt"
) else (
    echo [ADVERTENCIA] No se encontro el archivo Configuracion_IP.txt en el backup.
)
echo =======================================================
echo REVISA Y APUNTA:
echo - Revisa configuracion de red, Configuracion_IP.txt
echo - Unidades de red mapeadas, tipicamente F:// y G:// Windows+E, Este equipo / ubicaciones de red
echo - Unidades de almacenamiento locales, USB y de red
echo - Certificados personales del usuario. Windows+R 'certmgr.msc' en Personal / Certificados.
echo - Configuracion de impresoras y puertos. Windows+R 'control printers'.
echo =======================================================

echo ========================================================
echo Restaurada %USERNAME% finalizada con OK.
echo ========================================================