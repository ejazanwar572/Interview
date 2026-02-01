-- Puzzle 5 - Add the Numbers Up
--

-- Given an ordered set of numbers 1 through n (for example, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10), and a + or – sign at all possible groupings, create all possible permutations and the amount to which they add up.

-- Here is the expected output for the set of {1, 2, 3}.

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
-- Solution for Puzzle 5
-- ==================================================

/*********************************************************************
Scott Peters
Add The Numbers Up
https://advancedsqlpuzzles.com
Last Updated: 03/27/2023
Microsoft SQL Server T-SQL
**********************************************************************/

---------------------
---------------------
--Tables used
DROP TABLE IF EXISTS Numbers;
DROP TABLE IF EXISTS Permutations;
DROP TABLE IF EXISTS PermutationsString;
DROP TABLE IF EXISTS PermutationsDynamicAdd;
DROP TABLE IF EXISTS Operators;

-------------------------------
-------------------------------
--Create Operators table and populate
CREATE TABLE Operators
(
Operator CHAR(1) NOT NULL
);

INSERT INTO Operators VALUES ('-'),('+');
-------------------------------
-------------------------------
--For this puzzle, I manually create the Numbers table to provide special testing cases (rather than using recursion)
CREATE TABLE Numbers
(
Number INTEGER NOT NULL
);

INSERT INTO Numbers (Number) VALUES
(1),(2),(3); --Passes
--(1),(2),(3),(4),(5); --Passes
--(6),(7),(8),(9),(10); --Passes
--(5),(7),(8),(9),(10); --Does Not Pass (Gap between 5 and 7)
--(7),(8),(9),(10),(11); --Does Not Pass (Two numbers greater than 10)
--(10),(11),(12); --Does Not Pass (Lowest number is not a single digit and the set contains two numbers greater than 10)

-------------------------------
-------------------------------
--Declare and set variables
DECLARE @vTotalNumbers INTEGER = (SELECT COUNT(*) FROM Numbers);

-------------------------------
-------------------------------
--Populate the Permutations table with all possible permutations
WITH cte_Permutations (Permutation, Ids, Depth)
AS
(
SELECT  CAST(Number AS VARCHAR(MAX)) AS Permutation,
        CAST(CONCAT(Number,'') AS VARCHAR(MAX)) AS Ids,
        1 AS Depth
FROM    Numbers
UNION ALL
SELECT  CONCAT(a.Permutation,b.Number),
        CONCAT(a.Ids,b.Number),
        a.Depth + 1
FROM    cte_Permutations a,
        Numbers b
WHERE   a.Depth < @vTotalNumbers AND
        CAST(RIGHT(a.Ids,1) AS INTEGER) + 1  = b.Number
)
SELECT  Permutation
INTO    Permutations
FROM    cte_Permutations;

-------------------------------
-------------------------------
--Create the PermutationsString table and provide initial seed
SELECT  Permutation
INTO    PermutationsString
FROM    Permutations;

-------------------------------
-------------------------------
--Populate the PermutationsString via a WHILE loop
WHILE @@ROWCOUNT > 0
    BEGIN

    WITH cte_Permutations AS
    (
    SELECT  DISTINCT
            a.permutation AS A_Permutation,
            b.permutation AS B_Permutation
    FROM    PermutationsString a INNER JOIN
            PermutationsString b ON RIGHT(a.Permutation,1) = LEFT(b.Permutation,1) - 1
    )
    INSERT INTO PermutationsString (Permutation)
    SELECT  DISTINCT CONCAT(p.a_Permutation,o.Operator,p.b_Permutation) AS Permutation
    FROM    cte_Permutations p CROSS JOIN
            Operators o
    WHERE   CONCAT(p.a_Permutation,o.Operator,p.b_Permutation) NOT IN (SELECT Permutation FROM PermutationsString);

    END;

-------------------------------
-------------------------------
--Populate the PermutationsDynamicAdd table from the PermutationsString table
SELECT  Permutation, 
        CAST(NULL AS BIGINT) AS TotalSum
INTO    PermutationsDynamicAdd
FROM    PermutationsString
WHERE   LEFT(Permutation,1) = (SELECT MIN(Number) FROM Numbers) 
        AND
        INSTR(Permutation, (SELECT CAST(MAX(Number) AS VARCHAR(100)) FROM Numbers)) > 0;

---------------------
---------------------
--Uses a cursor and dynamic SQL to update the TotalSum column
DECLARE @vSQLStatement NVARCHAR(1000);
DECLARE perm_cursor CURSOR FOR (SELECT Permutation FROM PermutationsDynamicAdd);
DECLARE @vEquation NVARCHAR(1000);
DECLARE @vSum BIGINT;

OPEN perm_cursor;

FETCH NEXT FROM perm_cursor INTO @vEquation;

WHILE @@FETCH_STATUS = 0
    BEGIN

    SELECT  @vSQLStatement = CONCAT('SELECT @var = ',@vEquation);
        
    EXECUTE sp_executesql @vSQLStatement, N'@var BIGINT OUTPUT', @var = @vSum OUTPUT;
        
    UPDATE  PermutationsDynamicAdd
    SET     TotalSum = @vSum
    WHERE   Permutation = @vEquation;

    FETCH NEXT FROM perm_cursor INTO @vEquation;
    END

CLOSE perm_cursor;
DEALLOCATE perm_cursor;

---------------------
---------------------
--Display the results
SELECT  * 
FROM    PermutationsDynamicAdd;
