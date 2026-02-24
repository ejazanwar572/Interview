/*
176. Second Highest Salary
Difficulty: Medium
Table Names: Employee

Table: Employee
| id          | int  |
| salary      | int  |
Each row of this table contains information about the salary of an employee.

Write a solution to find the second highest distinct salary from the Employee table.
If there is no second highest salary, return null (or None in Pandas).
Example 1:
Input:
Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
Output:
+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |
+---------------------+
Example 2:
Input:
Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
+----+--------+
Output:
+---------------------+
| SecondHighestSalary |
+---------------------+
| null                |
+---------------------+
Solution
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT (
    SELECT DISTINCT salary
    FROM Employee
    ORDER BY salary DESC
    LIMIT 1 OFFSET 1
) AS SecondHighestSalary;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee (
    id int,
    salary int
);

INSERT INTO Employee (id, salary) VALUES
    (1, 100),
    (2, 200),
    (3, 300),
    (1, 100);

SET FOREIGN_KEY_CHECKS = 1;
*/
