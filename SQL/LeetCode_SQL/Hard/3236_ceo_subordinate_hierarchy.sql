-- 3236. CEO Subordinate Hierarchy
-- Difficulty: Hard
-- Description:
--     - Database
-- 
-- ## Description
-- 
-- Table: Employees
-- 
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | employee_id   | int     |
-- | employee_name | varchar |
-- | manager_id    | int     |
-- | salary        | int     |
-- +---------------+---------+
-- employee_id is the unique identifier for this table.
-- manager_id is the employee_id of the employee's manager. The CEO has a NULL manager_id.
-- 
-- Write a solution to find subordinates of the CEO (both direct and indirect), along with their level in the hierarchy and their salary difference from the CEO.
-- 
-- The result should have the following columns:
-- 
-- The query result format is in the following example.
-- 
-- 	- subordinate_id: The employee_id of the subordinate
-- 	- subordinate_name: The name of the subordinate
-- 	- hierarchy_level: The level of the subordinate in the hierarchy (1 for direct reports, 2 for their direct reports, and so on)
-- 	- salary_difference: The difference between the subordinate's salary and the CEO's salary
-- 
-- Return the result table ordered by hierarchy_level ascending, and then by subordinate_id ascending.
-- 
-- The query result format is in the following example.
-- 
-- Example:
-- 
-- Input:
-- 
-- Employees table:
-- 
-- +-------------+----------------+------------+---------+
-- | employee_id | employee_name  | manager_id | salary  |
-- +-------------+----------------+------------+---------+
-- | 1           | Alice          | NULL       | 150000  |
-- | 2           | Bob            | 1          | 120000  |
-- | 3           | Charlie        | 1          | 110000  |
-- | 4           | David          | 2          | 105000  |
-- | 5           | Eve            | 2          | 100000  |
-- | 6           | Frank          | 3          | 95000   |
-- | 7           | Grace          | 3          | 98000   |
-- | 8           | Helen          | 5          | 90000   |
-- +-------------+----------------+------------+---------+
-- 
-- Output:
-- 
-- +----------------+------------------+------------------+-------------------+
-- | subordinate_id | subordinate_name | hierarchy_level  | salary_difference |
-- +----------------+------------------+------------------+-------------------+
-- | 2              | Bob              | 1                | -30000            |
-- | 3              | Charlie          | 1                | -40000            |
-- | 4              | David            | 2                | -45000            |
-- | 5              | Eve              | 2                | -50000            |
-- | 6              | Frank            | 2                | -55000            |
-- | 7              | Grace            | 2                | -52000            |
-- | 8              | Helen            | 3                | -60000            |
-- +----------------+------------------+------------------+-------------------+
-- 
-- Explanation:
-- 
-- 	- Bob and Charlie are direct subordinates of Alice (CEO) and thus have a hierarchy_level of 1.
-- 	- David and Eve report to Bob, while Frank and Grace report to Charlie, making them second-level subordinates (hierarchy_level 2).
-- 	- Helen reports to Eve, making Helen a third-level subordinate (hierarchy_level 3).
-- 	- Salary differences are calculated relative to Alice's salary of 150000.
-- 	- The result is ordered by hierarchy_level ascending, and then by subordinate_id ascending.
-- 
-- Note: The output is ordered first by hierarchy_level in ascending order, then by subordinate_id in ascending order.
-- 
-- Solution:
# Write your MySQL query statement below
WITH RECURSIVE
    T AS (
        SELECT
            employee_id,
            employee_name,
            0 AS hierarchy_level,
            manager_id,
            salary
        FROM Employees
        WHERE manager_id IS NULL
        UNION ALL
        SELECT
            e.employee_id,
            e.employee_name,
            hierarchy_level + 1 AS hierarchy_level,
            e.manager_id,
            e.salary
        FROM
            T t
            JOIN Employees e ON t.employee_id = e.manager_id
    ),
    P AS (
        SELECT salary
        FROM Employees
        WHERE manager_id IS NULL
    )
SELECT
    employee_id subordinate_id,
    employee_name subordinate_name,
    hierarchy_level,
    t.salary - p.salary salary_difference
FROM
    T t
    JOIN P p
WHERE hierarchy_level != 0
ORDER BY 3, 1;
