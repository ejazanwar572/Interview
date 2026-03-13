-- ============================================================
-- Employees NOT Present in the Department Table
-- ============================================================
-- Find all employees whose department_id does not exist
-- in the departments table. Two idiomatic approaches:
--   1. Subquery with NOT IN
--   2. LEFT JOIN with NULL filter (better performance on large data)
-- ============================================================

-- Sample Input:
--
-- Table: employees                    Table: departments
-- +------+--------+-----------+       +--------+----------------+
-- | e_id | name   | dept_id   |       | dep_id | dep_name       |
-- +------+--------+-----------+       +--------+----------------+
-- |  1   | Alice  |   100     |       |  100   | Analytics      |
-- |  2   | Bob    |   200     |       |  300   | Engineering    |
-- |  3   | Carol  |   300     |       +--------+----------------+
-- |  4   | Dan    |   900     |
-- +------+--------+-----------+
--
-- Expected Output (dept 200 and 900 are missing from departments):
-- +------+-------+---------+
-- | e_id | name  | dept_id |
-- +------+-------+---------+
-- |  2   | Bob   |   200   |
-- |  4   | Dan   |   900   |
-- +------+-------+---------+

-- ============================================================
-- DDL & DML
-- ============================================================

DROP TABLE IF EXISTS employees_nd;
DROP TABLE IF EXISTS departments_nd;

CREATE TABLE employees_nd (
    e_id    INT,
    name    VARCHAR(50),
    dept_id INT
);

CREATE TABLE departments_nd (
    dep_id   INT,
    dep_name VARCHAR(50)
);

INSERT INTO employees_nd VALUES
    (1, 'Alice', 100),
    (2, 'Bob',   200),
    (3, 'Carol', 300),
    (4, 'Dan',   900);

INSERT INTO departments_nd VALUES
    (100, 'Analytics'),
    (300, 'Engineering');

-- ============================================================
-- Hint
-- ============================================================
-- NOT IN is readable but has a performance pitfall: if the
-- subquery returns ANY NULL, the entire NOT IN returns no rows
-- (three-valued logic). LEFT JOIN + IS NULL avoids this trap
-- and generally performs better with indexes.

-- ============================================================
-- Solution 1: NOT IN subquery
-- ============================================================

SELECT e_id, name, dept_id
FROM   employees_nd
WHERE  dept_id NOT IN (SELECT dep_id FROM departments_nd);

-- ============================================================
-- Solution 2: LEFT JOIN + IS NULL (preferred)
-- ============================================================

SELECT e.e_id, e.name, e.dept_id
FROM   employees_nd e
LEFT JOIN departments_nd d
    ON e.dept_id = d.dep_id
WHERE  d.dep_id IS NULL;

-- ============================================================
-- Cleanup
-- ============================================================
DROP TABLE IF EXISTS employees_nd;
DROP TABLE IF EXISTS departments_nd;
