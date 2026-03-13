-- ============================================================
-- Self Join — Employees Earning More Than Their Manager
-- ============================================================
-- The employee table contains a manager_id that references
-- the emp_id column of the SAME table. Use a self-join to
-- bring manager details onto each employee's row, then filter
-- where employee salary > manager salary.
-- ============================================================

-- Sample Input:
-- Table: staff
-- +--------+---------+--------+------------+
-- | emp_id | name    | salary | manager_id |
-- +--------+---------+--------+------------+
-- |   1    | Alice   | 90000  |    NULL    |  <- CEO, no manager
-- |   2    | Bob     | 75000  |     1      |
-- |   3    | Carol   | 80000  |     1      |  <- earns more than manager? NO (Alice 90k)
-- |   4    | Dan     | 60000  |     2      |
-- |   5    | Eva     | 78000  |     2      |  <- earns more than Bob (75k)? YES
-- |   6    | Frank   | 55000  |     3      |
-- |   7    | Grace   | 85000  |     3      |  <- earns more than Carol (80k)? YES
-- +--------+---------+--------+------------+
--
-- Expected Output:
-- +--------+-------+--------+--------------+----------------+
-- | emp_id | name  | salary | manager_name | manager_salary |
-- +--------+-------+--------+--------------+----------------+
-- |   5    | Eva   | 78000  | Bob          |   75000        |
-- |   7    | Grace | 85000  | Carol        |   80000        |
-- +--------+-------+--------+--------------+----------------+

-- ============================================================
-- DDL & DML
-- ============================================================

DROP TABLE IF EXISTS staff;

CREATE TABLE staff (
    emp_id     INT PRIMARY KEY,
    name       VARCHAR(50),
    salary     INT,
    manager_id INT
);

INSERT INTO staff VALUES
    (1, 'Alice', 90000, NULL),
    (2, 'Bob',   75000, 1),
    (3, 'Carol', 80000, 1),
    (4, 'Dan',   60000, 2),
    (5, 'Eva',   78000, 2),
    (6, 'Frank', 55000, 3),
    (7, 'Grace', 85000, 3);

-- ============================================================
-- Hint
-- ============================================================
-- Alias the same table twice: one instance is the "employee"
-- view (e), the other is the "manager" view (m). Join on
-- e.manager_id = m.emp_id, then filter e.salary > m.salary.
-- Use INNER JOIN so employees with no manager (NULL manager_id)
-- are automatically excluded.

-- ============================================================
-- Solution
-- ============================================================

SELECT
    e.emp_id,
    e.name          AS employee_name,
    e.salary        AS employee_salary,
    m.name          AS manager_name,
    m.salary        AS manager_salary
FROM staff e
INNER JOIN staff m
    ON e.manager_id = m.emp_id
WHERE e.salary > m.salary
ORDER BY e.emp_id;

-- ============================================================
-- Cleanup
-- ============================================================
DROP TABLE IF EXISTS staff;
