-- Solution for LeetCode 180: Consecutive Numbers
-- Difficulty: Medium

/*
Problem Statement:
Write an SQL query to find all numbers that appear at least four times consecutively.
Return the result table in any order.

Example Input (Logs):
| id | num |
|----|-----|
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |

Expected Output:
| ConsecutiveNums |
|-----------------|
| 1               |

Schema & DML Data:
*/
USE practice_sql_db;

DROP TABLE IF EXISTS Logs;

CREATE TABLE Logs (id INT, num INT);

INSERT INTO
    Logs (id, num)
VALUES (1, 1),
    (2, 1),
    (3, 1),
    (4, 2),
    (5, 1),
    (6, 2),
    (7, 2),
    (8, 2),
    (9, 2),
    (10, 3),
    (11, 3),
    (12, 3),
    (13, 3);

-- ==========================================
-- Your Sol
-- ==========================================

-- Approach: Island Grouping (Gaps & Islands)
-- id - ROW_NUMBER() gives the same value for consecutive rows with the same num,
-- effectively grouping them into "islands".
SELECT *
FROM (
    SELECT 
        *,
         ROW_NUMBER() OVER (PARTITION BY num ORDER BY id) rank_,
        id - ROW_NUMBER() OVER (PARTITION BY num ORDER BY id) AS island_grp
    FROM Logs
) t
ORDER BY 1

-- GROUP BY num, island_grp
-- HAVING COUNT(*) >= 3;

-- ==========================================
-- Solutions Provided
-- ==========================================

/*
-- Approach 1: Three-way Join
-- We join the table with itself 3 times to find 3 consecutive IDs with the same number.
SELECT DISTINCT l1.num AS ConsecutiveNums
FROM Logs l1
JOIN Logs l2 ON l1.id = l2.id - 1
JOIN Logs l3 ON l2.id = l3.id - 1
WHERE l1.num = l2.num
AND l2.num = l3.num;

-- Approach 2: Using Window Functions (LEAD/LAG)
-- This is often more efficient on larger datasets.
SELECT DISTINCT num AS ConsecutiveNums
FROM (
SELECT num,
LEAD(num, 1) OVER (ORDER BY id) AS next_1,
LEAD(num, 2) OVER (ORDER BY id) AS next_2
FROM Logs
) t
WHERE num = next_1 AND num = next_2;
*/
