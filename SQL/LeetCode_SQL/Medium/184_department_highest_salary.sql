/*
184. Department Highest Salary
Difficulty: Medium
Table Names: Employee, Department

Table: Employee
| id           | int     |
| name         | varchar |
| salary       | int     |
| departmentId | int     |
departmentId is a foreign key (reference column) of the ID from the Department table.
Each row of this table indicates the ID, name, and salary of an employee. It also contains the ID of their department.

Table: Department
| id          | int     |
| name        | varchar |
Each row of this table contains the ID of a department and its name.

Write a solution to find employees who have the highest salary in each of the departments.
Return the result table in any order.
Example 1:
Input:
Employee table:
+----+-------+--------+--------------+
| id | name  | salary | departmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Jim   | 90000  | 1            |
| 3  | Henry | 80000  | 2            |
| 4  | Sam   | 60000  | 2            |
| 5  | Max   | 90000  | 1            |
+----+-------+--------+--------------+
Department table:
+----+-------+
| id | name  |
+----+-------+
| 1  | IT    |
| 2  | Sales |
+----+-------+
Output:
+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Jim      | 90000  |
| Sales      | Henry    | 80000  |
| IT         | Max      | 90000  |
+------------+----------+--------+
Solution
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT 
    d.name AS Department,
    e.name AS Employee,
    e.salary AS Salary
FROM Employee e
JOIN Department d ON e.departmentId = d.id
WHERE (e.departmentId, e.salary) IN (
    SELECT departmentId, MAX(salary)
    FROM Employee
    GROUP BY departmentId
);

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee (
    id int,
    name VARCHAR(255),
    salary int,
    departmentId int
);

INSERT INTO Employee (id, name, salary, departmentId) VALUES
    (1, 'Joe', 70000, 1),
    (2, 'Jim', 90000, 1),
    (3, 'Henry', 80000, 2),
    (4, 'Sam', 60000, 2),
    (5, 'Max', 90000, 1);
INSERT INTO Employee (id, name) VALUES
    (1, 'IT'),
    (2, 'Sales');

DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS Department;
CREATE TABLE Department (
    id int,
    name VARCHAR(255)
);

SET FOREIGN_KEY_CHECKS = 1;
*/
