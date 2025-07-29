# n8n-avatar-generator

1. Установить Docker на свой компьютер ([как это сделать](https://docs.docker.com/desktop/setup/install/mac-install/))
2. Создать папку "n8n"
3. Скачать в эту папку файл Dockerfile, docker-compose.yml (они лежат в этом репозитории рядом), либо склонировать этот репозиторий себе через git
4. Также в этой папке создать файл .env с содержимым 
```.env
GENERIC_TIMEZONE=Europe/Moscow # ваш часовой пояс
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin 
N8N_BASIC_AUTH_PASSWORD=strongpassword # пароль, какой хотите
```
5. Открыть папку в терминале
6. Запустить команду docker compose up -d
7. Открыть в браузере http://localhost:5678/
8. Зарегистрироваться
9. Нажать "+" в верхнем левом углу -> Workflow ![text][(./images/1.png)
10. В левом нижнем углу нажать "..." -> Settings -> Community nodes -> Install a community node -> "@elevenlabs/n8n-nodes-elevenlabs" ![images/Pasted image 20250729210005.png]
11. В правом верхнем углу нажать "..." -> Import from file -> Выбрать файл n8n-local.json (или n8n-telegram.json если запускаете на сервере и хотите задавать начальный промпт через телеграм бота)
12. Кликните 2 раза в ноду "Send a text message" и нажмите "Select Credential" -> "Create new credential"![images/Pasted image 20250729210733.png]
13. Вставьте Access token вашего бота, который вам дал @BotFather, нажмите save
14. Аналогичным образом кликните на ноду "Get titles" и добавьте Credentials, проставив в поле API Key ваш ключ от OpenRouter API, который можно сгенерировать на https://openrouter.ai. В base url введите https://openrouter.ai/api/v1. Нажмите save
15. Аналогичным образом настройте Credentials для HeyGen, нажав дважды на "Avatar list" и прописав Name "X-Api-Key", а Value = API ключ от HeyGen сгенерировав его тут https://app.heygen.com/settings?from=&nav=Subscriptions%20%26%20API. Чтобы не запутаться предлагаю назвать эту авторизацию "HeyGen" в левом верхнем углу (нужно зарегистрироваться)![Pasted image 20250729212607.png]
16. Аналогично настроить авторизацию для ноды "Transcribe audio or video", введя свой API ключ от ElevenLabs отсюда https://elevenlabs.io/app/settings/api-keys (нужно зарегистрироваться и купить минимальную подписку)
17. Затем нужно докинуть авторизацию для piapi, чтобы генерировать музыку в Udio. Откройте ноду "Generate udio song". Нажмите Header Auth -> Create new credential![Pasted image 20250729213142.png]
18. Проставьте X-API-KEY как Name и ваш API ключ от https://piapi.ai/workspace/key (нужно зарегистрироваться и пополнить минимально аккаунт). Эту авторизацию можно назвать PiApi![Pasted image 20250729213507.png]
19. Проставить эту же авторизацию для ноды "Get udio song", выбрав ее в списке![Pasted image 20250729213648.png]
20. Настроить Credential для OpenAI ноды генерации изображений "Generate an image", дважды кликнув на нее и создав еще одни креды ![Pasted image 20250729213839.png]
21. Прописать API Key, сгенерированный тут https://platform.openai.com/settings/organization/general (нужно зарегистрироваться и подтвердить организацию через паспорт тут https://platform.openai.com/settings/organization/general)![Снимок экрана 2025-07-29 в 21.40.13.png]
22. Создайте свой видео аватар на https://app.heygen.com/avatars
23. Склонируйте свой голос в Elevenlabs и подключите его к своему аватару, как я показываю в ютуб видео
24. Выполните ноду "Avatar list", нажав "Execute step", чтобы увидеть список своих аватаров![Pasted image 20250729214510.png]
25. Найдите свой аватар по имени, скопируйте его avatar_id и вставьте в json ноды "video generation settings"![Pasted image 20250729214800.png]
26. Аналогично сделайте с голосом, вызвав "Voices list" и затем заменив voice_id в json ноды "video generation settings"
27. Активируйте ваш workflow сверху ![Pasted image 20250729215014.png]
28. Затем у самой первой ноды нажмите "Open chat"![Pasted image 20250729215118.png]
29. И теперь можете использовать генератор видео, вводя свою идею видео в открывшийся чат (если вы настраивали на сервере и использовали n8n-telegram.json, то пишите свою идеи в диалог с вашим телеграм ботом + не забудьте поставить свой telegram id в ноду "if it's from me", чтобы принимать сообщения только от вас, telegram id можно узнать у бота @userdatailsbot + замените localhost:5678 на ваш ip или домен в ноде "image generation web hook request")
30. Если что-то не работает, пишите сюда https://t.me/oleg_code в телеграм
