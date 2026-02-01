-- Puzzle 11 - Permutations
--

-- You are given the following list of test cases and must determine all possible permutations.  

-- Write an SQL statement that produces the expected output. Ensure your code can account for a changing number of elements without rewriting.  

/*
| Test Case |
|-----------|
| A         |
| B         |
| C         |
*/

-- Here is the expected output.

/*
| Test Cases |
|------------|
| A,B,C      |
| A,C,B      |
| B,A,C      |
| B,C,A      |
| C,A,B      |
| C,B,A      |
*/


-- Solution
-- Solution for Puzzle 11: Permutations
WITH RecursiveCTE AS (
    SELECT TestCase AS Permutation, CAST(TestCase AS VARCHAR(MAX)) AS Path, 1 AS Level
    FROM TestCases
    UNION ALL
    SELECT t.TestCase, CAST(c.Path + ',' + t.TestCase AS VARCHAR(MAX)), c.Level + 1
    FROM TestCases t
    JOIN RecursiveCTE c ON INSTR(c.Path, t.TestCase) = 0
)
SELECT Path FROM RecursiveCTE WHERE Level = (SELECT COUNT(*) FROM TestCases);


-- ==================================================
-- Solution for Puzzle 11
-- ==================================================

DROP TABLE IF EXISTS TestCases;

CREATE TABLE TestCases
(
TestCase  VARCHAR(1) PRIMARY KEY
);

INSERT INTO TestCases (TestCase) VALUES
('A'),('B'),('C');

DECLARE @vTotalElements INTEGER = (SELECT COUNT(*) FROM TestCases);

--Recursion
WITH cte_Permutations (Permutation, Id, Depth)
AS
(
SELECT  CAST(TestCase AS VARCHAR(MAX)),
        CONCAT(CAST(TestCase AS VARCHAR(MAX)),';'),
        1 AS Depth
FROM    TestCases
UNION ALL
SELECT  CONCAT(a.Permutation,',',b.TestCase),
        CONCAT(a.Id,b.TestCase,';'),
        a.Depth + 1
FROM    cte_Permutations a,
        TestCases b
WHERE   a.Depth < @vTotalElements AND
        a.Id NOT LIKE CONCAT('%',b.TestCase,';%')
)
SELECT  Permutation
FROM    cte_Permutations
WHERE   Depth = @vTotalElements;
