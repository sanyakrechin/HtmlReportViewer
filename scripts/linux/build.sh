#!/bin/bash
# Я написал этот скрипт для сборки под Linux
# Работает на Ubuntu/Debian и других дистрибутивах

echo "=== HtmlReportViewer Linux Build ==="
echo ""

# Цвета для красивого вывода
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Проверяю .NET
echo -n "[Проверка] Ищу .NET SDK... "
if ! command -v dotnet &> /dev/null; then
    echo -e "${RED}ОШИБКА${NC}"
    echo ".NET 8 SDK не установлен!"
    echo ""
    echo "Установи:"
    echo "  wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh"
    echo "  chmod +x dotnet-install.sh"
    echo "  ./dotnet-install.sh --channel 8.0"
    exit 1
fi

DOTNET_VERSION=$(dotnet --version)
echo -e "${GREEN}OK${NC} (версия $DOTNET_VERSION)"

# Определяю пути
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$(realpath "$SCRIPT_DIR/../..")"
PUBLISH_DIR="$PROJECT_DIR/publish"

echo "[Путь] Проект: $PROJECT_DIR"

# Создаю папку publish
mkdir -p "$PUBLISH_DIR"

# Перехожу в папку проекта
cd "$PROJECT_DIR" || exit 1

# Восстановление пакетов
echo ""
echo "[1/4] Восстановление пакетов..."
if ! dotnet restore --verbosity quiet; then
    echo -e "${RED}ОШИБКА: Не удалось восстановить пакеты${NC}"
    exit 1
fi
echo -e "${GREEN}OK${NC}"

# Сборка
echo ""
echo "[2/4] Сборка Release..."
if ! dotnet build -c Release --no-restore --verbosity quiet; then
    echo -e "${RED}ОШИБКА: Ошибка сборки${NC}"
    exit 1
fi
echo -e "${GREEN}OK${NC}"

# Публикация
echo ""
echo "[3/4] Публикация..."
if ! dotnet publish -c Release -o "$PUBLISH_DIR" --no-build --verbosity quiet; then
    echo -e "${RED}ОШИБКА: Ошибка публикации${NC}"
    exit 1
fi
echo -e "${GREEN}OK${NC}"

# Копирую index.html если есть
if [ -f "$PROJECT_DIR/HtmlReportViewer/index.html" ]; then
    cp "$PROJECT_DIR/HtmlReportViewer/index.html" "$PUBLISH_DIR/"
    echo "[4/4] Скопировал index.html"
fi

echo ""
echo -e "${GREEN}=== ГОТОВО! ===${NC}"
echo "Запуск: $PUBLISH_DIR/HtmlReportViewer"
echo ""

# Показываю размер
if [ -f "$PUBLISH_DIR/HtmlReportViewer" ]; then
    SIZE=$(du -h "$PUBLISH_DIR/HtmlReportViewer" | cut -f1)
    echo "Размер: $SIZE"
fi