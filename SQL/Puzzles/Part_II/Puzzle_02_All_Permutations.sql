-- Puzzle 2 - All Permutations
--

-- Create a numbers table of all permutations of n distinct numbers. The example below uses the set {1, 2, 3}.

-- Here is the expected output.

/*
| Max Number | Permutation |
|------------|-------------|
| 3          | 1,2,3       |
| 3          | 1,3,2       |
| 3          | 2,1,3       |
| 3          | 2,3,1       |
| 3          | 3,1,2       |
| 3          | 3,2,1       |
*/


-- ==================================================
-- Solution for Puzzle 2
-- ==================================================

/*********************************************************************
Scott Peters
All Permutations
https://advancedsqlpuzzles.com
Last Updated: 01/13/2023
Microsoft SQL Server T-SQL
**********************************************************************/

---------------------
---------------------
--Tables used
DROP TABLE IF EXISTS Numbers;
DROP TABLE IF EXISTS Permutations;

---------------------
---------------------
--Declare and set variables
DECLARE @vTotalNumbers INTEGER = 3;

---------------------
---------------------
--Create a Numbers table using recursion
WITH cte_Numbers (Number)
AS (
    SELECT 1 AS Number
    UNION ALL
    SELECT  Number + 1
    FROM   cte_Numbers
    WHERE  Number < @vTotalNumbers
)
SELECT
       Number
INTO    Numbers
FROM   cte_Numbers
;--A value of 0 means no limit to the recursion level

---------------------
---------------------
--Populate the Permutations table with all possible permutations
WITH cte_Permutations (Permutation, Ids, Depth)
AS
(
SELECT  CAST(Number AS VARCHAR(MAX)),
        CAST(CONCAT(Number,';') AS VARCHAR(MAX)),
        1 AS Depth
FROM    Numbers
UNION ALL
SELECT  CONCAT(a.Permutation,',',b.Number),
        CONCAT(a.Ids,b.Number,';'),
        a.Depth + 1
FROM    cte_Permutations a,
        Numbers b
WHERE   a.Depth < @vTotalNumbers AND
        a.Ids NOT LIKE CONCAT('%',b.Number,';%')
)
SELECT  Permutation
INTO    Permutations
FROM    cte_Permutations;
---------------------
---------------------
--Display the results
SELECT  * 
FROM    Permutations
WHERE   LENGTH(Permutation) = (SELECT MAX(LENGTH(Permutation)) FROM Permutations)
ORDER BY 1;


-- ==================================================
-- Solution for Puzzle 2
-- ==================================================

/*********************************************************************
Scott Peters
All Permutations
https://advancedsqlpuzzles.com
Last Updated: 02/07/2023
Microsoft SQL Server T-SQL
**********************************************************************/

---------------------
---------------------
--Tables used
DROP TABLE IF EXISTS Numbers;
DROP TABLE IF EXISTS Permutations;

---------------------
---------------------
--Declare and set variables
DECLARE @vTotalNumbers BIGINT = 3;

---------------------
---------------------
--Create a Numbers table using recursion
WITH cte_Numbers (Number)
AS (
    SELECT 1 AS Number
    UNION ALL
    SELECT  Number + 1
    FROM   cte_Numbers
    WHERE  Number < @vTotalNumbers
)
SELECT
       Number
INTO    Numbers
FROM   cte_Numbers
;--A value of 0 means no limit to the recursion level

---------------------
---------------------
--Generate the Permutations using recursion
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
WHERE   Bitmask = POWER(2, (SELECT COUNT(*) FROM cte_Numbers)) - 1;

---------------------
---------------------
--Display the results
SELECT @vTotalNumbers AS MaxNumber,
        Permutation
FROM   Permutations
ORDER BY 2;


-- ==================================================
-- Solution for Puzzle 2
-- ==================================================

/*********************************************************************
Scott Peters
All Permutations
https://advancedsqlpuzzles.com
Last Updated: 02/07/2023
Microsoft SQL Server T-SQL
**********************************************************************/

---------------------
---------------------
--Tables used
DROP TABLE IF EXISTS Numbers;
DROP TABLE IF EXISTS Permutations;

---------------------
---------------------
--Set the number of permutations to create
DECLARE @vTotalNumbers BIGINT = 3;

---------------------
---------------------
--Create a Numbers table using recursion
WITH cte_Numbers (Number)
AS (
    SELECT 1 AS Number
    UNION ALL
    SELECT  Number + 1
    FROM   cte_Numbers
    WHERE  Number < @vTotalNumbers
)
SELECT
       Number
INTO    Numbers
FROM   cte_Numbers
;--A value of 0 means no limit to the recursion level

---------------------
---------------------
--Create the Permutations table and provide initial seed
SELECT  CAST(Number AS VARCHAR(100)) AS Permutation,
        NOW() AS InsertDate
INTO    Permutations
FROM Numbers;

---------------------
---------------------
--Populate the Permutations table
WHILE @@ROWCOUNT > 0
    BEGIN

    --Used to keep the table record count to a minimal
    DELETE Permutations WHERE InsertDate < (SELECT MAX(InsertDate) FROM Permutations);

    INSERT INTO Permutations (Permutation, InsertDate)
    SELECT  CONCAT(a.Permutation, ',', b.Number),
            NOW()
    FROM    Permutations a CROSS JOIN
            Numbers b
    WHERE   CAST(REPLACE(RIGHT(a.Permutation,2),',','') AS INTEGER) <> b.Number
            AND
            INSTR(',', CONCAT(b.Number),CONCAT(a.Permutation,',')) = 0;
    END;

---------------------
---------------------
--Display the results
SELECT  @vTotalNumbers AS MaxNumber,
        Permutation
FROM    Permutations
ORDER BY Permutation;
