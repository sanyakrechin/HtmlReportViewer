#!/bin/bash
# Я написал этот скрипт для быстрого запуска под Linux
# Можно использовать: ./run.sh или ./run.sh report.html

# Цвета
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Определяю пути
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$(realpath "$SCRIPT_DIR/../..")"
PUBLISH_DIR="$PROJECT_DIR/publish"
EXE_PATH="$PUBLISH_DIR/HtmlReportViewer"

# Проверяю существует ли собранный файл
if [ ! -f "$EXE_PATH" ]; then
    echo -e "${RED}ОШИБКА: HtmlReportViewer не найден!${NC}"
    echo "Сначала собери проект: ./build.sh"
    exit 1
fi

# Проверяю передали ли файл
if [ $# -eq 0 ]; then
    echo -e "${GREEN}[OK]${NC} Запускаю без файла..."
    "$EXE_PATH"
else
    # Проверяю существует ли переданный файл
    if [ ! -f "$1" ]; then
        echo -e "${RED}ОШИБКА: Файл не найден: $1${NC}"
        exit 1
    fi
    
    # Получаю абсолютный путь
    HTML_FILE="$(realpath "$1")"
    echo -e "${GREEN}[OK]${NC} Открываю: $HTML_FILE"
    "$EXE_PATH" "$HTML_FILE"
fi