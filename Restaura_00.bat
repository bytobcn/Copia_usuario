@echo off
echo ========================================================
echo [1/2] COMPROBANDO ORIGEN DE BACKUP Y NUEVO DESTINO...
echo ========================================================
echo  Username:       %USERNAME%
set DESTINO=%USERPROFILE%
echo  Destino (Nuevo):%DESTINO%
set UNIDAD_ORIGEN=D:
echo  Unidad origen:  %UNIDAD_ORIGEN%
set ORIGEN=%UNIDAD_ORIGEN%\Backup_Migracion\%USERNAME%
echo  Origen (Backup):%ORIGEN%
echo ========================================================
echo.

echo ========================================================
echo SIMULANDO RESTAURACION (Comprobando datos con /L)
echo ========================================================
echo Size a restaurar en DESKTOP:
robocopy "%ORIGEN%\Desktop" "%DESTINO%\Desktop" /L /E /NFL /NDL /NJH 
echo --------------------------------------------------------
echo Size a restaurar en DOCUMENTS:
robocopy "%ORIGEN%\Documents" "%DESTINO%\Documents" /L /E /NFL /NDL /NJH 
echo --------------------------------------------------------
echo Size a restaurar en DOWNLOADS:
robocopy "%ORIGEN%\Downloads" "%DESTINO%\Downloads" /L /E /NFL /NDL /NJH
echo --------------------------------------------------------
echo Size a restaurar en PICTURES:
robocopy "%ORIGEN%\Pictures" "%DESTINO%\Pictures" /L /E /NFL /NDL /NJH
echo --------------------------------------------------------
echo Size a restaurar en FAVORITES:
robocopy "%ORIGEN%\Favorites" "%DESTINO%\Favorites" /L /E /NFL /NDL /NJH
echo ========================================================
echo.
echo ANALISIS DE RESTAURACION FINALIZADO. Verifique los Sizes.
echo Deje esta ventana abierta y ejecute restaura_01.bat para volcar los datos.
echo.
pause