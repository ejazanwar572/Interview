/*
### Problem Description
Write a query to find the median salary of employees in each department. If there is an even number of employees, the median is the average of the two middle salaries. 

### Sample Input and Output
**Input: Employee**
| Id | DepartmentId | Salary |
|---|---|---|
| 1 | 1 | 5000 |
| 2 | 1 | 6000 |
| 3 | 1 | 7000 |
| 4 | 2 | 4000 |
| 5 | 2 | 5000 |
| 6 | 2 | 6000 |
| 7 | 2 | 8000 |

**Output:**
| DepartmentId | MedianSalary |
|---|---|
| 1 | 6000 |
| 2 | 5500 |
*/

-- DDL and DML commands
DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee (
    Id INT,
    DepartmentId INT,
    Salary INT
);

INSERT INTO Employee (Id, DepartmentId, Salary) VALUES
(1, 1, 5000),
(2, 1, 6000),
(3, 1, 7000),
(4, 2, 4000),
(5, 2, 5000),
(6, 2, 6000),
(7, 2, 8000);


/*
### Approach
To find the median, standard SQL dialects like PostgreSQL or Snowflake support `PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Salary)`.
If you are using a dialect without percentile functions (like older MySQL), you can use `ROW_NUMBER() OVER()` to calculate row positions within each department block, and then filter for the middle row(s).

The most elegant and optimized standard SQL approach uses the built-in percentile function.
*/










-- Optimized Solution (MySQL Compatible)
WITH RankedSalaries AS (
    SELECT 
        DepartmentId,
        Salary,
        ROW_NUMBER() OVER (PARTITION BY DepartmentId ORDER BY Salary ASC, Id ASC) AS rn_asc,
        ROW_NUMBER() OVER (PARTITION BY DepartmentId ORDER BY Salary DESC, Id DESC) AS rn_desc
    FROM Employee
)
SELECT 
    DepartmentId,
    ROUND(AVG(Salary), 2) AS MedianSalary
FROM RankedSalaries
WHERE rn_asc = rn_desc 
   OR rn_asc + 1 = rn_desc 
   OR rn_asc - 1 = rn_desc
GROUP BY DepartmentId;

/*
-- Alternative (For PostgreSQL/Snowflake using PERCENTILE_CONT):
SELECT 
    DepartmentId,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Salary) AS MedianSalary
FROM Employee
GROUP BY DepartmentId;
*/
