-- Puzzle 9 - Find the Spaces
--

-- Given the following table of SQL statements, provide a numbers table that displays a summary of the space character for each SQL statement.

/*
|        Statement        |
|-------------------------|
| SELECT EmpID FROM Emps; |
| SELECT * FROM Trans;    |
*/

-- Here is the expected output.

/*
| RowNumber | Id |          String           | Starts | NextSpacePos | Word   | TotalSpaces |
|-----------|----|---------------------------|--------|--------------|--------|-------------|
| 1         | 1  | `SELECT EmpID FROM Emps;` | 1      | 7            | SELECT | 3           |
| 2         | 1  | `SELECT EmpID FROM Emps;` | 8      | 13           | EmpID  | 3           |
| 3         | 1  | `SELECT EmpID FROM Emps;` | 14     | 18           | FROM   | 3           |
| 4         | 1  | `SELECT EmpID FROM Emps;` | 19     |              | Emps   | 3           |
| 1         | 2  | `SELECT * FROM Trans;`    | 1      | 7            | SELECT | 3           |
| 2         | 2  | `SELECT * FROM Trans;`    | 8      | 9            | `*`    | 3           |
| 3         | 2  | `SELECT * FROM Trans;`    | 10     | 14           | FROM   | 3           |
| 4         | 2  | `SELECT * FROM Trans;`    | 15     |              | Trans  | 3           |
*/


-- ==================================================
-- Solution for Puzzle 9
-- ==================================================

/*********************************************************************
Scott Peters
Find The Spaces
https://advancedsqlpuzzles.com
Last Updated: 02/07/2023
Microsoft SQL Server T-SQL
**********************************************************************/

-------------------------------
-------------------------------
--Tables Used
DROP TABLE IF EXISTS Strings;

-------------------------------
-------------------------------
--Create table Quotes
SELECT *
INTO Strings
FROM (VALUES(1,'SELECT EmpID, MngrID FROM Employees;'),(2,'SELECT * FROM Transactions;')) n(Id,String);

-------------------------------
-------------------------------
--Display the results using recursion
WITH cte_CAST AS
(
SELECT Id, CAST(String AS VARCHAR(200)) AS String FROM Strings
),
cte_Anchor AS
(
SELECT Id,
       String,
       1 AS Starts,
       INSTR(String, ' ') AS Position
FROM   cte_CAST
UNION ALL
SELECT Id,
       String,
       Position + 1,
       INSTR(String, Position + 1, ' ')
FROM   cte_Anchor
WHERE  Position > 0
)
SELECT  ROW_NUMBER() OVER (PARTITION BY Id ORDER BY Starts) AS RowNumber,
        *,
        SUBSTRING(String, Starts, CASE WHEN Position > 0 THEN Position - Starts ELSE LENGTH(String) END) Word,
        LENGTH(String) - LENGTH(REPLACE(String,' ','')) AS TotalSpaces
FROM   cte_Anchor
ORDER BY Id, Starts;
