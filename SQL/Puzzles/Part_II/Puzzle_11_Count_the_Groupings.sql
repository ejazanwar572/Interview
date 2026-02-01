-- Puzzle 11 - Count the Groupings
--

-- Write an SQL statement that counts the consecutive values in the `Status` column.

/*
| Step Number | Status |
|-------------|--------|
| 1           | Passed |
| 2           | Passed |
| 3           | Passed |
| 4           | Passed |
| 5           | Failed |
| 6           | Failed |
| 7           | Failed |
| 8           | Failed |
| 9           | Failed |
| 10          | Passed |
| 11          | Passed |
| 12          | Passed |
*/

-- Here is the expected output.

/*
| Min Step Number | Max Step Number | Status | Consecutive Count |
|-----------------|-----------------|--------|-------------------|
| 1               | 4               | Passed | 4                 |
| 5               | 9               | Failed | 5                 |
| 10              | 12              | Passed | 3                 |
*/


-- ==================================================
-- Solution for Puzzle 11
-- ==================================================

/*********************************************************************
Scott Peters
Count the Groupings
https://advancedsqlpuzzles.com
Last Updated: 01/13/2023
Microsoft SQL Server T-SQL
**********************************************************************/

--------------
--------------
--Tables Used
DROP TABLE IF EXISTS Groupings;
DROP TABLE IF EXISTS Groupings2;

--------------
--------------
--Groupings
CREATE TABLE Groupings
(
StepNumber  INTEGER PRIMARY KEY,
TestCase    VARCHAR(100),
[Status]    VARCHAR(100)
);

INSERT INTO Groupings VALUES
(1,'Test Case 1','Passed'),
(2,'Test Case 2','Passed'),
(3,'Test Case 3','Passed'),
(4,'Test Case 4','Passed'),
(5,'Test Case 5','Failed'),
(6,'Test Case 6','Failed'),
(7,'Test Case 7','Failed'),
(8,'Test Case 8','Failed'),
(9,'Test Case 9','Failed'),
(10,'Test Case 10','Passed'),
(11,'Test Case 11','Passed'),
(12,'Test Case 12','Passed');

--------------
--------------
--Create and insert into Groupings2
SELECT  StepNumber,
        [Status],
        StepNumber - ROW_NUMBER() OVER (PARTITION BY [Status] ORDER BY StepNumber) AS Rnk
INTO    Groupings2
FROM    Groupings
ORDER BY 2;

--------------
--------------
--Display the results
SELECT  MIN(StepNumber) AS MinStepNumber,
        MAX(StepNumber) as MaxStepNumber,
        [Status],
        MAX(StepNumber) - MIN(StepNumber) + 1 AS ConsecutiveCount
FROM    Groupings2
GROUP BY Rnk,
        [Status]
ORDER BY 1, 2;
