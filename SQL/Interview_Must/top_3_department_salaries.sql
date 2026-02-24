-- Advanced SQL Challenge: Top 3 Department Salaries (RANK vs DENSE_RANK)
-- Difficulty: Senior

/*
Problem Statement:
Write a query to find the top 3 highest-paid employees in each department.
If two employees have the identical salary, they should share the same rank. 

Crucially, you must use DENSE_RANK(), and be able to explain why ROW_NUMBER() 
or RANK() would fail edge cases for finding a solid "Top 3".

Edge Cases Handled:
- Ties in salaries inside the same department.
- A department with fewer than 3 employees.

Example Input (EmployeeSalaries):
| id | name  | salary | departmentId |
|----|-------|--------|--------------|
| 1  | Joe   | 85000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
| 5  | Janet | 69000  | 1            |
| 6  | Randy | 85000  | 1            |
| 7  | Will  | 70000  | 1            |

Example Input (Department):
| id | name  |
|----|-------|
| 1  | IT    |
| 2  | Sales |

Expected Output:
| Department | Employee | Salary |
|------------|----------|--------|
| IT         | Max      | 90000  |
| IT         | Joe      | 85000  |
| IT         | Randy    | 85000  |
| IT         | Will     | 70000  |
| Sales      | Henry    | 80000  |
| Sales      | Sam      | 60000  |

Schema & DML Data:
*/
USE practice_sql_db;

DROP TABLE IF EXISTS EmployeeSalaries;

CREATE TABLE EmployeeSalaries (
    id INT,
    name VARCHAR(50),
    salary INT,
    departmentId INT
);

INSERT INTO
    EmployeeSalaries (
        id,
        name,
        salary,
        departmentId
    )
VALUES (1, 'Joe', 85000, 1),
    (2, 'Henry', 80000, 2),
    (3, 'Sam', 60000, 2),
    (4, 'Max', 90000, 1),
    (5, 'Janet', 69000, 1),
    (6, 'Randy', 85000, 1), -- Tie with Joe for 2nd place
    (7, 'Will', 70000, 1);
-- This should be included! (90k, 85k, 85k, 70k -> Ranks: 1, 2, 2, 3)

DROP TABLE IF EXISTS Department;

CREATE TABLE Department (id INT, name VARCHAR(50));

INSERT INTO
    Department (id, name)
VALUES (1, 'IT'),
    (2, 'Sales');

-- ==========================================
-- Your Sol
-- ==========================================

-- ==========================================
-- Solutions Provided
-- ==========================================

/*
WITH RankedSalaries AS (
SELECT 
d.name AS Department,
e.name AS Employee,
e.salary AS Salary,
-- DENSE_RANK() is required. 
-- If we used RANK(), Will (70k) would be rank 4 and get filtered out!
DENSE_RANK() OVER (
PARTITION BY e.departmentId 
ORDER BY e.salary DESC
) as rnk
FROM EmployeeSalaries e
JOIN Department d ON e.departmentId = d.id
)
SELECT 
Department, 
Employee, 
Salary
FROM RankedSalaries
WHERE rnk <= 3;
*/