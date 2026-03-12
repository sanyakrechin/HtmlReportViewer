#!/bin/bash
# Я создал этот скрипт для настройки окружения на Linux
# Запускаю один раз на новой машине

echo "=== Настройка окружения HtmlReportViewer ==="
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Проверяю .NET
echo "[1/3] Проверяю .NET SDK..."
if command -v dotnet &> /dev/null; then
    DOTNET_VERSION=$(dotnet --version)
    echo -e "${GREEN}OK${NC} .NET установлен: $DOTNET_VERSION"
else
    echo -e "${YELLOW}ВНИМАНИЕ${NC} .NET не установлен"
    echo ""
    echo "Установи одной командой:"
    echo "  wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh"
    echo "  chmod +x dotnet-install.sh"
    echo "  ./dotnet-install.sh --channel 8.0"
    echo ""
    echo "Или через пакетный менеджер:"
    echo "  sudo apt-get update"
    echo "  sudo apt-get install -y dotnet-sdk-8.0"
fi

# Проверяю зависимости для WebView
echo ""
echo "[2/3] Проверяю зависимости WebView..."

# Проверяю наличие GTK (нужно для Avalonia на Linux)
if pkg-config --exists gtk+-3.0 2>/dev/null; then
    echo -e "${GREEN}OK${NC} GTK3 установлен"
else
    echo -e "${YELLOW}ВНИМАНИЕ${NC} GTK3 не найден"
    echo "Установи: sudo apt-get install -y libgtk-3-0"
fi

# Проверяю WebKit (нужно для WebView)
if pkg-config --exists webkit2gtk-4.0 2>/dev/null; then
    echo -e "${GREEN}OK${NC} WebKit2GTK установлен"
else
    echo -e "${YELLOW}ВНИМАНИЕ${NC} WebKit2GTK не найден"
    echo "Установи: sudo apt-get install -y libwebkit2gtk-4.0-37"
fi

# Проверяю Git
echo ""
echo "[3/3] Проверяю Git..."
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version)
    echo -e "${GREEN}OK${NC} $GIT_VERSION"
else
    echo "Git не установлен (нужен только для разработки)"
    echo "Установи: sudo apt-get install -y git"
fi

echo ""
echo "=== Настройка завершена! ==="
echo "Теперь можно собирать: ./build.sh"

# Даю рекомендацию по запуску
echo ""
echo "Примечание: Для запуска GUI приложений из WSL используй:"
echo "  export DISPLAY=:0"
echo "Или собирай нативно под Windows через build.cmd"