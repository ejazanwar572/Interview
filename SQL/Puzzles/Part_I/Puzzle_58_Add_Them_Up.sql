-- Puzzle 58 - Add Them Up
--

-- You are given the following table, which contains a `VARCHAR` column that contains mathematical equations. Sum the equations and provide the answers in the output.

/*
| Equation |
|----------|
| 123      |
| 1+2+3    |
| 1+2-3    |
| 1+23     |
| 1-2+3    |
| 1-2-3    |
| 1-23     |
| 12+3     |
| 12-3     |
*/

-- Here is the expected output.

/*
| Permutation | Sum |
|-------------|-----|
| 123         | 123 |
| 1+2+3       | 6   |
| 1+2-3       | 0   |
| 1+23        | 24  |
| 1-2+3       | 2   |
| 1-2-3       | -4  |
| 1-23        | -22 |
| 12+3        | 15  |
| 12-3        | 9   |
*/


-- ==================================================
-- Solution for Puzzle 58
-- ==================================================

DROP TABLE IF EXISTS Equations;

CREATE TABLE Equations
(
Equation  VARCHAR(200) PRIMARY KEY,
TotalSum  INTEGER NULL
);

INSERT INTO Equations (Equation) VALUES
('123'),('1+2+3'),('1+2-3'),('1+23'),('1-2+3'),('1-2-3'),('1-23'),('12+3'),('12-3');

--Solution 1
--CURSOR and DYNAMIC SQL
--This solution if you have to multiple and divide
DECLARE @vSQLStatement NVARCHAR(1000);
DECLARE c_cursor CURSOR FOR (SELECT Equation FROM Equations);
DECLARE @vEquation NVARCHAR(1000);
DECLARE @vSum BIGINT;

OPEN c_cursor;

FETCH NEXT FROM c_cursor INTO @vEquation;

WHILE @@FETCH_STATUS = 0
    BEGIN

    SELECT  @vSQLStatement = CONCAT('SELECT @var = ',@vEquation);

    EXECUTE sp_executesql @vSQLStatement, N'@var BIGINT OUTPUT', @var = @vSum OUTPUT;

    UPDATE  Equations
    SET     TotalSum = @vSum
    WHERE   Equation = @vEquation;

    FETCH NEXT FROM c_cursor INTO @vEquation;
    END

CLOSE c_cursor;
DEALLOCATE c_cursor;

SELECT  Equation, TotalSum
FROM    Equations;

--Solution 2
--STRING_SPLIT
--This solution will work if you need to only add and subtract.
--Note that STRING_SPLIT does not guarantee order.  Use enable_oridinal if you need to order the output.
--The enable_ordinal argument and ordinal output column are currently supported in Azure SQL Database, Azure SQL Managed Instance, 
--and Azure Synapse Analytics (serverless SQL pool only). Beginning with SQL Server 2022 (16.x), the argument and output column are available in SQL Server.
	
WITH cte_ReplacePositive AS
(
SELECT  Equation,
        REPLACE(Equation,'+',',') AS EquationReplace
FROM    Equations
),
cte_ReplaceNegative AS
(
SELECT  Equation,
        REPLACE(EquationReplace,'-',',-') AS EquationReplace
FROM    cte_ReplacePositive
),
cte_StringSplit AS
(
SELECT  a.Equation, CAST([Value] AS INTEGER) AS [Value]
FROM    cte_ReplaceNegative a CROSS JOIN LATERAL
        STRING_SPLIT(EquationReplace,',')
)
SELECT Equation, SUM([Value]) AS EquationSum
FROM   cte_StringSplit
GROUP BY Equation;
