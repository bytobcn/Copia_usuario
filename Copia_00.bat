@echo off
echo ========================================================
echo [1/2] ANALIZANDO ORIGEN Y PREPARANDO DESTINO...
echo ========================================================
echo  Username:       %USERNAME%
set ORIGEN=%USERPROFILE%
echo  Origen:         %ORIGEN%
set UNIDAD_DESTINO=D:
echo  Unidad destino: %UNIDAD_DESTINO%
set DESTINO=%UNIDAD_DESTINO%\Backup_Migracion\%USERNAME%
echo  Destino:        %DESTINO%
echo ========================================================
echo.

echo Creando carpetas de destino si no existen...
if not exist "%DESTINO%\Desktop"   mkdir "%DESTINO%\Desktop"  
if not exist "%DESTINO%\Documents" mkdir "%DESTINO%\Documents"
if not exist "%DESTINO%\Downloads" mkdir "%DESTINO%\Downloads"
if not exist "%DESTINO%\Pictures"  mkdir "%DESTINO%\Pictures"
if not exist "%DESTINO%\Favorites" mkdir "%DESTINO%\Favorites"
echo.

echo ========================================================
echo CALCULANDO SIZE REALES (Simulacion con /L)
echo ========================================================
echo Size DESKTOP:
robocopy "%ORIGEN%\Desktop" "%DESTINO%\Desktop" /L /E /NFL /NDL /NJH 
echo --------------------------------------------------------
echo Size DOCUMENTS:
robocopy "%ORIGEN%\Documents" "%DESTINO%\Documents" /L /E /NFL /NDL /NJH 
echo --------------------------------------------------------
echo Size DOWNLOADS:
robocopy "%ORIGEN%\Downloads" "%DESTINO%\Downloads" /L /E /NFL /NDL /NJH
echo --------------------------------------------------------
echo Size PICTURES:
robocopy "%ORIGEN%\Pictures" "%DESTINO%\Pictures" /L /E /NFL /NDL /NJH
echo --------------------------------------------------------
echo Size FAVORITES:
robocopy "%ORIGEN%\Favorites" "%DESTINO%\Favorites" /L /E /NFL /NDL /NJH
echo ========================================================
echo.
echo ANALISIS FINALIZADO. Revisa las tablas de arriba.
echo Deja esta ventana abierta para ejecutar copia_01.bat
echo.
pause