-- 1077. Project Employees III
-- Difficulty: Medium
-- Table: Project
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | project_id  | int     |
-- | employee_id | int     |
-- +-------------+---------+
-- Table: Employee
-- +------------------+---------+
-- | Column Name      | Type    |
-- +------------------+---------+
-- | employee_id      | int     |
-- | name             | varchar |
-- | experience_years | int     |
-- +------------------+---------+
-- Report the most experienced employees in each project. In case of a tie, report all employees with the maximum number of experience years.
WITH RankedEmployees AS (
    SELECT
        p.project_id,
        p.employee_id,
        RANK() OVER (
            PARTITION BY p.project_id
            ORDER BY e.experience_years DESC
        ) AS rnk
    FROM
        Project p
        JOIN Employee e ON p.employee_id = e.employee_id
)
SELECT
    project_id,
    employee_id
FROM
    RankedEmployees
WHERE
    rnk = 1;
-- Solution:
