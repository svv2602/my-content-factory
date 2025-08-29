# 🚀 Настройка персонализированной контент-фабрики

## 📋 ЧЕКЛИСТ НАСТРОЙКИ

### 1. ПОЛУЧЕНИЕ API КЛЮЧЕЙ

#### 🤖 OpenRouter (для генерации текста)
- Регистрация: https://openrouter.ai
- Получение ключа: https://openrouter.ai/keys  
- Пополнение: минимум $5
- Модели: GPT-4o, Claude-3.5-Sonnet, Llama-3.1

#### 🎤 ElevenLabs (для озвучки)
- Регистрация: https://elevenlabs.io
- Подписка: минимум Starter ($5/месяц)
- API ключ: https://elevenlabs.io/app/settings/api-keys
- Клонирование голоса: загрузить свой аудио образец

#### 👤 HeyGen (для AI аватаров)  
- Регистрация: https://app.heygen.com
- Подписка: минимум Creator ($24/месяц)
- API ключ: https://app.heygen.com/settings (Subscriptions & API)
- Создание аватара: https://app.heygen.com/avatars

#### 🎨 OpenAI (для изображений)
- Регистрация: https://platform.openai.com
- Подтверждение организации (паспорт)
- API ключ: https://platform.openai.com/api-keys
- Пополнение: минимум $20

#### 🎵 PiAPI/Udio (для музыки)
- Регистрация: https://piapi.ai
- API ключ: https://piapi.ai/workspace/key
- Пополнение: минимум $10

#### 📱 Telegram Bot (интерфейс)
- Создание бота: @BotFather
- Получение token
- Узнать свой ID: @userinfobot

### 2. НАСТРОЙКА .env ФАЙЛА

```bash
# Скопировать ваши ключи в .env файл:
nano .env
```

### 3. ПОЛУЧЕНИЕ ПЕРСОНАЛЬНЫХ ID

#### Avatar ID (HeyGen):
1. Запустить n8n: `docker compose up -d`
2. Открыть: http://localhost:5678
3. Импортировать workflow
4. Выполнить ноду "Avatar list"
5. Скопировать ваш avatar_id

#### Voice ID (ElevenLabs):
1. Выполнить ноду "Voices list"  
2. Скопировать ваш voice_id

### 4. ТЕСТИРОВАНИЕ

```bash
# Запуск системы
docker compose up -d

# Проверка логов
docker compose logs -f

# Остановка
docker compose down
```

## 🔧 ДОПОЛНИТЕЛЬНЫЕ УЛУЧШЕНИЯ

### Кастомизация промптов
- Редактирование нод "Script generator"
- Настройка стиля под вашу нишу
- A/B тестирование разных подходов

### Мониторинг и аналитика
- Логи в n8n_data/logs/
- Webhook для уведомлений об ошибках
- Статистика использования API

### Автоматизация публикации
- Интеграция с YouTube API
- Автопостинг в Instagram/TikTok
- Планировщик контента

## 🆘 ПОДДЕРЖКА

При проблемах:
1. Проверить логи: `docker compose logs`
2. Проверить .env файл
3. Убедиться в наличии всех API ключей
4. Проверить баланс на API сервисах

