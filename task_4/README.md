# Задание №4

Есть таблица с логами просмотров вакансий:
</br>
ts – время просмотра</br>
user – ID пользователя</br>
ip – IP-адрес</br>
user_agent – информация об устройстве</br>
vacancy_id – ID вакансии

# 🕵️ Анализ аномальной активности просмотров вакансий

## 📊 1. Определение аномальной активности

### ✅ Нормальное поведение

+ 5-10 просмотров вакансий за сессию
+ Использование стандартных браузеров (Chrome, Firefox)
+ Естественные интервалы между действиями (5-30 сек)

### 🚨 Признаки аномалий

- больше 100 просмотров в минуту от одного пользователя
- Один IP → множество разных пользователей
- User-Agent: Python/curl/пустые значения
- больше 10K просмотров одной вакансии за час
  
## 🔍 2. SQL-анализ активности

👥 ТОП-10 активных пользователей
```sql
SELECT 
    user,
    COUNT(*) AS views,
    MIN(ts) AS first_view,
    MAX(ts) AS last_view,
    COUNT(*) / EXTRACT(EPOCH FROM (MAX(ts)-MIN(ts))) AS req_per_sec
FROM logs
WHERE ts > NOW() - INTERVAL '1 hour'
GROUP BY user
HAVING COUNT(*) > 50
ORDER BY views DESC
LIMIT 10;
```
Метрики анализа:

- более 1000 views/hour - явная аномалия
- req_per_sec > 0.5 - бот-активность
- Ночная активность для дневного сервиса

🌐 Подозрительные IP-адреса
```sql
SELECT
    ip,
    COUNT(DISTINCT user) AS unique_users,
    COUNT(*) AS total_views,
    COUNT(DISTINCT user_agent) AS agents_count
FROM logs
WHERE ts > NOW() - INTERVAL '30 minutes'
GROUP BY ip
HAVING 
    COUNT(*) > 100 OR
    COUNT(DISTINCT user) > 5
ORDER BY total_views DESC;
```

Метрики анализа:

- unique_users > 10 - возможна VPN/прокси
- agents_count = 1 при unique_users > 3 - бот-сеть

🤖 Обнаружение ботов
```sql
SELECT
    CASE
        WHEN user_agent LIKE '%Python%' THEN 'Python-bot'
        WHEN user_agent = '' THEN 'Null user agent'
        ELSE 'Normal'
    END AS agent_type,
    COUNT(*) AS requests,
    COUNT(DISTINCT ip) AS unique_ips
FROM logs
GROUP BY agent_type
ORDER BY requests DESC;
```

## 🛡️ 3. Система триггеров

| Тип аномалии               | Порог срабатывания      | Действие                          |
|----------------------------|-------------------------|-----------------------------------|
| Активность пользователя    | >50 запросов в минуту   | 📢 Средний приоритет              |
| Активность IP-адреса       | >100 запросов за 5 минут| 🔴 Высокий приоритет              |
| Подозрительный User-Agent  | Содержит "Python"       | 🟡 Низкий приоритет               |

