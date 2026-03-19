# Миграция на Avalonia v12 Preview с бесплатным WebView

## ⚠️ ВАЖНО: Используется Preview версия!

Эта ветка использует **Avalonia v12.0.0-preview2** для доступа к встроенному бесплатному WebView.

## Преимущества

- ✅ **Бесплатный WebView** — встроен в Avalonia v12, не требует лицензий
- ✅ **Нет CefGlue** — легче, меньше зависимостей
- ✅ **Нет WebViewControl** — единый API
- ✅ **Кроссплатформенность** — Windows и Linux из коробки

## Риски Preview

- ⚠️ Могут быть баги (это preview, не stable)
- ⚠️ API может измениться до stable релиза
- ⚠️ Не рекомендуется для production критичных систем

## Технические изменения

### Пакеты (csproj)
```xml
<!-- Стало: Avalonia v12 Preview -->
<PackageReference Include="Avalonia" Version="12.0.0-preview2" />
<PackageReference Include="Avalonia.Browser" Version="12.0.0-preview2" />

<!-- Удалены: -->
<!-- <PackageReference Include="CefGlue.Avalonia" ... /> -->
<!-- <PackageReference Include="WebViewControl-Avalonia" ... /> -->
```

### Код (C#)
```csharp
// Было (WebViewControl)
using WebViewControl;
var webView = this.FindControl<WebView>("webView");
webView.Address = new Uri(path).AbsoluteUri;

// Стало (Avalonia v12 встроенный)
using Avalonia.Controls;  // WebView тут!
var webView = this.FindControl<WebView>("webView");
webView.Source = new Uri(path);
```

### XAML
```xml
<!-- Было -->
xmlns:webview="clr-namespace:WebViewControl;assembly=WebViewControl.Avalonia"
<webview:WebView x:Name="webView" .../>

<!-- Стало -->
<WebView x:Name="webView" .../>
```

## Сборка

### Windows
```bash
dotnet build
```

### Linux (включая RedOS!)
```bash
dotnet build
# WebKit2GTK больше не нужен!
```

## Планы

- [ ] Протестировать на Windows
- [ ] Протестировать на Linux/RedOS
- [ ] Протестировать на реальных HTML отчетах
- [ ] Обновить до stable v12 когда выйдет

## Обратная связь

Если найдешь баги — пиши в Issues!
