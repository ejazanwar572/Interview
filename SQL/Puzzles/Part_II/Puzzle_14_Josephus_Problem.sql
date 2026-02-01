-- Puzzle 14 - Josephus Problem
--

-- Solve the [Josephus Problem](https://en.wikipedia.org/wiki/Josephus_problem).  


-- Solution
-- Solution for Puzzle 14: Indeterminate Process Log
WITH StatusCounts AS (
    SELECT Workflow,
           SUM(CASE WHEN Status = 'Error' THEN 1 ELSE 0 END) AS ErrorCount,
           SUM(CASE WHEN Status = 'Running' THEN 1 ELSE 0 END) AS RunningCount,
           SUM(CASE WHEN Status = 'Complete' THEN 1 ELSE 0 END) AS CompleteCount,
           COUNT(*) AS TotalCount
    FROM ProcessLog
    GROUP BY Workflow
)
SELECT Workflow,
       CASE
           WHEN ErrorCount > 0 AND ErrorCount < TotalCount THEN 'Indeterminate'
           WHEN ErrorCount = TotalCount THEN 'Error'
           WHEN RunningCount > 0 AND CompleteCount > 0 THEN 'Running'
           WHEN RunningCount = TotalCount THEN 'Running'
           WHEN CompleteCount = TotalCount THEN 'Complete'
       END AS Status
FROM StatusCounts;


-- ==================================================
-- Solution for Puzzle 14
-- ==================================================

/*********************************************************************
Scott Peters
Josephus Problem
https://advancedsqlpuzzles.com
Last Updated: 02/07/2023
Microsoft SQL Server T-SQL

This script runs an iteration of the Josephus Problem.
https://en.wikipedia.org/wiki/Josephus_problem
**********************************************************************/

-------------------------------
-------------------------------
--Tables used
DROP TABLE IF EXISTS Numbers;
DROP TABLE IF EXISTS Soldiers;
DROP SEQUENCE IF EXISTS JosephusSequence

-------------------------------
-------------------------------
--Create sequence dbo.JosephusSequence
--Set the MAXVALUE to the number of soldiers
CREATE SEQUENCE dbo.JosephusSequence AS TINYINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 14----------------------------------------------------Set to the number of soldiers!
    CYCLE;

-------------------------------
-------------------------------
--Create and populate a Numbers table
--You may need to increase this number based on the number of sequences you need to create!
DECLARE @vTotalNumbers INTEGER = 100;

WITH cte_Number (Number)
AS (
    SELECT 1 AS Number
    UNION ALL
    SELECT  Number + 1
    FROM   cte_Number
    WHERE  Number <= @vTotalNumbers
    )
SELECT Number
INTO   Numbers
FROM   cte_Number;

-------------------------------
-------------------------------
--Create table Soldiers
CREATE TABLE Soldiers
(
RowNumber       INTEGER IDENTITY(1,1) PRIMARY KEY,
SoldierNumber   INTEGER NOT NULL,
Iterator        INTEGER NULL,
UpdateDate      DATETIME NULL
);

-------------------------------
-------------------------------
--Insert into Soldiers using Numbers table
INSERT INTO Soldiers (SoldierNumber)
SELECT  (NEXT VALUE FOR dbo.JosephusSequence)
FROM    Numbers;

-------------------------------
-------------------------------
--Declare and set variables
DECLARE @vCycle INTEGER = 2;---------------------------------------Set this to the cycle number!

--Do not change this variable
DECLARE @vIterator INTEGER = 1;

-------------------------------
-------------------------------
--Seed the Soldiers table
UPDATE  Soldiers
SET     Iterator = @vIterator,
        UpdateDate = NOW()
WHERE   SoldierNumber = @vCycle;

-------------------------------
-------------------------------
--Use a WHILE loop to determine which order soldiers are killed
WHILE (SELECT COUNT(DISTINCT SoldierNumber) FROM Soldiers WHERE Iterator IS NULL) > 1
        BEGIN

        DROP TABLE IF EXISTS SoldiersTemp;


        WITH cte_RowNumberEstablish AS
        (
        SELECT  ROW_NUMBER() OVER (ORDER BY RowNumber) AS RowNumberNew,
                *
        FROM    Soldiers
        WHERE   Iterator IS NULL AND
                RowNumber > (SELECT MIN(RowNumber) FROM Soldiers WHERE Iterator = @vIterator)
        )
        UPDATE  Soldiers
        SET     Iterator = @vIterator + 1,
                UpdateDate = NOW()
        WHERE   SoldierNumber IN (SELECT SoldierNumber FROM cte_RowNumberEstablish WHERE RowNumberNew = @vCycle);

        SET @vIterator = @vIterator + 1;

        END;  --End Loop

-------------------------------
-------------------------------
--Display the results
SELECT  SoldierNumber,
        UpdateDate,
        Iterator,
        (CASE WHEN UpdateDate IS NULL THEN 'Winner' END) AS Status
FROM    Soldiers
GROUP BY SoldierNumber,
        UpdateDate,
        Iterator
ORDER BY (CASE WHEN UpdateDate IS NULL THEN NOW() ELSE UpdateDate END);

/*
You can also solve the Josephus problem via this simple loop,
but you will be unable to determine in which order each soldier was killed.



DECLARE @i INTEGER = 1;
DECLARE @ans INTEGER = 0;
DECLARE @n INTEGER = 14;
DECLARE @k INTEGER = 2;

WHILE(@i <= @n)
BEGIN
    SET @ans = (@ans + @k) % @i;
    PRINT CONCAT('@ans is ', @ans);
    SET @i = 1 + @i;
    PRINT CONCAT('@i is ',@i);
END
PRINT @ans + 1;
*/
