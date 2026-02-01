-- Puzzle 27 - Delete the Duplicates
--

-- Given the set of integers provided in the following DDL statement, write an SQL statement that deletes the duplicated integers (1 and 3).

CREATE TABLE SampleData
(
    IntegerValue INTEGER
);

INSERT INTO SampleData VALUES
(1),(1),(2),(3),(3),(4);

-- Here is the expected output.

/*
| Integer Value |
|---------------|
| 1             |
| 2             |
| 3             |
| 4             |
*/


-- ==================================================
-- Solution for Puzzle 27
-- ==================================================

DROP TABLE IF EXISTS SampleData;

CREATE TABLE SampleData
(
IntegerValue  INTEGER NOT NULL
);

INSERT INTO SampleData (IntegerValue) VALUES
(1),(1),(2),(3),(3),(4);

WITH cte_Duplicates AS
(
SELECT  ROW_NUMBER() OVER (PARTITION BY IntegerValue ORDER BY IntegerValue) AS Rnk
FROM    SampleData
)
DELETE FROM cte_Duplicates WHERE Rnk > 1

SELECT * FROM SampleData;
