#!/usr/bin/env pwsh
# Я написал этот скрипт для полной автоматизации сборки
# Можно запускать с параметрами, например: .\build.ps1 -Configuration Debug

param(
    [string]$Configuration = "Release",
    [string]$Runtime = "win-x64",
    [switch]$Clean = $false,
    [switch]$CreateZip = $false
)

Write-Host "=== HtmlReportViewer Build Script ===" -ForegroundColor Cyan
Write-Host "Конфигурация: $Configuration" -ForegroundColor Gray
Write-Host ""

# Проверяю .NET
Write-Host "[Проверка] Ищу .NET SDK..." -NoNewline
try {
    $dotnetVersion = dotnet --version
    Write-Host " OK (версия $dotnetVersion)" -ForegroundColor Green
} catch {
    Write-Host " ОШИБКА" -ForegroundColor Red
    Write-Host ".NET 8 SDK не установлен. Скачай: https://dotnet.microsoft.com/download"
    exit 1
}

# Определяю пути
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectDir = Resolve-Path "$scriptDir\..\.."
$publishDir = "$projectDir\publish"

# Очистка если нужна
if ($Clean) {
    Write-Host "[Очистка] Удаляю старые сборки..." -NoNewline
    if (Test-Path $publishDir) {
        Remove-Item -Recurse -Force $publishDir
    }
    Write-Host " OK" -ForegroundColor Green
}

# Создаю папку publish
New-Item -ItemType Directory -Force -Path $publishDir | Out-Null

# Перехожу в папку проекта
Set-Location $projectDir

# Восстановление пакетов
Write-Host "[1/4] Восстановление NuGet пакетов..." -NoNewline
dotnet restore --verbosity quiet
if ($LASTEXITCODE -ne 0) {
    Write-Host " ОШИБКА" -ForegroundColor Red
    exit 1
}
Write-Host " OK" -ForegroundColor Green

# Сборка
Write-Host "[2/4] Сборка ($Configuration)..." -NoNewline
dotnet build -c $Configuration --no-restore --verbosity quiet
if ($LASTEXITCODE -ne 0) {
    Write-Host " ОШИБКА" -ForegroundColor Red
    exit 1
}
Write-Host " OK" -ForegroundColor Green

# Публикация (self-contained или framework-dependent)
Write-Host "[3/4] Публикация для $Runtime..." -NoNewline
if ($Runtime -eq "win-x64") {
    dotnet publish -c $Configuration -r $Runtime --self-contained true -o $publishDir --no-build --verbosity quiet
} else {
    dotnet publish -c $Configuration -r $Runtime --self-contained false -o $publishDir --no-build --verbosity quiet
}
if ($LASTEXITCODE -ne 0) {
    Write-Host " ОШИБКА" -ForegroundColor Red
    exit 1
}
Write-Host " OK" -ForegroundColor Green

# Копирую index.html если есть
if (Test-Path "$projectDir\HtmlReportViewer\index.html") {
    Copy-Item "$projectDir\HtmlReportViewer\index.html" $publishDir -Force
    Write-Host "[4/4] Скопировал index.html" -ForegroundColor Green
}

# Создание ZIP если просили
if ($CreateZip) {
    Write-Host "[Бонус] Создаю архив..." -NoNewline
    $zipName = "HtmlReportViewer-$Runtime-$Configuration.zip"
    Compress-Archive -Path "$publishDir\*" -DestinationPath "$projectDir\$zipName" -Force
    Write-Host " OK ($zipName)" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== ГОТОВО! ===" -ForegroundColor Green
Write-Host "Файл: $publishDir\HtmlReportViewer.exe" -ForegroundColor Yellow
Write-Host ""

# Показываю размер
$exeSize = (Get-Item "$publishDir\HtmlReportViewer.exe").Length / 1MB
Write-Host "Размер: $([math]::Round($exeSize, 2)) MB" -ForegroundColor Gray