-- Puzzle 56 - Numbers Using Recursion
--

-- Create a numbers table using a recursive query.

-- Here is the expected output.

/*
| Number |
|--------|
| 1      |
| 2      |
| 3      |
| 4      |
| 5      |
| 6      |
| 7      |
| 8      |
| 9      |
| 10     |
*/


-- ==================================================
-- Solution for Puzzle 56
-- ==================================================

DECLARE @vTotalNumbers INTEGER = 10;

--Solution 1
--SQL Server has GENERATE SERIES begining with version 2022
SELECT value
FROM GENERATE_SERIES(1, 10);

--Solution 2
--Recursion
WITH cte_Number (Number) AS 
(
SELECT  1 AS Number
UNION ALL
SELECT  Number + 1
FROM    cte_Number
WHERE   Number < @vTotalNumbers
)
SELECT  Number
FROM    cte_Number
;--A value of 0 means no limit to the recursion level
