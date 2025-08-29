#!/usr/bin/env python3
"""
Скрипт для обновления n8n workflow с переменными окружения
"""
import json
import sys
import os

def update_telegram_workflow():
    """Обновляет Telegram workflow для использования переменных окружения"""
    
    # Читаем исходный файл
    with open('n8n-telegram.json.backup', 'r', encoding='utf-8') as f:
        workflow = json.load(f)
    
    # Список всех нод для обновления
    updates_made = 0
    
    for node in workflow.get('nodes', []):
        node_name = node.get('name', '')
        parameters = node.get('parameters', {})
        
        # Обновляем chatId во всех Telegram нодах
        if 'chatId' in parameters:
            old_chat_id = parameters['chatId']
            if old_chat_id == "440211885":
                parameters['chatId'] = "={{ $env.TELEGRAM_CHAT_ID }}"
                updates_made += 1
                print(f"✅ Обновлен chatId в ноде: {node_name}")
        
        # Обновляем настройки видео-генерации
        if node_name == "video generation settings":
            js_code = parameters.get('jsCode', '')
            if 'avatar_id' in js_code and '42bf901fcab54935915a291c7206064c' in js_code:
                # Заменяем жестко заданные ID на переменные окружения
                js_code = js_code.replace(
                    '"avatar_id": "42bf901fcab54935915a291c7206064c"',
                    '"avatar_id": process.env.HEYGEN_AVATAR_ID'
                )
                js_code = js_code.replace(
                    '"voice_id": "91f2ee24f76044619c34cb60a038b0d6"',
                    '"voice_id": process.env.ELEVENLABS_VOICE_ID'
                )
                js_code = js_code.replace(
                    '"speed": 1.1',
                    '"speed": parseFloat(process.env.VIDEO_SPEED || "1.1")'
                )
                js_code = js_code.replace(
                    '"value": "#0000ff"',
                    '"value": process.env.VIDEO_BACKGROUND_COLOR || "#0000ff"'
                )
                js_code = js_code.replace(
                    '"width": 720',
                    '"width": parseInt(process.env.VIDEO_WIDTH || "720")'
                )
                js_code = js_code.replace(
                    '"height": 1280',
                    '"height": parseInt(process.env.VIDEO_HEIGHT || "1280")'
                )
                
                parameters['jsCode'] = js_code
                updates_made += 1
                print(f"✅ Обновлены настройки видео в ноде: {node_name}")
        
        # Добавляем обработку ошибок в критически важные ноды
        if node_name in ["Generate video", "Script generator", "Generate an image"]:
            if 'onError' not in node:
                node['onError'] = 'continueRegularOutput'
                node['continueOnFail'] = True
                updates_made += 1
                print(f"✅ Добавлена обработка ошибок в ноду: {node_name}")
    
    # Добавляем новые ноды для мониторинга
    monitoring_nodes = []
    
    # Нода для уведомлений об ошибках
    error_notification_node = {
        "parameters": {
            "chatId": "={{ $env.TELEGRAM_CHAT_ID }}",
            "text": "❌ Ошибка в процессе генерации контента:\n\n{{ $json.error?.message || 'Неизвестная ошибка' }}\n\nВремя: {{ $now.format('DD.MM.YYYY HH:mm:ss') }}",
            "additionalFields": {}
        },
        "type": "n8n-nodes-base.telegram",
        "typeVersion": 1.2,
        "position": [100, 100],
        "id": "error-notification-" + str(hash("error_notification"))[-8:],
        "name": "🚨 Error Notification",
        "credentials": {
            "telegramApi": {
                "id": "telegram-creds",
                "name": "Telegram Bot"
            }
        }
    }
    
    # Нода для статистики
    stats_node = {
        "parameters": {
            "chatId": "={{ $env.TELEGRAM_CHAT_ID }}",
            "text": "📊 Статистика генерации:\n\n📝 Сценарий: готов\n🎬 Видео: {{ $('Generate video').json.data?.status || 'в процессе' }}\n🎵 Музыка: {{ $('Get udio song').json.status || 'в процессе' }}\n\n⏰ Время: {{ $now.format('DD.MM.YYYY HH:mm:ss') }}",
            "additionalFields": {}
        },
        "type": "n8n-nodes-base.telegram",
        "typeVersion": 1.2,
        "position": [200, 100],
        "id": "stats-notification-" + str(hash("stats"))[-8:],
        "name": "📊 Stats Notification",
        "credentials": {
            "telegramApi": {
                "id": "telegram-creds",
                "name": "Telegram Bot"
            }
        }
    }
    
    monitoring_nodes.extend([error_notification_node, stats_node])
    
    # Добавляем новые ноды в workflow
    workflow['nodes'].extend(monitoring_nodes)
    updates_made += len(monitoring_nodes)
    print(f"✅ Добавлено {len(monitoring_nodes)} нод мониторинга")
    
    # Сохраняем обновленный файл
    with open('n8n-telegram-improved.json', 'w', encoding='utf-8') as f:
        json.dump(workflow, f, ensure_ascii=False, indent=2)
    
    print(f"\n🎉 Workflow обновлен! Сделано изменений: {updates_made}")
    print("📁 Сохранен как: n8n-telegram-improved.json")
    
    return updates_made

def update_local_workflow():
    """Обновляет локальный workflow"""
    
    with open('n8n-local.json', 'r', encoding='utf-8') as f:
        workflow = json.load(f)
    
    updates_made = 0
    
    for node in workflow.get('nodes', []):
        node_name = node.get('name', '')
        parameters = node.get('parameters', {})
        
        # Обновляем настройки видео-генерации
        if node_name == "video generation settings":
            js_code = parameters.get('jsCode', '')
            if 'avatar_id' in js_code:
                js_code = js_code.replace(
                    '"avatar_id": "42bf901fcab54935915a291c7206064c"',
                    '"avatar_id": process.env.HEYGEN_AVATAR_ID'
                )
                js_code = js_code.replace(
                    '"voice_id": "91f2ee24f76044619c34cb60a038b0d6"',
                    '"voice_id": process.env.ELEVENLABS_VOICE_ID'
                )
                parameters['jsCode'] = js_code
                updates_made += 1
                print(f"✅ Обновлены настройки видео в локальном workflow")
    
    with open('n8n-local-improved.json', 'w', encoding='utf-8') as f:
        json.dump(workflow, f, ensure_ascii=False, indent=2)
    
    print(f"✅ Локальный workflow обновлен! Изменений: {updates_made}")
    return updates_made

if __name__ == "__main__":
    print("🚀 Обновление n8n workflows...")
    
    telegram_updates = update_telegram_workflow()
    local_updates = update_local_workflow()
    
    total_updates = telegram_updates + local_updates
    
    print(f"\n📋 ИТОГО:")
    print(f"   Telegram workflow: {telegram_updates} изменений")
    print(f"   Local workflow: {local_updates} изменений")
    print(f"   Всего: {total_updates} изменений")
    
    print(f"\n📝 СЛЕДУЮЩИЕ ШАГИ:")
    print(f"   1. Заполните .env файл своими ключами")
    print(f"   2. Импортируйте n8n-telegram-improved.json в n8n")
    print(f"   3. Настройте credentials для всех API сервисов")
    print(f"   4. Протестируйте workflow")

