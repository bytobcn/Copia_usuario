# Copia y restauración de perfil de usuario

Scripts de Windows para analizar y preparar una migración de archivos del usuario. El flujo contempla dos fases para la copia y dos para la restauración:

| Script            | Función                                                                                               |
|-------------------|-------------------------------------------------------------------------------------------------------|
| `Copia_00.bat`    | Prepara el destino del respaldo y muestra una simulación del contenido de las carpetas seleccionadas. |
| `Copia_01.bat`    | Guarda información de red y realiza una simulación completa multihilo del proceso de copia física.    |
| `Restaura_00.bat` | Muestra una simulación rápida de la restauración desde el respaldo al perfil actual.                  |
| `Restaura_01.bat` | Muestra la información de red y realiza una simulación completa multihilo del volcado de datos.       |


## Carpetas incluidas

Los scripts contemplan estas carpetas del perfil de Windows:

- Escritorio (`Desktop`)
- Documentos (`Documents`)
- Descargas (`Downloads`)
- Imágenes (`Pictures`)
- Favoritos (`Favorites`)

La copia también guarda la salida de `ipconfig /all` en `Configuracion_IP.txt`. Las unidades de red, certificados personales y configuración de impresoras deben revisarse por separado; los scripts muestran recordatorios para ello.

## Destinos y orígenes

- **Copia:** el perfil actual (`%USERPROFILE%`) se analiza frente a `D:\Backup_Migracion\%USERNAME%`.
- **Restauración:** se usa `D:\Backup_Migracion\%USERNAME%` como origen y el perfil actual (`%USERPROFILE%`) como destino. Cambia la línea en `Copia_00.bat` si la unidad donde se realiza la copia no es la 'D:'

La unidad `D:` está fijada en los scripts. Antes de usarlos, comprueba que existe, que corresponde al disco esperado y que tiene espacio suficiente.

## Uso

Abre una ventana de **Símbolo del sistema (CMD)** en la carpeta de estos scripts y ejecuta la pareja correspondiente, en orden:

1. Para preparar una copia: `Copia_00.bat` y después `Copia_01.bat`.
Comprueba correccion de los datos al ejecutar `Copia_00.bat` así como el tamaño de las carpetas a copiar.
Elimina el parámetro /L de las carpetas a copiar.

2. Para preparar una restauración: `Restaura_00.bat` y después `Restaura_01.bat`.
Comprueba correccion de los datos al ejecutar `Restaura_00.bat` así como el tamaño de las carpetas a copiar.
Elimina el parámetro /L de las carpetas a copiar.

Ejecuta cada pareja desde la misma ventana de CMD y no la cierres entre fases: la segunda fase depende de las variables de origen y destino definidas por la primera. Revisa los resultados de la fase `00` antes de continuar.

## Importante: los scripts están en modo de simulación

Los cuatro scripts usan la opción `/L` de Robocopy, que solo enumera o simula operaciones y **no copia ni restaura archivos**. En particular, `Copia_01.bat` y `Restaura_01.bat` también incluyen `/L`, pese a los mensajes que indican que se inicia una operación real. Por tanto, sus mensajes de finalización no confirman que los datos se hayan transferido.

`Copia_00.bat` sí crea las carpetas de destino vacías si no existen. No se ha eliminado la opción de simulación de los scripts; verifica y modifica su configuración de forma deliberada antes de confiar en ellos para transferir datos.
