# 🏭 Персонализированная контент-фабрика на n8n

> **Автоматизированная система создания вирусного видеоконтента с AI-аватарами**

![n8n](https://img.shields.io/badge/n8n-EA4B71?style=for-the-badge&logo=n8n&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![AI](https://img.shields.io/badge/AI-Powered-green?style=for-the-badge)

## 🎯 Что делает эта система?

Автоматически создает **полноценные видеоролики** для социальных сетей:
- 📝 **Генерирует сценарии** на основе вашей идеи
- 👤 **Создает видео с AI-аватаром** (ваш персональный клон)  
- 🎤 **Озвучивает клонированным голосом**
- 🎨 **Добавляет фоновые изображения**
- 🎵 **Подбирает музыку**
- 📺 **Монтирует финальное видео** с субтитрами

**Результат**: готовое вертикальное видео 720x1280 для Instagram Reels/TikTok/YouTube Shorts

## 🚀 БЫСТРЫЙ СТАРТ

### 1. Подготовка
```bash
# Клонирование репозитория (если еще не сделано)
git clone <repository-url>
cd n8n-avatar-generator

# Проверка Docker
docker --version
docker-compose --version
```

### 2. Настройка переменных окружения
```bash
# Скопировать шаблон конфигурации
cp .env .env.backup  # резервная копия
nano .env            # редактировать ваши ключи
```

**Заполните в .env файле:**
- `TELEGRAM_BOT_TOKEN` - от @BotFather
- `TELEGRAM_CHAT_ID` - ваш Telegram ID (от @userinfobot)
- `OPENROUTER_API_KEY` - https://openrouter.ai/keys
- `ELEVENLABS_API_KEY` - https://elevenlabs.io/app/settings/api-keys  
- `HEYGEN_API_KEY` - https://app.heygen.com/settings
- `OPENAI_API_KEY` - https://platform.openai.com/api-keys
- `PIAPI_API_KEY` - https://piapi.ai/workspace/key

### 3. Автоматический запуск
```bash
# Запуск с проверкой конфигурации
./setup.sh
```

### 4. Настройка в n8n
1. Откройте http://localhost:5678
2. Импортируйте `n8n-telegram-improved.json`
3. Настройте credentials для всех API сервисов
4. Получите ваши `avatar_id` и `voice_id` (см. инструкцию ниже)
5. Активируйте workflow

## 📋 ПОЛУЧЕНИЕ ПЕРСОНАЛЬНЫХ ID

### Avatar ID (HeyGen)
1. В n8n выполните ноду "Avatar list"
2. Найдите ваш аватар в результатах  
3. Скопируйте `avatar_id`
4. Добавьте в .env: `HEYGEN_AVATAR_ID=ваш_id`

### Voice ID (ElevenLabs)  
1. Выполните ноду "Voices list"
2. Найдите ваш клонированный голос
3. Скопируйте `voice_id`
4. Добавьте в .env: `ELEVENLABS_VOICE_ID=ваш_id`

## 🎛️ ИСПОЛЬЗОВАНИЕ

### Через Telegram
1. Напишите идею видео вашему боту
2. Система автоматически:
   - Создаст сценарий
   - Сгенерирует изображения
   - Создаст видео с аватаром
   - Добавит музыку
   - Отправит готовое видео

### Через n8n интерфейс
1. Откройте первую ноду "When chat message received"
2. Нажмите "Open chat"
3. Введите идею видео

## 🔧 МОНИТОРИНГ И ОТЛАДКА

```bash
# Проверка статуса
./monitor.sh status

# Просмотр логов
./monitor.sh logs

# Полная диагностика
./monitor.sh full

# Создание бэкапа
./monitor.sh backup
```

## 📊 СТОИМОСТЬ ИСПОЛЬЗОВАНИЯ

### Минимальные тарифы:
- **OpenRouter**: $5/месяц (GPT-4o, Claude)
- **ElevenLabs**: $5/месяц (Starter)
- **HeyGen**: $24/месяц (Creator)
- **OpenAI**: $20/месяц (DALL-E)
- **PiAPI**: $10/месяц (Udio)

**Итого**: ~$64/месяц для полного функционала

### Примерная стоимость 1 видео:
- Сценарий: $0.01
- Изображения: $0.04  
- Видео с аватаром: $0.30
- Музыка: $0.05
- **Итого**: ~$0.40 за видео

## 🎨 КАСТОМИЗАЦИЯ

### Изменение стиля контента
Отредактируйте `custom-prompts.json`:
```json
{
  "settings": {
    "content_style": "professional", // или "casual", "educational"
    "target_audience": "предприниматели",
    "video_duration": 90
  }
}
```

### Настройка под нишу
В файле `custom-prompts.json` выберите вашу нишу:
- `lifestyle` - лайфхаки, здоровье, отношения
- `business` - бизнес, финансы, карьера  
- `tech` - технологии, AI, гаджеты
- `education` - обучение, навыки, курсы

## 🔄 УЛУЧШЕНИЯ В ЭТОЙ ВЕРСИИ

✅ **Безопасность**
- Все API ключи в переменных окружения
- Нет хардкода в workflow файлах

✅ **Мониторинг**  
- Уведомления об ошибках в Telegram
- Статистика генерации
- Логирование всех этапов

✅ **Гибкость**
- Настраиваемые промпты
- Поддержка разных ниш
- Кастомизация под аудиторию

✅ **Автоматизация**
- Скрипт автоматической настройки
- Проверка конфигурации
- Мониторинг системы

## 📁 СТРУКТУРА ПРОЕКТА

```
n8n-avatar-generator/
├── .env                        # Ваши API ключи
├── setup.sh                    # Автоматическая настройка
├── monitor.sh                  # Мониторинг системы
├── docker-compose.yml          # Docker конфигурация
├── n8n-telegram-improved.json  # Улучшенный Telegram workflow  
├── n8n-local-improved.json     # Улучшенный локальный workflow
├── custom-prompts.json         # Настройки промптов
├── prompts-config.js           # Конфигурация промптов
└── setup-guide.md             # Подробная инструкция
```

## 🆘 ПОДДЕРЖКА

### При проблемах:
1. **Проверьте логи**: `./monitor.sh logs`
2. **Проверьте .env**: `./monitor.sh env`  
3. **Проверьте статус**: `./monitor.sh status`
4. **Создайте бэкап**: `./monitor.sh backup`

### Частые проблемы:
- **n8n не запускается** → Проверьте Docker, порт 5678
- **Ошибки API** → Проверьте ключи и баланс
- **Видео не создается** → Проверьте avatar_id и voice_id

## 🎯 ROADMAP

- [ ] Интеграция с YouTube API (автопубликация)
- [ ] Поддержка Instagram API
- [ ] A/B тестирование заголовков
- [ ] Аналитика эффективности контента
- [ ] Планировщик публикаций
- [ ] Мультиязычность

## 📄 ЛИЦЕНЗИЯ

MIT License - свободное использование и модификация

---

**🚀 Начните создавать вирусный контент уже сегодня!**

> *Автоматизируйте рутину, фокусируйтесь на креативе*

