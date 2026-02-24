-- Solution for LeetCode 601: Human Traffic of Stadium

-- Goal: Display the records with three or more rows with consecutive IDs,
-- where the number of people is greater than or equal to 100 for each.

/*
Schema & DML Data:
*/
USE practice_sql_db;

DROP TABLE IF EXISTS Stadium;

CREATE TABLE Stadium (
    id INT,
    visit_date DATE,
    people INT
);

INSERT INTO
    Stadium (id, visit_date, people)
VALUES (1, '2017-01-01', 10),
    (2, '2017-01-02', 109),
    (3, '2017-01-03', 150),
    (4, '2017-01-04', 99),
    (5, '2017-01-05', 145),
    (6, '2017-01-06', 1455),
    (7, '2017-01-07', 199),
    (8, '2017-01-09', 188),
    (9, '2017-01-10', 88), -- Drops below 100 (ends previous streak)
    (10, '2017-01-11', 10);

-- ==========================================
-- Approach 1: Using Windows Functions (LEAD/LAG)
-- We identify rows with people >= 100.
-- Then checking 3 consecutive groups: (prev, curr, next), (prev2, prev1, curr), (curr, next1, next2)

WITH
    Filtered AS (
        SELECT *
        FROM Stadium
        WHERE
            people >= 100
    )
SELECT DISTINCT
    t1.id,
    t1.visit_date,
    t1.people
FROM
    Filtered t1
    LEFT JOIN Filtered t2 ON t1.id = t2.id + 1
    LEFT JOIN Filtered t3 ON t1.id = t3.id + 2
    LEFT JOIN Filtered t4 ON t1.id = t4.id - 1
    LEFT JOIN Filtered t5 ON t1.id = t5.id - 2
WHERE
    -- Case 1: t1, t2, t3 are consecutive (t1 is start) -> t1, t1+1, t1+2
    (
        t2.id IS NOT NULL
        AND t3.id IS NOT NULL
    )
    OR
    -- Case 2: t4, t1, t2 are consecutive (t1 is middle) -> t1-1, t1, t1+1
    (
        t4.id IS NOT NULL
        AND t2.id IS NOT NULL
    )
    OR
    -- Case 3: t5, t4, t1 are consecutive (t1 is end) -> t1-2, t1-1, t1
    (
        t5.id IS NOT NULL
        AND t4.id IS NOT NULL
    )
ORDER BY visit_date;

-- Approach 2: Using LEAD/LAG explicitly if supported
SELECT id, visit_date, people
FROM (
        SELECT
            *, LAG(people, 1) OVER (
                ORDER BY id
            ) as prev1, LAG(people, 2) OVER (
                ORDER BY id
            ) as prev2, LEAD(people, 1) OVER (
                ORDER BY id
            ) as next1, LEAD(people, 2) OVER (
                ORDER BY id
            ) as next2
        FROM Stadium
    ) t
WHERE
    people >= 100
    AND (
        (
            prev1 >= 100
            AND prev2 >= 100
        ) -- Current is 3rd
        OR (
            prev1 >= 100
            AND next1 >= 100
        ) -- Current is 2nd
        OR (
            next1 >= 100
            AND next2 >= 100
        ) -- Current is 1st
    )
ORDER BY visit_date;