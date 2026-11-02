# Backup-Perfil.ps1
# Declara el parámetro $RutaDestino de tipo texto (string) y le asigna un valor predeterminado (E:\Backup_Migracion). 
# Si ejecutas el script sin especificar la ruta, usará este valor por defecto; 
# si lo ejecutas pasando una ruta distinta (p.e. 
# .\Backup-Perfil.ps1 -RutaDestino "D:\Copia"), usará la que tú le indiques.
param (
    [string]$RutaDestino = "E:\Backup_Migracion"
)

# Obtiene usuario actual y ruta de perfil, y crea la carpeta de backup en la ruta destino especificada.
$Usuario = $env:USERNAME
$OrigenPerfil = $env:USERPROFILE
$CarpetaBackup = Join-Path -Path $RutaDestino -ChildPath $Usuario

# Inicia el proceso de copia de datos
Write-Host "Iniciando copia de datos para el usuario: $Usuario" -ForegroundColor Green
# Crea la carpeta de backup si no existe
New-Item -ItemType Directory -Force -Path $CarpetaBackup | Out-Null

# 1. Copia de carpetas personales (Escritorio, Documentos, Descargas, Imágenes, Favoritos)
# Quitar /L de Robocopy para que realice la copia real y no solo simule la acción.
$Carpetas = @("Desktop", "Documents", "Downloads", "Pictures", "Favorites")
foreach ($Folder in $Carpetas) {
    $RutaOrigen = Join-Path -Path $OrigenPerfil -ChildPath $Folder
    $RutaDest = Join-Path -Path $CarpetaBackup -ChildPath $Folder
    if (Test-Path $RutaOrigen) {
        Write-Host "Copiando $Folder..." -ForegroundColor Yellow
        Robocopy $RutaOrigen $RutaDest /E /Z /R:1 /W:1 /MT:8 /XJ /L 
    }
}

# 2. Firmas de Outlook
#$RutaFirmas = Join-Path -Path $env:APPDATA -ChildPath "Microsoft\Signatures"
#if (Test-Path $RutaFirmas) {
#    Write-Host "Copiando firmas de Outlook..." -ForegroundColor Yellow
#    Robocopy $RutaFirmas (Join-Path -Path $CarpetaBackup -ChildPath "Outlook_Signatures") /E
#}
# ----------------------------------------------------------------------
# 3. Exportación de la configuración de Red (con Máscara 255.255.255.0)
# ----------------------------------------------------------------------
Write-Host "Guardando información de red en configuracion_red.txt..." -ForegroundColor Yellow
Get-NetAdapter | Where-Object Status -eq 'Up' | ForEach-Object {
    $Adapter = $_
    $IPConfig = Get-NetIPConfiguration -InterfaceIndex $Adapter.InterfaceIndex
    $Prefix = $IPConfig.IPv4Address.PrefixLength

    # Conversión de CIDR (/24) a formato decimal punteado (255.255.255.0)
    $SubnetMask = if ($Prefix) {
        $MaskBits = ("1" * $Prefix).PadRight(32, "0")
        [string]::Join('.', ($MaskBits -split '(\d{8})' | Where-Object { $_ } | ForEach-Object { [Convert]::ToByte($_, 2) }))
    } else { "N/A" }

    [PSCustomObject]@{
        'Adaptador'      = $Adapter.Name
        'Descripción'    = $Adapter.InterfaceDescription
        'Dirección MAC'  = $Adapter.MacAddress
        'IPv4 Address'   = ($IPConfig.IPv4Address.IPAddress -join ', ')
        'Máscara Red'    = $SubnetMask
        'Puerta Enlace'  = ($IPConfig.IPv4DefaultGateway.NextHop -join ', ')
        'Servidores DNS' = ($IPConfig.DNSServer.ServerAddresses -join ', ')
    }
} | Format-Table -AutoSize | Out-File -FilePath (Join-Path -Path $CarpetaBackup -ChildPath "configuracion_red.txt") -Encoding UTF8


# 3. Exportación de impresoras de red instaladas
Write-Host "Exportando impresoras conectadas..." -ForegroundColor Yellow
Get-CimInstance Win32_Printer | Select-Object Name, ShareName, SystemName, PrinterState, PrinterStatus, Location, PortName, DriverName, ServerName, Network | Format-Table -AutoSize | Out-File -FilePath (Join-Path -Path $CarpetaBackup -ChildPath "Impresoras.txt") -Encoding UTF8

# ----------------------------------------------------------------------
# 4. Exportación de unidades de red mapeadas
# ----------------------------------------------------------------------
Write-Host "Exportando unidades de red mapeadas..." -ForegroundColor Yellow
Get-CimInstance Win32_LogicalDisk | Where-Object {$_.DriveType -eq 4} | Select-Object DeviceID, ProviderName | Format-Table -AutoSize | Out-File -FilePath (Join-Path -Path $CarpetaBackup -ChildPath "UnidadesRed.txt") -Encoding UTF8

# ----------------------------------------------------------------------
# 5. Exportación de todas las impresoras instaladas
# ----------------------------------------------------------------------
Write-Host "Exportando impresoras instaladas..." -ForegroundColor Yellow
Get-CimInstance Win32_Printer | Select-Object Name, ShareName, SystemName, PrinterState, PrinterStatus, Location, PortName, DriverName, ServerName, Network | Format-Table -AutoSize | Out-File -FilePath (Join-Path -Path $CarpetaBackup -ChildPath "Impresoras.txt") -Encoding UTF8

# ----------------------------------------------------------------------
# 6. Informe y exportación de certificados digitales
# ----------------------------------------------------------------------
Write-Host "Guardando información de certificados en certificados.txt..." -ForegroundColor Yellow
Get-ChildItem -Path Cert:\CurrentUser\My | Select-Object Subject, Issuer, NotAfter, @{Name="ClaveExportable"; Expression={$_.PrivateKey.CspKeyContainerInfo.Exportable}} | Format-Table -AutoSize | Out-File -FilePath (Join-Path -Path $CarpetaBackup -ChildPath "certificados.txt") -Encoding UTF8

Write-Host "Exportando archivos .pfx de certificados exportables..." -ForegroundColor Yellow
$RutaCertificats = Join-Path -Path $CarpetaBackup -ChildPath "Certificados"
$ContrasenaCert = ConvertTo-SecureString -String "Certificado2026!" -AsPlainText -Force

Get-ChildItem -Path Cert:\CurrentUser\My | Where-Object { $_.HasPrivateKey -and $_.PrivateKey.CspKeyContainerInfo.Exportable } | ForEach-Object {
    if (-not (Test-Path $RutaCertificats)) { New-Item -ItemType Directory -Force -Path $RutaCertificats | Out-Null }
    $Thumbprint = $_.Thumbprint
    $Subject = $_.Subject -replace '[^\w\s-]', ''
    Export-PfxCertificate -Cert "Cert:\CurrentUser\My\$Thumbprint" -FilePath (Join-Path -Path $RutaCertificats -ChildPath "Cert_$Subject.pfx") -Password $ContrasenaCert | Out-Null
}



Write-Host "¡Proceso de copia completado con éxito!" -ForegroundColor Green