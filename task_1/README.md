# 📝 Задание №1

У нас есть 3 таблицы с различными типами подозрительной активности у клиента: `Violation_a`, `Violation_b`, `Violation_c`.

## 🗂 Описание таблиц

### Таблица №1: Violation_a
```sql
Violation_a (
    dt TIMESTAMP,          -- Дата и время нарушения
    employer BIGINT,       -- клиент (ID)
    user BIGINT,           -- пользователь (ID)
    attempts_count INT,    -- Количество попыток
    PRIMARY KEY (dt, employer, user) -- Составной первичный ключ
)
```

### Таблица №2: Violation_b
```sql
Violation_b (
    date VARCHAR(10),      -- Дата нарушения (формат строки 'YYYY-MM-DD')
    employer BIGINT,       -- клиент (ID)
    user BIGINT,           -- пользователь (ID)
    views_count INT,       -- Количество просмотров
    PRIMARY KEY (date, employer, user) -- Составной первичный ключ
)
```

### Таблица №3: Violation_c
```sql
Violation_c (
    dt TIMESTAMP,          -- Дата и время нарушения
    employer VARCHAR(50),  -- клиент (ID)
    user BIGINT,           -- пользователь (ID)
    has_access BOOLEAN,    -- Наличие доступа (TRUE/FALSE)
    PRIMARY KEY (dt, employer, user) -- Составной первичный ключ
)
```

## 📊Создадим таблицы и внесем данные с учетом всех необходимых условий. 

***Violation_a:***<br/>
<img src="https://github.com/user-attachments/assets/8b5ce841-ca9d-438a-9ec6-080955036062" alt="image" width="500" height="400">

***Violation_b:***<br/>
<img src="https://github.com/user-attachments/assets/85a8fc5a-3759-4295-81c8-efef5e7703c9" alt="image" width="500" height="400">

***Violation_c:***<br/>
<img src="https://github.com/user-attachments/assets/b7d57e71-9cdb-4f2f-a77d-233edd57d8fe" alt="image" width="500" height="400">

##

<h3> Шаги решения задачи: </h3>
1. Для таблицы Violation_a все записи считаются нарушениями, поэтому агрегируем данные по полям клиент (employer) и дате (dt) и посчитаем количество нарушителей и суммарное количество попыток. <br/>
<br/>
2. Для таблицы Violation_b нарушившими считаются, все те клиенты, которые суммарно за день посмотрели более 500 просмотров (views_count>500), поэтому агрегируем данные по полям клиент (employer) и дате (date), используем оператор HAVING для фильтрации результатов запроса на основе указанных ранее условий. <br/>
<br/>
3. Для таблицы Violation_с нарушившими считаются, все те клиенты, у которых хотя бы два пользователя имели доступ, поэтому агрегируем данные по полям клиент (employer) и дате (dt), и считаем количество уникальных пользователей у которых есть доступ, далее фильтруем это количество по условию.<br/>
<br/>
4. Аккумулируем все наши результаты, которые мы описали выше в единый запрос. Тут будем использовать конструкцию WITH, для создания временных таблиц, объеденим все таблицы используя FULL JOIN, чтобы мы могли учесть все возможные комбинации.<br/>
<br/>
*приводим типы данных к общему формату, для таблицы Violations_b поле date приводим к типу data, а в таблице Violation_с поле employer к типу BIGINT.<br/> 

##

***📌ИТОГ:*** формируем итоговую таблицу, которая содержит информацию о трех типах нарушений для каждого клиента за каждый день.
<img src="https://github.com/user-attachments/assets/3008edb3-3683-4a4d-aa03-9c9e26c45d8b" alt="image" width="1000" height="300">




