-- 615. Average Salary: Departments VS Company
-- Difficulty: Hard
-- Table: Salary
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | id          | int  |
-- | employee_id | int  |
-- | amount      | int  |
-- | pay_date    | date |
-- +-------------+------+
-- Table: Employee
-- +---------------+------+
-- | Column Name   | Type |
-- +---------------+------+
-- | employee_id   | int  |
-- | department_id | int  |
-- +---------------+------+
-- Find the comparison result (higher/lower/same) of the average salary of employees in a department compared to the company's average salary for each month.
WITH CompanyStats AS (
    SELECT
        DATE_FORMAT(pay_date, '%Y-%m') AS pay_month,
        AVG(amount) AS company_avg
    FROM
        Salary
    GROUP BY
        DATE_FORMAT(pay_date, '%Y-%m')
),
DepartmentStats AS (
    SELECT
        DATE_FORMAT(s.pay_date, '%Y-%m') AS pay_month,
        e.department_id,
        AVG(s.amount) AS dept_avg
    FROM
        Salary s
        JOIN Employee e ON s.employee_id = e.employee_id
    GROUP BY
        DATE_FORMAT(s.pay_date, '%Y-%m'),
        e.department_id
)
SELECT
    d.pay_month,
    d.department_id,
    CASE
        WHEN d.dept_avg > c.company_avg THEN 'higher'
        WHEN d.dept_avg < c.company_avg THEN 'lower'
        ELSE 'same'
    END AS comparison
FROM
    DepartmentStats d
    JOIN CompanyStats c ON d.pay_month = c.pay_month
ORDER BY
    d.pay_month DESC,
    d.department_id;
-- Solution:
