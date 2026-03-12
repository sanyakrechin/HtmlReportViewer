@echo off
REM Я сделал этот скрипт, чтобы быстро открывать HTML-файлы
REM Просто перетащи HTML-файл на этот скрипт или запусти: run.cmd report.html

REM Проверяю, передали ли файл
if "%~1"=="" (
    echo === HtmlReportViewer Launcher ===
    echo.
    echo Использование:
    echo   run.cmd путь\к\файлу.html
    echo.
    echo Или перетащи HTML-файл на этот скрипт
    echo.
    
    REM Если файл не передан, ищем собранный exe
    if exist "%~dp0\..\..\publish\HtmlReportViewer.exe" (
        echo [OK] Запускаю без файла (откроется index.html)
        start "" "%~dp0\..\..\publish\HtmlReportViewer.exe"
    ) else (
        echo [ОШИБКА] Сначала собери проект через build.cmd!
    )
    pause
    exit /b 0
)

REM Проверяю существует ли файл
if not exist "%~1" (
    echo [ОШИБКА] Файл не найден: %~1
    pause
    exit /b 1
)

REM Получаю полный путь к файлу
set "HTMLFILE=%~f1"

REM Ищу собранный exe
set "EXEPATH=%~dp0\..\..\publish\HtmlReportViewer.exe"

if not exist "%EXEPATH%" (
    echo [ОШИБКА] HtmlReportViewer.exe не найден!
    echo Сначала запусти build.cmd для сборки проекта
    pause
    exit /b 1
)

REM Запускаю с файлом
echo [OK] Открываю: %HTMLFILE%
start "" "%EXEPATH%" "%HTMLFILE%"