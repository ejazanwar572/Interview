/*
1077. Project Employees III
Difficulty: Medium
Table Names: Project, Employee
Table: Project
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| project_id  | int     |
| employee_id | int     |
+-------------+---------+
Table: Employee
+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| employee_id      | int     |
| name             | varchar |
| experience_years | int     |
+------------------+---------+
Report the most experienced employees in each project. In case of a tie, report all employees with the maximum number of experience years.
*/

-- Write your MySQL query statement below:













-- Solution:
/*
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

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Project;
DROP TABLE IF EXISTS Project;
CREATE TABLE Project (
    project_id int,
    employee_id int
);


DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee (
    employee_id int,
    name VARCHAR(255),
    experience_years int
);

SET FOREIGN_KEY_CHECKS = 1;
*/
