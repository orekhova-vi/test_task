# Задание №1

У нас есть 3 таблицы с различными типами подозрительной активности у клиента: Violation_a, Violation_b, Violation_c.

***Таблица №1:***
Violation_a

dt TIMESTAMP,          -- Дата и время нарушения<br/>
employer BIGINT,       -- клиент (ID)<br/>
user BIGINT,           -- пользователь (ID)<br/>
attempts_count INT,    -- Количество попыток<br/>
PRIMARY KEY (dt, employer, user) -- Составной первичный ключ<br/>

***Таблица №2:***
Violation_b

date VARCHAR(10),      -- Дата нарушения (формат строки'YYYY-MM-DD')<br/>
employer BIGINT,       -- клиент (ID)<br/>
user BIGINT,           -- пользователь (ID)<br/>
views_count INT,       -- Количество просмотров<br/>
PRIMARY KEY (date, employer, user) -- Составной первичный ключ<br/>

***Таблица №3:***
Violation_с

dt TIMESTAMP,          -- Дата и время нарушения<br/>
employer VARCHAR(50),  -- клиент (ID)<br/>
user BIGINT,           -- пользователь (ID)<br/>
has_access BOOLEAN,    -- Наличие доступа (TRUE/FALSE)<br/>
PRIMARY KEY (dt, employer, user) -- Составной первичный ключ<br/>
##
<h4>Создадим таблицы и внесем данные с учетом всех необходимых условий. </h4>

***Violation_a:***<br/>
<img src="https://github.com/user-attachments/assets/8b5ce841-ca9d-438a-9ec6-080955036062" alt="image" width="500" height="400">

***Violation_b:***<br/>
<img src="https://github.com/user-attachments/assets/85a8fc5a-3759-4295-81c8-efef5e7703c9" alt="image" width="500" height="400">

***Violation_c:***<br/>
<img src="https://github.com/user-attachments/assets/3d317c6d-3cce-4796-a577-a545caf61e9d" alt="image" width="500" height="400">

<h4> Для таблицы Violation_a все записи считаются нарушениями, поэтому агрегируем данные по полям клиент (employer) и дате (dt) и посчитаем количество нарушителей и суммарное количество попыток. </h4>
```sql
SELECT 
    DATE(dt) AS day, 
    employer, 
    COUNT(DISTINCT user) AS violators_a, 
    SUM(attempts_count) AS attempts_count
FROM Violation_a
GROUP BY DATE(dt), employer;
```

