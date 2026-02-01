-- Puzzle 71 - Employee Validation
--

-- Due to a sub-optimal database design by the database architecture team, employee records are split across two separate tables: one for temporary employees and another for permanent employees. You face the following challenges.

-- 1. Ensure that an employee is not simultaneously listed in both the `Temporary Employees` and `Permanent Employees` tables. An `INSERT` into the `Temporary Employees` or `Permanent Employees` tables should fail if this criterion is not met.
-- 2. Confirm that any employee added to either the `Temporary Employees` or `Permanent Employees` table has a corresponding entry in the `Employees` table. An `INSERT` into the `Temporary Employees` or `Permanent Employees` table should fail if this criterion is not met.

-- **Temporary Employees**

/*
| Employee ID |  Department |
|-------------|-------------|
| 1001        | Engineering |
| 2002        | Sales       |
| 3003        | Marketing   |
*/

-- **Permanent Employees**

/*
| Employee ID | Department |
|-------------|------------|
| 4004        | Marketing  |
| 5005        | Accounting |
| 6006        | Accounting |
*/

-- **Employees**

/*
| Employee ID |   Name   |
|-------------|----------|
| 1001        | John     |
| 2002        | Eric     |
| 3003        | Jennifer |
| 4004        | Bob      |
| 5005        | Stuart   |
| 6006        | Angie    |
*/


-- ==================================================
-- Solution for Puzzle 71
-- ==================================================

--Note this puzzle uses permanant tables
--Setting the database to use "test" to avoid possible issues

USE test;

DROP TABLE IF EXISTS TemporaryEmployees;
DROP TABLE IF EXISTS PermanentEmployees;
DROP TABLE IF EXISTS Employees;

CREATE TABLE TemporaryEmployees
(
EmployeeID  INTEGER PRIMARY KEY,
Department  VARCHAR(50) NOT NULL
);

CREATE TABLE PermanentEmployees
(
EmployeeID  INTEGER PRIMARY KEY,
Department  VARCHAR(50) NOT NULL
);

CREATE TABLE Employees
(
EmployeeID  INTEGER PRIMARY KEY,
[Name]      VARCHAR(50) NOT NULL
);

INSERT INTO TemporaryEmployees (EmployeeID, Department) VALUES
(1001, 'Engineering'),
(2002, 'Sales'),
(3003, 'Marketing');

INSERT INTO PermanentEmployees (EmployeeID, Department) VALUES
(4004, 'Marketing'),
(5005, 'Accounting'),
(6006, 'Accounting');

INSERT INTO Employees (EmployeeID, [Name]) VALUES
(1001, 'John'),
(2002, 'Eric'),
(3003, 'Jennifer'),
(4004, 'Bob'),
(5005, 'Stuart'),
(6006, 'Angie');

CREATE TRIGGER trg_CheckPermanentBeforeInsertOnTemporary
ON TemporaryEmployees
AFTER INSERT
AS
BEGIN
    -- Check if the inserted Employee ID exists in PermanentEmployees
    IF EXISTS (SELECT 1 FROM PermanentEmployees WHERE EmployeeID IN (SELECT EmployeeID FROM inserted))
    BEGIN
        RAISERROR ('Employee ID already exists in PermanentEmployees.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

CREATE TRIGGER trg_CheckTemporaryBeforeInsertOnPermanant
ON PermanentEmployees
AFTER INSERT
AS
BEGIN
    -- Check if the inserted Employee ID exists in TemporaryEmployees
    IF EXISTS (SELECT 1 FROM TemporaryEmployees WHERE EmployeeID IN (SELECT EmployeeID FROM inserted))
    BEGIN
        RAISERROR ('Employee ID already exists in TemporaryEmployees.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

ALTER TABLE PermanentEmployees
ADD CONSTRAINT FK_PermanentEmployees
FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID);

ALTER TABLE TemporaryEmployees
ADD CONSTRAINT FK_TemporaryEmployees
FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID);

--The following statements will successfully fail.

/*
INSERT INTO TemporaryEmployees (EmployeeID, Department) VALUES (4004,'Marketing');
INSERT INTO PermanentEmployees (EmployeeID, Department)VALUES (1001,'Engineering');
INSERT INTO TemporaryEmployees (EmployeeID, Department) VALUES (7007,'Sales');
INSERT INTO PermanentEmployees (EmployeeID, Department) VALUES (7007,'Sales');
*/
