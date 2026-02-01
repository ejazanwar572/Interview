-- Puzzle 28 - Fill the Gaps
--

-- The answer to this problem is often referred to as a data smear or a flash fill.  

-- Write an SQL statement to fill in the missing gaps.  

/*
| Row Number | Test Case |
|------------|-----------|
| 1          | Alpha     |
| 2          |           |
| 3          |           |
| 4          |           |
| 5          | Bravo     |
| 6          |           |
| 7          | Charlie   |
| 8          |           |
| 9          |           |
*/

-- Here is the expected output.

/*
| Row Number | Workflow |
|------------|----------|
| 1          | Alpha    |
| 2          | Alpha    |
| 3          | Alpha    |
| 4          | Alpha    |
| 5          | Bravo    |
| 6          | Bravo    |
| 7          | Charlie  |
| 8          | Charlie  |
| 9          | Charlie  |
*/


-- ==================================================
-- Solution for Puzzle 28
-- ==================================================

DROP TABLE IF EXISTS Gaps;

CREATE TABLE Gaps
(
RowNumber  INTEGER PRIMARY KEY,
TestCase   VARCHAR(100) NULL
);

INSERT INTO Gaps (RowNumber, TestCase) VALUES
(1,'Alpha'),(2,NULL),(3,NULL),(4,NULL),
(5,'Bravo'),(6,NULL),(7,'Charlie'),(8,NULL),(9,NULL);

--Solution 1
--MAX and COUNT function
WITH cte_Count AS
(
SELECT RowNumber,
       TestCase,
       COUNT(TestCase) OVER (ORDER BY RowNumber) AS DistinctCount
FROM Gaps
)
SELECT  RowNumber,
        MAX(TestCase) OVER (PARTITION BY DistinctCount) AS TestCase
FROM    cte_Count
ORDER BY RowNumber;

--Solution 2
--MAX function without windowing
SELECT  a.RowNumber,
        (SELECT b.TestCase
        FROM    Gaps b
        WHERE   b.RowNumber =
                    (SELECT MAX(c.RowNumber)
                    FROM Gaps c
                    WHERE c.RowNumber <= a.RowNumber AND c.TestCase != '')) TestCase
FROM Gaps a;

--Solution 3
--LAG with IGNORE NULLS
WITH cte_Lag AS
(
SELECT  *,
         LAG(TestCase) IGNORE NULLS OVER (ORDER BY RowNumber) AS LagIgnoreNulls
FROM    Gaps
)
SELECT  RowNumber,
        (CASE WHEN TestCase IS NOT NULL THEN TestCase ELSE LagIgnoreNulls END) AS TestCase
FROM    cte_Lag;	
