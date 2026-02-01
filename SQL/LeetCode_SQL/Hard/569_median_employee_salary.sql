-- 569. Median Employee Salary
-- Difficulty: Hard
-- 
-- Table: Employee
-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | id           | int     |
-- | company      | varchar |
-- | salary       | int     |
-- +--------------+---------+
-- id is the primary key (column with unique values) for this table.
-- Each row of this table indicates the company and the salary of an employee.
-- 
-- Write a solution to find the rows that contain the median salary of each company.
-- While calculating the median, when you sort the salaries of the company, break the ties by id.
-- Return the result table in any order.
/*
-- Example 1:
Input: 
Employee table:
+----+---------+--------+
| id | company | salary |
+----+---------+--------+
| 1  | A       | 2341   |
| 2  | A       | 341    |
| 3  | A       | 15     |
| 4  | A       | 15314  |
| 5  | A       | 451    |
| 6  | A       | 513    |
| 7  | B       | 15     |
| 8  | B       | 13     |
| 9  | B       | 1154   |
| 10 | B       | 1345   |
| 11 | B       | 1221   |
| 12 | B       | 234    |
| 13 | C       | 2345   |
| 14 | C       | 2645   |
| 15 | C       | 2645   |
| 16 | C       | 2652   |
| 17 | C       | 65     |
+----+---------+--------+
Output: 
+----+---------+--------+
| id | company | salary |
+----+---------+--------+
| 5  | A       | 451    |
| 6  | A       | 513    |
| 12 | B       | 234    |
| 9  | B       | 1154   |
| 14 | C       | 2645   |
+----+---------+--------+
*/
-- Solution
WITH RankedSalaries AS (
    SELECT 
        id, 
        company, 
        salary,
        ROW_NUMBER() OVER(PARTITION BY company ORDER BY salary, id) AS row_num,
        COUNT(*) OVER(PARTITION BY company) AS total_count
    FROM Employee
)
SELECT id, company, salary
FROM RankedSalaries
WHERE row_num BETWEEN total_count / 2.0 AND total_count / 2.0 + 1;
-- Solution:
