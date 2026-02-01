-- Puzzle 1 - Factorials
--

-- Create a numbers table of 1 through 10 and their factorial.

-- Here is the expected output.

/*
| Number | Factorial |
|--------|-----------|
| 1      | 1         |
| 2      | 2         |
| 3      | 6         |
| 4      | 24        |
| 5      | 120       |
| 6      | 720       |
| 7      | 5,040     |
| 8      | 40,320    |
| 9      | 362,880   |
| 10     | 3,628,800 |
*/


-- ==================================================
-- Solution for Puzzle 1
-- ==================================================

/*********************************************************************
Scott Peters
Factorials
https://advancedsqlpuzzles.com
Last Updated: 01/13/2023
Microsoft SQL Server T-SQL
**********************************************************************/

---------------------
---------------------
--Tables used in script
DROP TABLE IF EXISTS Numbers;

---------------------
---------------------
--Declare and set variables
DECLARE @vTotalNumbers INTEGER = 10;

---------------------
---------------------
--Create Numbers table using recursion
WITH cte_Factorial (Number, Factorial) AS
(
SELECT 1,
       1
UNION ALL
SELECT  Number + 1 AS Number,
       (Number + 1) * Factorial AS Factorial
FROM   cte_Factorial
WHERE  Number < @vTotalNumbers
)
SELECT Number,
       Factorial
INTO   Numbers
FROM   cte_Factorial
;--A value of 0 means no limit to the recursion level

---------------------
---------------------
--Display the results
SELECT *
FROM   Numbers;
