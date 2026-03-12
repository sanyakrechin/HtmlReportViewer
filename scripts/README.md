# 🔧 Скрипты для HtmlReportViewer

Я написал эти скрипты, чтобы автоматизировать рутину. Все они работают "из коробки".

## ⚡ Быстрый старт

### Windows
```cmd
# 1. Настройка (один раз на новом компе)
scripts\windows\setup.cmd

# 2. Сборка
scripts\windows\build.cmd

# 3. Запуск с файлом
scripts\windows\run.cmd C:\path\to\report.html
```

### Linux
```bash
# 1. Настройка (один раз)
chmod +x scripts/linux/*.sh
scripts/linux/setup.sh

# 2. Сборка
scripts/linux/build.sh

# 3. Запуск
scripts/linux/run.sh /path/to/report.html
```

## 📁 Структура

```
scripts/
├── windows/
│   ├── setup.cmd      # Проверка и установка зависимостей
│   ├── build.cmd      # Простая сборка (CMD)
│   ├── build.ps1      # Продвинутая сборка (PowerShell)
│   └── run.cmd        # Запуск приложения
└── linux/
    ├── setup.sh       # Установка зависимостей
    ├── build.sh       # Сборка проекта
    └── run.sh         # Запуск приложения
```

## 🔨 Подробнее о командах

### Windows

**setup.cmd**
- Проверяет наличие .NET 8 SDK
- Проверяет WebView2 Runtime
- Открывает ссылки на скачивание если чего-то нет

**build.cmd**
- Самый простой способ собрать проект
- Делает restore → build → publish
- Результат в папке `publish/`

**build.ps1** (для продвинутых)
```powershell
# Параметры:
.\build.ps1 -Configuration Debug              # Сборка Debug
.\build.ps1 -Runtime linux-x64                # Под Linux
.\build.ps1 -Clean -CreateZip                 # С чисткой и архивом
```

**run.cmd**
- Можно перетащить HTML-файл на скрипт
- Или запустить: `run.cmd file.html`
- Без параметров откроет index.html

### Linux

**setup.sh**
- Проверяет .NET SDK
- Проверяет GTK3 и WebKit2GTK (нужны для WebView)
- Выдаёт команды для установки

**build.sh**
- Аналогичен Windows версии
- Собирает нативный бинарник для Linux

**run.sh**
- Принимает путь к HTML файлу
- Проверяет существование файла перед запуском

## 🚀 GitHub Actions

Я также настроил автоматическую сборку:

- При каждом пуше в `main` — собираются Windows и Linux версии
- При создании тега `v*` — автоматически создаётся Release
- Артефакты хранятся 30 дней

Смотри файл: `.github/workflows/build.yml`

## ❓ Частые проблемы

**"dotnet не найден"**
→ Запусти `setup.cmd` или установи вручную с https://dotnet.microsoft.com

**"WebView2 не найден"** (Windows)
→ Скачай Runtime с https://developer.microsoft.com/microsoft-edge/webview2/

**"Cannot open display"** (Linux/WSL)
→ GUI приложения не работают в WSL без X-сервера. Используй Windows версию.

## 📝 Мои заметки

- Все скрипты работают из любой папки (используют относительные пути)
- Ошибки выводятся понятным языком, не техническим жаргоном
- Цветной вывод помогает быстро понять где проблема