-- Puzzle 2 - Managers and Employees
--

-- Given the following hierarchical table, write an SQL statement that determines the level of depth each employee has from the CEO.

/*
| Employee ID | Manager ID | Job Title       |
|-------------|------------|-----------------|
| 1001        |            | CEO             |
| 2002        | 1001       | Director        |
| 3003        | 1001       | Office Manager  |
| 4004        | 2002       | Engineer        |
| 5005        | 2002       | Engineer        |
| 6006        | 2002       | Engineer        |
*/

-- Here is the expected output.

/*
| Employee ID | Manager ID | Job Title       | Depth |
|-------------|------------|-----------------|-------|
| 1001        |            | CEO             | 0     |
| 2002        | 1001       | Director        | 1     |
| 3003        | 1001       | Office Manager  | 1     |
| 4004        | 2002       | Engineer        | 2     |
| 5005        | 2002       | Engineer        | 2     |
| 6006        | 2002       | Engineer        | 2     |
*/


-- Solution
-- Solution for Puzzle 2: Managers and Employees
WITH CTE AS (
    SELECT EmployeeID, ManagerID, JobTitle, 0 AS Depth
    FROM Employees
    WHERE ManagerID IS NULL
    UNION ALL
    SELECT e.EmployeeID, e.ManagerID, e.JobTitle, c.Depth + 1
    FROM Employees e
    JOIN CTE c ON e.ManagerID = c.EmployeeID
)
SELECT EmployeeID, ManagerID, JobTitle, Depth
FROM CTE;


-- ==================================================
-- Solution for Puzzle 2
-- ==================================================

DROP TABLE IF EXISTS Employees;

CREATE TABLE Employees
(
EmployeeID  INTEGER PRIMARY KEY,
ManagerID   INTEGER NULL,
JobTitle    VARCHAR(100) NOT NULL
);

INSERT INTO Employees (EmployeeID, ManagerID, JobTitle) VALUES
(1001,NULL,'CEO'),(2002,1001,'Director'),
(3003,1001,'Office Manager'),(4004,2002,'Engineer'),
(5005,2002,'Engineer'),(6006,2002,'Engineer');

--Recursion
WITH cte_Recursion AS
(
SELECT  EmployeeID, ManagerID, JobTitle, 0 AS Depth
FROM    Employees a
WHERE   ManagerID IS NULL
UNION ALL
SELECT  b.EmployeeID, b.ManagerID, b.JobTitle, a.Depth + 1 AS Depth
FROM    cte_Recursion a INNER JOIN 
        Employees b ON a.EmployeeID = b.ManagerID
)
SELECT  EmployeeID,
        ManagerID,
        JobTitle,
        Depth
FROM    cte_Recursion;
