#!/bin/bash

# 📊 Скрипт мониторинга контент-фабрики

echo "📊 Мониторинг контент-фабрики n8n"
echo "=================================="

# Функция проверки статуса
check_status() {
    echo "🔍 Проверка статуса контейнеров..."
    
    if command -v docker-compose &> /dev/null; then
        COMPOSE_CMD="docker-compose"
    else
        COMPOSE_CMD="docker compose"
    fi
    
    # Статус контейнеров
    $COMPOSE_CMD ps
    
    # Проверка здоровья n8n
    echo ""
    echo "🏥 Проверка здоровья n8n..."
    
    if curl -s http://localhost:5678/healthz &> /dev/null; then
        echo "✅ n8n доступен на http://localhost:5678"
    else
        echo "❌ n8n недоступен"
        echo "🔍 Проверьте логи: $COMPOSE_CMD logs n8n"
    fi
}

# Функция просмотра логов
show_logs() {
    echo "📋 Последние логи n8n:"
    echo "======================"
    
    if command -v docker-compose &> /dev/null; then
        docker-compose logs --tail=50 n8n
    else
        docker compose logs --tail=50 n8n
    fi
}

# Функция проверки использования ресурсов
check_resources() {
    echo "💾 Использование ресурсов:"
    echo "========================="
    
    docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}"
}

# Функция проверки места на диске
check_disk_space() {
    echo "💿 Место на диске:"
    echo "=================="
    
    echo "Общее место на диске:"
    df -h /
    
    echo ""
    echo "Место, занимаемое n8n:"
    du -sh n8n_data/
    
    echo ""
    echo "Docker images:"
    docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" | grep n8n
}

# Функция проверки переменных окружения
check_env() {
    echo "🔧 Проверка конфигурации .env:"
    echo "============================="
    
    if [ ! -f ".env" ]; then
        echo "❌ Файл .env не найден!"
        return 1
    fi
    
    source .env
    
    # Проверка критических переменных
    vars_to_check=(
        "TELEGRAM_BOT_TOKEN"
        "TELEGRAM_CHAT_ID"
        "OPENROUTER_API_KEY"
        "ELEVENLABS_API_KEY"
        "HEYGEN_API_KEY"
        "OPENAI_API_KEY"
        "PIAPI_API_KEY"
    )
    
    for var in "${vars_to_check[@]}"; do
        if [ -n "${!var}" ] && [[ "${!var}" != *"YOUR_"* ]]; then
            echo "✅ $var настроен"
        else
            echo "❌ $var не настроен"
        fi
    done
}

# Функция резервного копирования
backup_data() {
    echo "💾 Создание резервной копии..."
    
    timestamp=$(date +"%Y%m%d_%H%M%S")
    backup_dir="backups/backup_$timestamp"
    
    mkdir -p "$backup_dir"
    
    # Копируем важные файлы
    cp .env "$backup_dir/" 2>/dev/null
    cp -r n8n_data/database.sqlite* "$backup_dir/" 2>/dev/null
    cp n8n-telegram-improved.json "$backup_dir/" 2>/dev/null
    cp n8n-local-improved.json "$backup_dir/" 2>/dev/null
    
    echo "✅ Резервная копия создана: $backup_dir"
}

# Основное меню
case "$1" in
    "status"|"")
        check_status
        ;;
    "logs")
        show_logs
        ;;
    "resources")
        check_resources
        ;;
    "disk")
        check_disk_space
        ;;
    "env")
        check_env
        ;;
    "backup")
        backup_data
        ;;
    "full")
        check_status
        echo ""
        check_env
        echo ""
        check_resources
        echo ""
        check_disk_space
        ;;
    "help")
        echo "Доступные команды:"
        echo "  status     - статус системы (по умолчанию)"
        echo "  logs       - просмотр логов"
        echo "  resources  - использование ресурсов"
        echo "  disk       - использование диска"
        echo "  env        - проверка .env конфигурации"
        echo "  backup     - создание резервной копии"
        echo "  full       - полная проверка"
        echo "  help       - эта справка"
        ;;
    *)
        echo "❌ Неизвестная команда: $1"
        echo "Используйте: ./monitor.sh help"
        exit 1
        ;;
esac

