-- ============================================================
-- PIVOT (Rows → Columns) and UNPIVOT (Columns → Rows)
-- ============================================================
-- This file covers two transformations:
--   1. PIVOT: convert long-format salary component rows into
--      wide format (one row per employee, one col per component)
--      using CASE WHEN inside SUM (no proprietary PIVOT syntax).
--   2. UNPIVOT: reverse — convert wide format back to long
--      using UNION ALL.
-- ============================================================

-- ============================================================
-- PART 1 — PIVOT
-- ============================================================

-- Sample Input: emp_salary_components
-- +--------+---------------------+--------+
-- | emp_id | component           | amount |
-- +--------+---------------------+--------+
-- |   1    | Salary              | 10000  |
-- |   1    | Bonus               |  5000  |
-- |   1    | HRA                 |  1000  |
-- |   2    | Salary              |  8000  |
-- |   2    | Bonus               |  3000  |
-- |   2    | HRA                 |   800  |
-- +--------+---------------------+--------+
--
-- Expected Pivot Output:
-- +--------+--------+-------+------+
-- | emp_id | Salary | Bonus | HRA  |
-- +--------+--------+-------+------+
-- |   1    | 10000  |  5000 | 1000 |
-- |   2    |  8000  |  3000 |  800 |
-- +--------+--------+-------+------+

-- DDL & DML

DROP TABLE IF EXISTS emp_salary_components;

CREATE TABLE emp_salary_components (
    emp_id    INT,
    component VARCHAR(50),
    amount    INT
);

INSERT INTO emp_salary_components VALUES
    (1, 'Salary', 10000),
    (1, 'Bonus',   5000),
    (1, 'HRA',     1000),
    (2, 'Salary',  8000),
    (2, 'Bonus',   3000),
    (2, 'HRA',      800);

-- Hint: Use CASE WHEN to create a column for each component,
-- then SUM (which ignores NULLs) collapses multiple rows per
-- employee into one. GROUP BY ties it all together.

-- ============================================================
-- Solution: PIVOT
-- ============================================================

SELECT
    emp_id,
    SUM(CASE WHEN component = 'Salary' THEN amount ELSE 0 END) AS Salary,
    SUM(CASE WHEN component = 'Bonus'  THEN amount ELSE 0 END) AS Bonus,
    SUM(CASE WHEN component = 'HRA'    THEN amount ELSE 0 END) AS HRA
FROM emp_salary_components
GROUP BY emp_id
ORDER BY emp_id;

-- ============================================================
-- PART 2 — UNPIVOT (reverse the above)
-- ============================================================

-- Sample Input: emp_salary_wide (wide format)
-- +--------+--------+-------+------+
-- | emp_id | Salary | Bonus | HRA  |
-- +--------+--------+-------+------+
-- |   1    | 10000  |  5000 | 1000 |
-- |   2    |  8000  |  3000 |  800 |
-- +--------+--------+-------+------+
--
-- Expected Unpivot Output (long format):
-- +--------+---------------------+--------+
-- | emp_id | component           | amount |
-- +--------+---------------------+--------+
-- |   1    | Salary              | 10000  |
-- |   1    | Bonus               |  5000  |
-- |   1    | HRA                 |  1000  |
-- |   2    | Salary              |  8000  |
-- |   2    | Bonus               |  3000  |
-- |   2    | HRA                 |   800  |
-- +--------+---------------------+--------+

DROP TABLE IF EXISTS emp_salary_wide;

CREATE TABLE emp_salary_wide (
    emp_id INT,
    Salary INT,
    Bonus  INT,
    HRA    INT
);

INSERT INTO emp_salary_wide VALUES
    (1, 10000, 5000, 1000),
    (2,  8000, 3000,  800);

-- Hint: UNION ALL each column as its own "component" row.
-- Each SELECT in the UNION emits the value of one column
-- alongside a hard-coded string label for the component name.

-- ============================================================
-- Solution: UNPIVOT via UNION ALL
-- ============================================================

SELECT emp_id, 'Salary' AS component, Salary AS amount FROM emp_salary_wide
UNION ALL
SELECT emp_id, 'Bonus',               Bonus            FROM emp_salary_wide
UNION ALL
SELECT emp_id, 'HRA',                 HRA              FROM emp_salary_wide
ORDER BY emp_id, component;

-- ============================================================
-- Cleanup
-- ============================================================
DROP TABLE IF EXISTS emp_salary_components;
DROP TABLE IF EXISTS emp_salary_wide;
