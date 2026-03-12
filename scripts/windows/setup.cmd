@echo off
REM Я создал этот скрипт для быстрой настройки рабочего окружения
REM Запускаю один раз на новом компьютере и всё готово

echo === Настройка окружения HtmlReportViewer ===
echo.

REM Проверяю .NET 8
echo [1/3] Проверяю .NET 8 SDK...
dotnet --version >nul 2>&1
if errorlevel 1 (
    echo [.NET] Не найден! Открываю страницу загрузки...
    start https://dotnet.microsoft.com/download/dotnet/8.0
    echo Установи .NET 8 SDK и запусти скрипт снова
    pause
    exit /b 1
)
echo [OK] .NET установлен
dotnet --version

REM Проверяю WebView2 Runtime
echo.
echo [2/3] Проверяю WebView2 Runtime...
reg query "HKLM\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdate\Clients\{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5}" >nul 2>&1
if errorlevel 1 (
    echo [WebView2] Не найден! Это нужно для отображения HTML
    echo Скачай Runtime с: https://developer.microsoft.com/microsoft-edge/webview2/
    set /p INSTALLWV2="Открыть страницу скачивания? (Y/N): "
    if /i "%INSTALLWV2%"=="Y" start https://developer.microsoft.com/microsoft-edge/webview2/
) else (
    echo [OK] WebView2 установлен
)

REM Проверяю Git
echo.
echo [3/3] Проверяю Git...
git --version >nul 2>&1
if errorlevel 1 (
    echo [Git] Не найден, но он нужен только для разработки
    echo Скачать: https://git-scm.com/download/win
) else (
    echo [OK] Git установлен
    git --version
)

echo.
echo === Настройка завершена! ===
echo Теперь можно собирать проект через build.cmd
pause