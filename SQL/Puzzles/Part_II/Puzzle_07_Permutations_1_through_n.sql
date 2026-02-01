-- Puzzle 7 - Permutations 1 through n
--

-- Display all permutations for the numbers 1 through n, displaying only the first n numbers.

-- Here is the expected output for all 24 permutations of the set {1, 2, 3, 4}, displaying only the first three numbers.

/*
| Permutation |
|-------------|
| 1,2,3       |
| 1,2,4       |
| 1,3,2       |
| 1,3,4       |
| 1,4,2       |
| 1,4,3       |
| 2,1,3       |
| 2,1,4       |
| 2,3,1       |
| 2,3,4       |
| 2,4,1       |
| 2,4,3       |
| 3,1,2       |
| 3,1,4       |
| 3,2,1       |
| 3,2,4       |
| 3,4,1       |
| 3,4,2       |
| 4,1,2       |
| 4,1,3       |
| 4,2,1       |
| 4,2,3       |
| 4,3,1       |
| 4,3,2       |
*/


-- ==================================================
-- Solution for Puzzle 7
-- ==================================================

/*--------------------------------------------------------------------------------------------------------
Scott Peters
Permutations 1 Through 10 (Bit Mask)
https://advancedsqlpuzzles.com
Last Updated: 01/13/2023
Microsoft SQL Server T-SQL
*/--------------------------------------------------------------------------------------------------------

-------------------------------
-------------------------------
--Tables used
DROP TABLE IF EXISTS Numbers;
DROP TABLE IF EXISTS Permutations;
DROP TABLE IF EXISTS PermutationsPosition;

-------------------------------
-------------------------------
--Declare and set the variables
DECLARE @vLengthNumbers INTEGER = 3;

-------------------------------
-------------------------------
--Create Numbers table and populate
SELECT  Number
INTO    Numbers
FROM
--(VALUES (1), (2), (3)) n(Number);
--(VALUES (10), (21), (32)) n(Number);
(VALUES (1), (2), (3), (4)) n(Number);
--(VALUES (1), (2), (3), (4), (5)) n(Number);
--(VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10)) n(Number);

-------------------------------
-------------------------------
--Create Permutations table and populate
WITH cte_Numbers AS 
(
SELECT  CAST(Number AS VARCHAR(MAX)) AS Number
FROM    Numbers
),
cte_Bitmasks AS
(
SELECT
        Number,
        CAST(POWER(2, ROW_Number() OVER (ORDER BY Number) - 1) AS INT) AS Bitmask
FROM    cte_Numbers
),
cte_Permutations AS
(
SELECT  Number AS Permutation,
        Bitmask
FROM    cte_Bitmasks

UNION ALL

SELECT  p.Permutation + ',' + b.Number,
        p.Bitmask ^ b.Bitmask
FROM    cte_Permutations p INNER JOIN
        cte_Bitmasks b ON p.Bitmask ^ b.Bitmask > p.Bitmask
)
SELECT  ROW_NUMBER() OVER (ORDER BY NOW()) AS Id,
        Permutation
INTO    Permutations
FROM    cte_Permutations
WHERE   Bitmask = POWER(2, (SELECT COUNT(*) FROM cte_Numbers)) - 1

-------------------------------
-------------------------------
--Creates table PermutationsPosition
--Determines the position of commas
;WITH cte_CAST AS
(
SELECT Id, CAST(Permutation AS VARCHAR(20)) AS Permutation FROM Permutations
),
cte_Anchor AS
(
SELECT Id,
       Permutation,
       1 AS Starts,
       INSTR(', Permutation, ') AS Position
FROM   cte_CAST
UNION ALL
SELECT Id,
       Permutation,
       Position + 1,
       INSTR(', Permutation, Position + 1, ')
FROM   cte_Anchor
WHERE  Position > 0
)
SELECT *,
       SUBSTRING(Permutation, Starts, CASE WHEN Position > 0 THEN Position - Starts ELSE LENGTH(Permutation) END) Token,
       ROW_NUMBER() OVER (PARTITION BY Id ORDER BY Starts) AS RowNumber
INTO   PermutationsPosition
FROM   cte_Anchor
ORDER BY Permutation, Starts;

-------------------------------
-------------------------------
--Display the results
SELECT DISTINCT
       LEFT(Permutation,Starts) AS Permutation
FROM   PermutationsPosition
WHERE  RowNumber = @vLengthNumbers;


-- ==================================================
-- Solution for Puzzle 7
-- ==================================================

/*---------------------------------------------------------------------------------------------
Scott Peters
Permutations 1 Through 10 (Cross Join)
https://advancedsqlpuzzles.com
Last Updated: 01/13/2023
Microsoft SQL Server T-SQL
*/---------------------------------------------------------------------------------------------

-------------------------------
-------------------------------
--Tables used
DROP TABLE IF EXISTS Numbers;
-------------------------------
-------------------------------
--Create Numbers table and populate
SELECT  Number
INTO	Numbers
FROM (VALUES (1), (2), (3), (4)) n(Number);

-------------------------------
-------------------------------
--Two digits
SELECT  CONCAT(a.Number,',',b.Number) AS Permutation
FROM    Numbers a INNER JOIN
        Numbers b on a.Number <> b.Number;

--Two digits (Version 2)
SELECT  CONCAT(a.Number,',',b.Number) AS Permutation
FROM    Numbers a CROSS JOIN
        Numbers b
WHERE   a.Number NOT IN (b.Number)
ORDER BY 1;

-------------------------------
-------------------------------
--Three digits
SELECT  CONCAT(a.Number,',',b.Number,',',c.Number) AS Permutation
FROM    Numbers a CROSS JOIN
        Numbers b CROSS JOIN
        Numbers c
WHERE   a.Number NOT IN (b.Number, c.Number) AND
        b.Number NOT IN (c.Number)
ORDER BY 1;

-------------------------------
-------------------------------
--Four digits
SELECT  CONCAT(a.Number,',',b.Number,',',c.Number,',',d.Number) AS Permutation
FROM    Numbers a CROSS JOIN
        Numbers b CROSS JOIN
        Numbers c CROSS JOIN
        Numbers d 
WHERE   a.Number NOT IN (b.Number, c.Number, d.Number) AND
        b.Number NOT IN (c.Number, d.Number) AND
        c.Number NOT IN (d.Number)
ORDER BY 1;

----And so on for 5,6,7.....
