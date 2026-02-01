-- Puzzle 4 - Non-Adjacent Numbers
--

-- Given an ordered set of numbers (for example, {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}), create a result set of permutations where no two adjacent entries are adjacent numbers.

-- For example, {1, 3, 5, 7, 9, 2, 4, 6, 8, 10} fits the criteria.  
-- However, {1, 2, 4, 6, 8, 10, 3, 5, 7, 9}, {1, 4, 2, 6, 7, 10, 3, 5, 8, 9}, and {1, 3, 2, 6, 7, 10, 9, 5, 8, 4} do not fit because they contain adjacent numbers next to each other.

-- Here is the expected output.

/*
| Permutation |
|-------------|
| 2,4,1,3     |
| 3,1,4,2     |
*/


-- ==================================================
-- Solution for Puzzle 4
-- ==================================================

/*********************************************************************
Scott Peters
Non-Adjacent Numbers
https://advancedsqlpuzzles.com
Last Updated: 01/13/2023
Microsoft SQL Server T-SQL
**********************************************************************/

---------------------
---------------------
--Tables used
DROP TABLE IF EXISTS Numbers;
DROP TABLE IF EXISTS Permutations;
DROP TABLE IF EXISTS PermutationsMaxCharIndex;

---------------------
---------------------
--For this puzzle, I manually create the Numbers table to provide special testing cases (rather than using recursion)
CREATE TABLE Numbers
(
Number INT NOT NULL
);

INSERT INTO Numbers (Number) VALUES
--(1),(2),(3),(4);--,(4),(5),(6),(7),(8),(9),(10);  --Correct results
(5),(7),(9),(11);--,(4),(5),(6),(7),(8),(9),(10);  --Correct results

---------------------
---------------------
--Create the Permutations table using recursion
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
SELECT  Permutation,
        0 AS HasAdjacentNumbers
INTO    Permutations
FROM    cte_Permutations
WHERE   Bitmask = POWER(2, (SELECT COUNT(*) FROM cte_Numbers)) - 1;

---------------------
---------------------
--Create the PermutationsMaxCharIndex table
WITH cte_AdjacentNumbers AS
(
SELECT  'A' AS Id, CONCAT(a.Number,',',b.Number) AS AdjacentNumbers
FROM    Numbers a INNER JOIN
        Numbers b ON a.Number = (b.Number + 1)
UNION
SELECT  'B', CONCAT(b.Number,',',a.Number)  --note this is the reciprocal of the above AdjacentNumbers column
FROM    Numbers a INNER JOIN
        Numbers b ON a.Number = (b.Number + 1)
)
SELECT  a.Permutation,
        MAX(INSTR(',', CONCAT(b.AdjacentNumbers),CONCAT(a.Permutation,','))) AS MaxCharIndex
INTO    PermutationsMaxCharIndex
FROM    Permutations a CROSS JOIN
        cte_AdjacentNumbers b
GROUP BY a.Permutation;

---------------------
---------------------
--Update the Permutations table using PermutationsMaxCharIndex
UPDATE  Permutations
SET     HasAdjacentNumbers = 1
FROM    Permutations a INNER JOIN
        PermutationsMaxCharIndex b on a.Permutation = b.Permutation
WHERE   MaxCharIndex > 0;

---------------------
---------------------
--View the results
SELECT *
FROM   Permutations
ORDER BY 2;


-- ==================================================
-- Solution for Puzzle 4
-- ==================================================

/*********************************************************************
Scott Peters
Non-Adjacent Numbers
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
--Create Permutations table
CREATE TABLE Permutations
(
InsertDate DATETIME DEFAULT NOW() NOT NULL,
Id INTEGER Identity(1,1) NOT NULL,
Permutation VARCHAR(100) NOT NULL
);

---------------------
---------------------
--For this puzzle, I manually create the Numbers table to provide special testing cases (rather than using recursion)
CREATE TABLE Numbers
(
Number INTEGER NOT NULL
);

INSERT INTO Numbers (Number) VALUES
(1),(2),(3),(4);--,(4),(5),(6),(7),(8),(9),(10);  --Correct results
--(5),(7),(9),(11);--,(4),(5),(6),(7),(8),(9),(10);  --Correct results

---------------------
---------------------
--Seed the Permutations puzzle
INSERT INTO Permutations (Permutation)
SELECT CAST(Number as VARCHAR(100)) FROM Numbers;

---------------------
---------------------
--Populate the Permutations table
WHILE @@ROWCOUNT > 0
    BEGIN

    --Used to keep the table record count to a minimum
    DELETE Permutations WHERE InsertDate < (SELECT MAX(InsertDate) FROM Permutations);

    INSERT INTO Permutations (Permutation)
    SELECT  CONCAT(a.Permutation, ',', b.Number)
    FROM    Permutations a CROSS JOIN
            Numbers b
    WHERE   
            CAST(REPLACE(RIGHT(a.Permutation,2),',','') AS INTEGER) <> b.Number + 1
            AND
            CAST(REPLACE(RIGHT(a.Permutation,2),',','') AS INTEGER) <> B.Number - 1
            --AND
            --INSTR(',b.Number,',', CONCAT('),CONCAT(',',a.Permutation,',')) = 0;
            AND
            INSTR(',', CONCAT(b.Number),CONCAT(a.Permutation,',')) = 0;
    END
---------------------
---------------------
--Display the results
SELECT  *
FROM    Permutations;
