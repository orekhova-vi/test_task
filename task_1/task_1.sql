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