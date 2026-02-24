/*
1468. Calculate Salaries
Difficulty: Medium
Table Names: Salaries
Description:
Write a solution to find the salaries of the employees after taxes. The tax rate is calculated for each company based on the maximum salary of an employee in the company:
- If the max salary is less than $1000, the tax rate is 0%.
- If the max salary is between $1000 and $10000 inclusive, the tax rate is 24%.
- If the max salary is greater than $10000, the tax rate is 49%.
Return the result table in any order. The salary after taxes should be rounded to the nearest integer.
Schema:
Table: Salaries
| company_id    | int     |
| employee_id   | int     |
| employee_name | varchar |
| salary        | int     |
Example Input/Output:
Salaries table:
+------------+-------------+---------------+--------+
| company_id | employee_id | employee_name | salary |
+------------+-------------+---------------+--------+
| 1          | 1           | Tony          | 2000   |
| 1          | 2           | Pronit        | 21300  |
| 1          | 3           | Tyrann        | 10800  |
| 2          | 1           | Pam           | 300    |
| 2          | 7           | Bassem        | 450    |
+------------+-------------+---------------+--------+
Output:
+------------+-------------+---------------+--------+
| company_id | employee_id | employee_name | salary |
+------------+-------------+---------------+--------+
| 1          | 1           | Tony          | 1020   |
| 1          | 2           | Pronit        | 10863  |
| 1          | 3           | Tyrann        | 5508   |
| 2          | 1           | Pam           | 300    |
| 2          | 7           | Bassem        | 450    |
+------------+-------------+---------------+--------+
*/

-- Write your MySQL query statement below:













-- Solution:
/*
WITH CompanyMaxSalary AS (
    SELECT
        company_id,
        MAX(salary) AS max_salary
    FROM
        Salaries
    GROUP BY
        company_id
)
SELECT
    s.company_id,
    s.employee_id,
    s.employee_name,
    ROUND(
        CASE
            WHEN m.max_salary < 1000 THEN s.salary
            WHEN m.max_salary BETWEEN 1000 AND 10000 THEN s.salary * 0.76
            ELSE s.salary * 0.51
        END,
        0
    ) AS salary
FROM
    Salaries s
    JOIN CompanyMaxSalary m ON s.company_id = m.company_id;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Salaries;
DROP TABLE IF EXISTS Salaries;
CREATE TABLE Salaries (
    company_id int,
    employee_id int,
    employee_name VARCHAR(255),
    salary int
);

INSERT INTO Salaries (company_id, employee_id, employee_name, salary) VALUES
    (1, 1, 'Tony', 2000),
    (1, 2, 'Pronit', 21300),
    (1, 3, 'Tyrann', 10800),
    (2, 1, 'Pam', 300),
    (2, 7, 'Bassem', 450),
    (1, 1, 'Tony', 1020),
    (1, 2, 'Pronit', 10863),
    (1, 3, 'Tyrann', 5508),
    (2, 1, 'Pam', 300),
    (2, 7, 'Bassem', 450);

SET FOREIGN_KEY_CHECKS = 1;
*/
