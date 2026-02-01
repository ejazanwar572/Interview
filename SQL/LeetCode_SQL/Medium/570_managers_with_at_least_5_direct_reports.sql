-- 570. Managers with at Least 5 Direct Reports
-- Difficulty: Medium
-- 
-- Table: Employee
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | id          | int     |
-- | name        | varchar |
-- | department  | varchar |
-- | managerId   | int     |
-- +-------------+---------+
-- id is the primary key (column with unique values) for this table.
-- Each row of this table indicates the name of an employee, their department, and the id of their manager.
-- If managerId is null, then the employee has no manager.
-- No employee will be the manager of themself.
-- 
-- Write a solution to find managers with at least five direct reports.
-- Return the result table in any order.
/*
-- Example 1:
Input: 
Employee table:
+-----+-------+------------+-----------+
| id  | name  | department | managerId |
+-----+-------+------------+-----------+
| 101 | John  | A          | null      |
| 102 | Dan   | A          | 101       |
| 103 | James | A          | 101       |
| 104 | Amy   | A          | 101       |
| 105 | Anne  | A          | 101       |
| 106 | Ron   | B          | 101       |
+-----+-------+------------+-----------+
Output: 
+------+
| name |
+------+
| John |
+------+
*/
-- Solution
SELECT e.name
FROM Employee e
JOIN (
    SELECT managerId, COUNT(*) AS reports
    FROM Employee
    GROUP BY managerId
    HAVING reports >= 5
) m ON e.id = m.managerId;
-- Solution:
