/*
1270. All People Report to the Given Manager
Difficulty: Medium
Table Names: Employees
Table: Employees
| employee_id   | int     |
| employee_name | varchar |
| manager_id    | int     |
The manager_id of the company CEO is 1.
Write an SQL query to find employee_id of all employees that directly or indirectly report to the Head of the Company.
The indirect relation between an employee and the Head of the Company will not exceed 3 managers as the company is small.
Return the result table in any order.
Example:
Input:
Employees table:
+-------------+---------------+------------+
| employee_id | employee_name | manager_id |
+-------------+---------------+------------+
| 1           | Boss          | 1          |
| 2           | Bob           | 1          |
| 3           | Alice         | 3          |
| 4           | Daniel        | 2          |
| 7           | Luis          | 4          |
| 8           | Jhon          | 3          |
| 9           | Angela        | 8          |
| 77          | Robert        | 1          |
+-------------+---------------+------------+
Output:
+-------------+
| employee_id |
+-------------+
| 2           |
| 77          |
| 4           |
| 7           |
+-------------+
Explanation:
The head of the company is the employee with employee_id 1.
The employees with employee_id 2 and 77 report their work directly to the head of the company.
The employee with employee_id 4 reports their work indirectly to the head of the company 4 --> 2 --> 1.
The employee with employee_id 7 reports their work indirectly to the head of the company 7 --> 4 --> 2 --> 1.
The employees with employee_id 3, 8 and 9 do not report their work to the head of the company.
Concept: Self joins to trace hierarchy up to 3 levels.
Level 1: e1.manager_id = 1
Level 2: e2.manager_id = e1.employee_id AND e1.manager_id = 1
Level 3: e3.manager_id = e2.employee_id ...
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT e1.employee_id
FROM Employees e1
JOIN Employees e2 ON e1.manager_id = e2.employee_id
JOIN Employees e3 ON e2.manager_id = e3.employee_id
WHERE e3.manager_id = 1 AND e1.employee_id != 1;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees (
    employee_id int,
    employee_name VARCHAR(255),
    manager_id int
);

INSERT INTO Employees (employee_id, employee_name, manager_id) VALUES
    (1, 'Boss', 1),
    (2, 'Bob', 1),
    (3, 'Alice', 3),
    (4, 'Daniel', 2),
    (7, 'Luis', 4),
    (8, 'Jhon', 3),
    (9, 'Angela', 8),
    (77, 'Robert', 1);
INSERT INTO Employees (employee_id) VALUES
    (2),
    (77),
    (4),
    (7);

SET FOREIGN_KEY_CHECKS = 1;
*/
