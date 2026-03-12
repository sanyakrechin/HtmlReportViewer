@echo off
REM Я написал этот скрипт, чтобы не открывать Visual Studio каждый раз
REM Просто запускаю и получаю готовый .exe файл

echo === Сборка HtmlReportViewer ===
echo.

REM Проверяю, установлен ли .NET 8
dotnet --version >nul 2>&1
if errorlevel 1 (
    echo [ОШИБКА] .NET 8 SDK не найден!
    echo Скачай отсюда: https://dotnet.microsoft.com/download
    pause
    exit /b 1
)

echo [OK] .NET найден: 
dotnet --version

REM Перехожу в папку с решением
cd /d "%~dp0\..\.."

REM Восстанавливаю пакеты NuGet
echo.
echo [1/3] Восстановление пакетов...
dotnet restore
if errorlevel 1 (
    echo [ОШИБКА] Не удалось восстановить пакеты
    pause
    exit /b 1
)

REM Собираю проект в Release режиме
echo.
echo [2/3] Сборка Release...
dotnet build -c Release --no-restore
if errorlevel 1 (
    echo [ОШИБКА] Ошибка сборки
    pause
    exit /b 1
)

REM Публикую в папку publish (всё в одном месте)
echo.
echo [3/3] Публикация...
dotnet publish -c Release -o publish --no-build
if errorlevel 1 (
    echo [ОШИБКА] Ошибка публикации
    pause
    exit /b 1
)

echo.
echo === ГОТОВО! ===
echo Исполняемый файл: publish\HtmlReportViewer.exe
echo.
pause