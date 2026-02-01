-- 1978. Employees Whose Manager Left the Company
-- Difficulty: Easy
-- Description:
-- Write an SQL query to report the IDs of the employees whose salary is strictly less than $30000 and whose manager left the company. When a manager leaves the company, their information is deleted from the Employees table, but the reports still have their manager_id set to the manager that left.
-- Return the result table ordered by employee_id.
-- Schema:
-- Table: Employees
-- +-------------+----------+
-- | Column Name | Type     |
-- +-------------+----------+
-- | employee_id | int      |
-- | name        | varchar  |
-- | manager_id  | int      |
-- | salary      | int      |
-- +-------------+----------+
-- employee_id is the primary key for this table.
-- Example Input/Output:
-- Output:
-- +-------------+
-- | employee_id |
-- +-------------+
-- | 1           |
-- +-------------+
-- Solution:
SELECT
    employee_id
FROM
    Employees
WHERE
    salary < 30000
    AND manager_id IS NOT NULL
    AND manager_id NOT IN (SELECT employee_id FROM Employees)
ORDER BY
    employee_id;
