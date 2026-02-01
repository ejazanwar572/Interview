-- 1875. Group Employees of the Same Salary
-- Difficulty: Medium
-- Description:
-- A company wants to divide the employees into teams such that all the members on each team have the same salary. The teams should follow these criteria:
-- 1. Each team should consist of at least two employees.
-- 2. All the employees on a team should have the same salary.
-- 3. All the employees of the same salary should be assigned to the same team.
-- 4. If the salary of an employee is unique, the employee does not become part of any team.
-- 5. A team's ID is assigned based on the rank of the team's salary relative to the other teams' salaries, where the team with the lowest salary has team_id = 1.
-- Note that the salaries for employees not on a team are not included in this ranking.
-- Write an SQL query to get the team_id of each employee that is in a team.
-- Schema:
-- Table: Employees
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | employee_id | int     |
-- | name        | varchar |
-- | salary      | int     |
-- +-------------+---------+
-- employee_id is the primary key for this table.
-- Example Input/Output:
-- Output:
-- +-------------+---------+--------+---------+
-- | employee_id | name    | salary | team_id |
-- +-------------+---------+--------+---------+
-- | 2           | Meir    | 3000   | 1       |
-- | 3           | Michael | 3000   | 1       |
-- | 7           | Addilyn | 7400   | 2       |
-- | 9           | Kannon  | 7400   | 2       |
-- +-------------+---------+--------+---------+
-- Solution:
WITH SalaryCounts AS (
    SELECT
        salary,
        COUNT(*) AS cnt
    FROM
        Employees
    GROUP BY
        salary
    HAVING
        COUNT(*) >= 2
),
RankedSalaries AS (
    SELECT
        salary,
        DENSE_RANK() OVER (ORDER BY salary ASC) AS team_id
    FROM
        SalaryCounts
)
SELECT
    e.employee_id,
    e.name,
    e.salary,
    rs.team_id
FROM
    Employees e
    JOIN RankedSalaries rs ON e.salary = rs.salary
ORDER BY
    rs.team_id,
    e.employee_id;
