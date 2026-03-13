-- ============================================================
-- Recursive CTE — Compounding Salary from Promotions
-- ============================================================
-- Each employee starts with a joining salary. They may receive
-- N promotions, each expressed as a percentage increase applied
-- to the CURRENT salary (not the original). A naive approach of
-- summing all percentages and applying once is WRONG.
--
-- Correct: salary_after_promo_1 = salary × (1 + pct_1/100)
--          salary_after_promo_2 = salary_after_promo_1 × (1 + pct_2/100)
--          ... and so on for all promotions.
--
-- Recursive CTEs iterate this calculation row by row.
-- ============================================================

-- Sample Input:
--
-- Table: emp_base                Table: promotions
-- +--------+---------+-------+  +--------+-------+------------+------+
-- | emp_id | name    | join_sal  | emp_id | promo | promo_date | pct  |
-- +--------+---------+-------+  +--------+-------+------------+------+
-- |   1    | Alice   | 50000 |  |   1    |   1   | 2022-01-15 |  10  |
-- |   2    | Bob     | 40000 |  |   1    |   2   | 2023-03-10 |  20  |
-- |   3    | Carol   | 60000 |  |   2    |   1   | 2022-06-01 |   5  |
-- +--------+---------+-------+  |   3    |   -   |    no promotions  |
--                               +--------+-------+------------+------+
--
-- Expected Output:
-- +--------+-------+----------+-----------------+
-- | emp_id | name  | join_sal | current_salary  |
-- +--------+-------+----------+-----------------+
-- |   1    | Alice |  50000   |   66000.0       |  (50000 × 1.10 × 1.20)
-- |   2    | Bob   |  40000   |   42000.0       |  (40000 × 1.05)
-- |   3    | Carol |  60000   |   60000.0       |  (no promotions)
-- +--------+-------+----------+-----------------+

-- ============================================================
-- DDL & DML
-- ============================================================

DROP TABLE IF EXISTS emp_base;
DROP TABLE IF EXISTS promotions_pct;

CREATE TABLE emp_base (
    emp_id  INT PRIMARY KEY,
    name    VARCHAR(50),
    join_sal DECIMAL(10,2)
);

CREATE TABLE promotions_pct (
    emp_id     INT,
    promo_rank INT,   -- 1 = first promotion, 2 = second, etc.
    promo_date DATE,
    pct        DECIMAL(5,2)
);

INSERT INTO emp_base VALUES
    (1, 'Alice', 50000),
    (2, 'Bob',   40000),
    (3, 'Carol', 60000);

INSERT INTO promotions_pct VALUES
    (1, 1, '2022-01-15', 10),
    (1, 2, '2023-03-10', 20),
    (2, 1, '2022-06-01',  5);

-- ============================================================
-- Hint
-- ============================================================
-- Recursive CTE structure:
--   Anchor   → seed with joining salary, promo_rank = 0
--   Recursive → join with the next promotion (promo_rank + 1),
--               multiply current_sal by (1 + pct / 100)
-- After recursion, take MAX(current_sal) per employee (the last
-- iteration holds the final compounded salary). For employees
-- with no promotions, the anchor row's salary is correct as-is.

-- ============================================================
-- Solution
-- ============================================================

WITH RECURSIVE salary_cte AS (

    -- Anchor: starting point for each employee
    SELECT
        e.emp_id,
        e.name,
        CAST(e.join_sal AS DECIMAL(12,1)) AS current_sal,
        e.join_sal                         AS join_sal,
        0                                  AS promo_rank   -- no promotion applied yet
    FROM emp_base e

    UNION ALL

    -- Recursive: apply next promotion on top of current salary
    SELECT
        s.emp_id,
        s.name,
        CAST(s.current_sal * (1 + p.pct / 100.0) AS DECIMAL(12,1)),
        s.join_sal,
        s.promo_rank + 1
    FROM salary_cte s
    INNER JOIN promotions_pct p
        ON  s.emp_id     = p.emp_id
        AND s.promo_rank + 1 = p.promo_rank   -- join only the next promotion in sequence
)

SELECT
    emp_id,
    name,
    join_sal,
    MAX(current_sal) AS current_salary   -- final iteration = highest rank = final salary
FROM salary_cte
GROUP BY emp_id, name, join_sal
ORDER BY emp_id;

-- ============================================================
-- Cleanup
-- ============================================================
DROP TABLE IF EXISTS emp_base;
DROP TABLE IF EXISTS promotions_pct;
