# Prepara-USMT.ps1
# Script para verificar/instalar Windows ADK (USMT) automáticamente

$USMTRutaDefault = "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\User State Migration Tool\amd64\ScanState.exe"
$USMTUSB = "E:\USMT\ScanState.exe"

Write-Host "Verificando presencia de USMT (ScanState.exe)..." -ForegroundColor Yellow

if (Test-Path $USMTRutaDefault) {
    Write-Host "[OK] USMT ya está instalado en el sistema local." -ForegroundColor Green
    $ScanStateExe = $USMTRutaDefault
} elseif (Test-Path $USMTUSB) {
    Write-Host "[OK] USMT detectado en la unidad USB (E:\USMT)." -ForegroundColor Green
    $ScanStateExe = $USMTUSB
} else {
    Write-Host "[!] USMT no detectado. Iniciando instalación automática de Windows ADK (solo USMT)..." -ForegroundColor Cyan

    $ADKUrl = "https://go.microsoft.com/fwlink/?linkid=2243390" # Enlace directo al instalador de Windows ADK
    $ADKInstaller = "$env:TEMP\adksetup.exe"

    Write-Host "Descargando adksetup.exe..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $ADKUrl -OutFile $ADKInstaller

    Write-Host "Instalando componente USMT en segundo plano..." -ForegroundColor Yellow
    # La opción /features OptionId.UserStateMigrationTool instala exclusivamente USMT de forma silenciosa (/quiet)
    Start-Process -FilePath $ADKInstaller -ArgumentList "/quiet /norestart /features OptionId.UserStateMigrationTool" -Wait

    if (Test-Path $USMTRutaDefault) {
        Write-Host "[ÉXITO] Instalación completada correctamente." -ForegroundColor Green
        $ScanStateExe = $USMTRutaDefault
    } else {
        Write-Host "[ERROR] Ocurrió un problema durante la instalación de Windows ADK." -ForegroundColor Red
        exit
    }
}

