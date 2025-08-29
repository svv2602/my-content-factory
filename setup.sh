#!/bin/bash

# 🚀 Автоматическая настройка контент-фабрики n8n

echo "🚀 Настройка персонализированной контент-фабрики"
echo "================================================"

# Проверка наличия Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker не установлен. Установите Docker сначала."
    echo "📖 Инструкция: https://docs.docker.com/get-docker/"
    exit 1
fi

if ! command -v docker-compose &> /dev/null && ! command -v docker compose &> /dev/null; then
    echo "❌ Docker Compose не установлен."
    exit 1
fi

echo "✅ Docker установлен"

# Проверка .env файла
if [ ! -f ".env" ]; then
    echo "❌ Файл .env не найден!"
    echo "Скопируйте .env.example в .env и заполните ваши ключи."
    exit 1
fi

# Проверка основных переменных
source .env

missing_vars=()

if [ -z "$TELEGRAM_BOT_TOKEN" ] || [ "$TELEGRAM_BOT_TOKEN" = "YOUR_BOT_TOKEN_FROM_BOTFATHER" ]; then
    missing_vars+=("TELEGRAM_BOT_TOKEN")
fi

if [ -z "$TELEGRAM_CHAT_ID" ] || [ "$TELEGRAM_CHAT_ID" = "YOUR_TELEGRAM_USER_ID" ]; then
    missing_vars+=("TELEGRAM_CHAT_ID")
fi

if [ -z "$OPENROUTER_API_KEY" ] || [ "$OPENROUTER_API_KEY" = "YOUR_OPENROUTER_API_KEY" ]; then
    missing_vars+=("OPENROUTER_API_KEY")
fi

if [ ${#missing_vars[@]} -gt 0 ]; then
    echo "❌ Не заполнены обязательные переменные в .env:"
    for var in "${missing_vars[@]}"; do
        echo "   - $var"
    done
    echo ""
    echo "📝 Отредактируйте .env файл и заполните ваши ключи"
    exit 1
fi

echo "✅ Основные переменные .env заполнены"

# Создание необходимых директорий
mkdir -p n8n_data/logs
mkdir -p n8n_data/backups

echo "✅ Созданы необходимые директории"

# Остановка существующих контейнеров
echo "🔄 Остановка существующих контейнеров..."
docker-compose down 2>/dev/null || docker compose down 2>/dev/null

# Сборка и запуск
echo "🔧 Сборка и запуск контейнеров..."
if command -v docker-compose &> /dev/null; then
    docker-compose up --build -d
else
    docker compose up --build -d
fi

if [ $? -eq 0 ]; then
    echo "✅ n8n успешно запущен!"
    echo ""
    echo "🌐 Откройте в браузере: http://localhost:5678"
    echo "👤 Логин: $N8N_BASIC_AUTH_USER"
    echo "🔑 Пароль: $N8N_BASIC_AUTH_PASSWORD"
    echo ""
    echo "📋 СЛЕДУЮЩИЕ ШАГИ:"
    echo "1. Импортируйте n8n-telegram-improved.json в n8n"
    echo "2. Настройте credentials для всех API сервисов"
    echo "3. Получите ваши avatar_id и voice_id"
    echo "4. Обновите эти ID в .env файле"
    echo "5. Активируйте workflow и протестируйте"
    echo ""
    echo "📖 Подробные инструкции в setup-guide.md"
else
    echo "❌ Ошибка при запуске контейнеров"
    echo "📋 Проверьте логи: docker-compose logs"
    exit 1
fi

# Показать статус
echo ""
echo "📊 СТАТУС КОНТЕЙНЕРОВ:"
if command -v docker-compose &> /dev/null; then
    docker-compose ps
else
    docker compose ps
fi

echo ""
echo "📋 ПОЛЕЗНЫЕ КОМАНДЫ:"
echo "   Логи:        docker-compose logs -f"
echo "   Остановка:   docker-compose down"
echo "   Перезапуск:  docker-compose restart"
echo "   Статус:      docker-compose ps"

