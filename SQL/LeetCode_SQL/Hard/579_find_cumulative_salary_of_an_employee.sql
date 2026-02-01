-- 579. Find Cumulative Salary of an Employee
-- Difficulty: Hard
-- 
-- Table: Employee
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | id          | int  |
-- | month       | int  |
-- | salary      | int  |
-- +-------------+------+
-- (id, month) is the primary key (combination of columns with unique values) for this table.
-- Each row of this table indicates the salary of an employee in one month during the year 2020.
-- 
-- Write a solution to calculate the cumulative salary summary for every employee.
-- The cumulative salary summary for an employee can be calculated as follows:
-- For each month that the employee worked, sum up the salaries in that month and the previous two months. This is their 3-month sum for that month. If an employee did not work for the company in previous months, their effective salary for those months is 0.
-- Do not include the 3-month sum for the most recent month that the employee worked for in the summary.
-- Do not include the 3-month sum for any month the employee did not work.
-- Return the result table ordered by id in ascending order. In case of a tie, order it by month in descending order.
/*
-- Example 1:
Input: 
Employee table:
+----+-------+--------+
| id | month | salary |
+----+-------+--------+
| 1  | 1     | 20     |
| 1  | 2     | 30     |
| 1  | 3     | 40     |
| 1  | 4     | 60     |
| 2  | 1     | 20     |
| 3  | 2     | 40     |
| 3  | 3     | 60     |
| 3  | 4     | 80     |
+----+-------+--------+
Output: 
+----+-------+--------+
| id | month | Salary |
+----+-------+--------+
| 1  | 3     | 90     |
| 1  | 2     | 50     |
| 1  | 1     | 20     |
| 2  | 1     | 20     |
| 3  | 3     | 100    |
| 3  | 2     | 40     |
+----+-------+--------+
*/
-- Solution
SELECT 
    e1.id, 
    e1.month, 
    SUM(e2.salary) AS Salary
FROM Employee e1
JOIN Employee e2 
    ON e1.id = e2.id 
    AND e2.month BETWEEN e1.month - 2 AND e1.month
WHERE e1.month < (SELECT MAX(month) FROM Employee WHERE id = e1.id)
GROUP BY e1.id, e1.month
ORDER BY e1.id ASC, e1.month DESC;
-- Solution:
