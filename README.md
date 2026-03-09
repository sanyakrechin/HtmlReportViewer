# HTML Report Viewer

Приложение для просмотра и печати HTML-отчётов на базе Avalonia UI.

## Требования

- .NET 8.0
- Windows x64
- Visual Studio 2022 (для сборки)

## Установка и запуск

### Сборка из исходников

    git clone https://github.com/sanyakrechin/HtmlReportViewer.git
    cd HtmlReportViewer/HtmlReportViewer
    dotnet restore
    dotnet build
    dotnet run

### Запуск с указанием HTML-файла

    dotnet run -- "path\to\file.html"

## Функционал

- Отображение HTML-файлов в WebView (Chromium)
- Печать отчётов (Ctrl+P)
- Открытие файлов (Ctrl+O)
- Перезагрузка (F5)

## Технологии

- Avalonia UI 11.3.12
- WebViewControl-Avalonia (CefGlue)
- .NET 8.0

## Лицензия

MIT
