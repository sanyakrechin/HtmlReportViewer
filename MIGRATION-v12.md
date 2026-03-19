# Миграция на Avalonia v12 с бесплатным WebView

## Что изменилось

В Avalonia v12 WebView стал **бесплатным и open source**! Это позволяет отказаться от сторонних зависимостей (CefGlue, WebViewControl) и использовать встроенный компонент.

## Преимущества миграции

- ✅ **Бесплатно** - больше никаких лицензионных ограничений
- ✅ **Open Source** - полный доступ к исходному коду
- ✅ **Кроссплатформенность** - единый API для Windows, Linux, macOS
- ✅ **Нет зависимостей** - не требуется WebView2 Runtime или WebKit2GTK
- ✅ **RedOS совместимость** - работает без дополнительных пакетов

## Изменения в проекте

### 1. Обновлены пакеты (csproj)
```xml
<!-- Было -->
<PackageReference Include="Avalonia" Version="11.3.12" />
<PackageReference Include="CefGlue.Avalonia" Version="120.6099.211" />
<PackageReference Include="WebViewControl-Avalonia" Version="3.120.11" />

<!-- Стало -->
<PackageReference Include="Avalonia" Version="12.0.0" />
<PackageReference Include="Avalonia.WebView" Version="12.0.0" />
```

### 2. Изменены namespace (axaml)
```xml
<!-- Было -->
xmlns:webview="clr-namespace:WebViewControl;assembly=WebViewControl.Avalonia"

<!-- Стало -->
xmlns:webview="clr-namespace:Avalonia.WebView;assembly=Avalonia.WebView"
```

### 3. Обновлен код (C#)
```csharp
// Было
using WebViewControl;
var webView = this.FindControl<WebView>("webView");
webView.Address = new Uri(path).AbsoluteUri;

// Стало
using Avalonia.WebView;
var webView = this.FindControl<Avalonia.WebView.WebView>("webView");
webView.Source = new Uri(path);
```

## Известные изменения API

| Старое (WebViewControl) | Новое (Avalonia.WebView v12) |
|-------------------------|------------------------------|
| `Address` | `Source` |
| `ExecuteScript()` | `ExecuteScriptAsync()` |
| `LoadHtml(string)` | `LoadHtml(string, string?)` |

## Установка и запуск

### Windows
```bash
dotnet build
./HtmlReportViewer.exe report.html
```

### Linux (включая RedOS)
```bash
dotnet build
./HtmlReportViewer report.html
```

**Важно:** На Linux больше не требуется устанавливать WebKit2GTK!

## Требования

- .NET 8.0 или выше
- Avalonia v12.0.0 или выше

## Обратная совместимость

⚠️ **Breaking changes:** Avalonia v12 имеет изменения по сравнению с v11. Рекомендуется протестировать все функции перед production использованием.
