-- Создание таблицы Violation_a
CREATE TABLE Violation_a (
    dt TIMESTAMP,          
    employer BIGINT,       
    users BIGINT,           
    attempts_count INT,    
    PRIMARY KEY (dt, employer, users) 
);

-- Создание таблицы Violation_b
CREATE TABLE Violation_b (    
    date VARCHAR(10),           
    employer BIGINT,       
    users BIGINT,           
    views_count INT,       
    PRIMARY KEY (date, employer, users) 
);

-- Создание таблицы Violation_с
CREATE TABLE Violation_c (
    dt TIMESTAMP,         
    employer VARCHAR(50),       
    users BIGINT,           
    has_access BOOLEAN,  
    PRIMARY KEY (dt, employer, users) 
);

-- Шаг 1
SELECT 
    DATE(dt) AS day, 
    employer, 
    COUNT(DISTINCT users) AS violators_a, 
    SUM(attempts_count) AS attempts_count
FROM Violation_a
GROUP BY DATE(dt), employer;

-- Шаг 2
SELECT 
    date AS day, 
    employer, 
    COUNT(DISTINCT users) AS violators_b, 
    SUM(views_count) AS views_count
FROM Violation_b
GROUP BY date, employer
HAVING SUM(views_count) > 500;

-- Шаг 3
SELECT 
	DATE(dt) AS day, 
	employer::bigint AS employer, 
	COUNT(DISTINCT CASE WHEN has_access = TRUE THEN users END) AS violators_with_access, 
	COUNT(DISTINCT CASE WHEN has_access = FALSE THEN users END) AS violators_without_access
FROM Violation_c
GROUP BY DATE(dt), employer::bigint
HAVING COUNT(DISTINCT CASE WHEN has_access = TRUE THEN users END) >= 2

-- Шаг 4
WITH violations_a AS (
    SELECT 
        DATE(dt) AS day, 
        employer, 
        COUNT(DISTINCT users) AS violators_a, 
        SUM(attempts_count) AS attempts_count
    FROM Violation_a
    GROUP BY DATE(dt), employer
),
violations_b AS (
    SELECT 
        date::date AS day, 
        employer, 
        COUNT(DISTINCT users) AS violators_b, 
        SUM(views_count) AS views_count
    FROM Violation_b
    GROUP BY date::date, employer
    HAVING SUM(views_count) > 500
),
violations_c AS (
    SELECT 
    	DATE(dt) AS day, 
    	employer::bigint AS employer, 
    	COUNT(DISTINCT CASE WHEN has_access = TRUE THEN users END) AS violators_with_access, 
    	COUNT(DISTINCT CASE WHEN has_access = FALSE THEN users END) AS violators_without_access
    FROM Violation_c
    GROUP BY DATE(dt), employer::bigint
    HAVING COUNT(DISTINCT CASE WHEN has_access = TRUE THEN users END) >= 2
)
SELECT 
    a.day, 
    a.employer, 
    a.violators_a, 
    a.attempts_count, 
    b.violators_b, 
    b.views_count, 
    c.violators_with_access, 
    c.violators_without_access
FROM violations_a a
FULL JOIN violations_b b ON a.day = b.day AND a.employer = b.employer
FULL JOIN violations_c c ON a.day = c.day AND a.employer = c.employer
ORDER BY a.day, a.employer;
