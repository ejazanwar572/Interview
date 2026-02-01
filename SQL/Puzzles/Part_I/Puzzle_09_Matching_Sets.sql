-- Puzzle 9 - Matching Sets
--

-- Write an SQL statement that matches an employee to all other employees who carry the same licenses.  

/*
| Employee ID | License |
|-------------|---------|
| 1001        | Class A |
| 1001        | Class B |
| 1001        | Class C |
| 2002        | Class A |
| 2002        | Class B |
| 2002        | Class C |
| 3003        | Class A |
| 3003        | Class D |
| 4004        | Class A |
| 4004        | Class B |
| 4004        | Class D |
| 5005        | Class A |
| 5005        | Class B |
| 5005        | Class D |
*/

-- Here is the expected output.

/*
| Employee ID | Employee ID | Count |
|-------------|-------------|-------|
| 1001        | 2002        | 3     |
| 2002        | 1001        | 3     |
| 4004        | 5005        | 3     |
| 5005        | 4004        | 3     |
*/

-- - `Employee ID` `1001` and `2002` would be in the expected output as they both carry a `Class A`, `Class B`, and a `Class C` license.  
-- - `Employee ID` `4004` and `5005` would be in the expected output as they both carry a `Class A`, `Class B`, and a `Class D` license.  
-- - Although `Employee ID` `3003` has the same licenses as `Employee ID` `4004` and `5005`, these Employee IDs do not have the same licenses as `Employee ID` `3003`.  


-- Solution
-- Solution for Puzzle 9: Matching Sets
SELECT T1.EmployeeID, T2.EmployeeID, COUNT(*) AS Count
FROM Licenses T1
JOIN Licenses T2 ON T1.License = T2.License
WHERE T1.EmployeeID <> T2.EmployeeID
GROUP BY T1.EmployeeID, T2.EmployeeID
HAVING COUNT(*) = (SELECT COUNT(*) FROM Licenses T3 WHERE T3.EmployeeID = T1.EmployeeID)
AND COUNT(*) = (SELECT COUNT(*) FROM Licenses T4 WHERE T4.EmployeeID = T2.EmployeeID);


-- ==================================================
-- Solution for Puzzle 9
-- ==================================================

DROP TABLE IF EXISTS Employees;

CREATE TABLE Employees
(
EmployeeID  INTEGER,
License     VARCHAR(100),
PRIMARY KEY (EmployeeID, License)
);

INSERT INTO Employees (EmployeeID, License) VALUES
(1001,'Class A'),(1001,'Class B'),(1001,'Class C'),
(2002,'Class A'),(2002,'Class B'),(2002,'Class C'),
(3003,'Class A'),(3003,'Class D'),
(4004,'Class A'),(4004,'Class B'),(4004,'Class D'),
(5005,'Class A'),(5005,'Class B'),(5005,'Class D');

WITH cte_Count AS
(
SELECT  EmployeeID,
        COUNT(*) AS LicenseCount
FROM    Employees
GROUP BY EmployeeID
),
cte_CountWindow AS
(
SELECT  a.EmployeeID AS EmployeeID_A,
        b.EmployeeID AS EmployeeID_B,
        COUNT(*) OVER (PARTITION BY a.EmployeeID, b.EmployeeID) AS CountWindow
FROM    Employees a CROSS JOIN
        Employees b
WHERE   a.EmployeeID <> b.EmployeeID and a.License = b.License
)
SELECT  DISTINCT
        a.EmployeeID_A,
        a.EmployeeID_B,
        a.CountWindow AS LicenseCount
FROM    cte_CountWindow a INNER JOIN
        cte_Count b ON a.CountWindow = b.LicenseCount AND a.EmployeeID_A = b.EmployeeID INNER JOIN
        cte_Count c ON a.CountWindow = c.LicenseCount AND a.EmployeeID_B = c.EmployeeID;
