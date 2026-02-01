-- Puzzle 31 - Second Highest
--

-- Given the set of unique integers in the following DDL statement, how many different SQL statements can you write that will return the second-highest integer?

CREATE TABLE SampleData
(
IntegerValue INTEGER PRIMARY KEY
);

INSERT INTO SampleData VALUES
(3759),(3760),(3761),(3762),(3763);

-- Here is the expected output.

/*
| Integer Value |
|---------------|
| 3762          |
*/

-- **Bonus**
-- How would you construct an SQL query to retrieve the second-highest salary (a non-unique value) from a dataset? The result will show $150,000.

/*
|         Name         |  Salary |
|----------------------|---------|
| Carl Friedrich Gauss | 250,000 |
| Evariste Galois      | 250,000 |
| Pierre-Simon Laplace | 150,000 |
| Sophie Germain       | 150,000 |
| Leonhard Euler       | 100,000 |
*/


-- ==================================================
-- Solution for Puzzle 31
-- ==================================================

DROP TABLE IF EXISTS SampleData;

CREATE TABLE SampleData
(
IntegerValue  INTEGER PRIMARY KEY
);

INSERT INTO SampleData (IntegerValue) VALUES
(3759),(3760),(3761),(3762),(3763);

--Solution 1
--RANK
WITH cte_Rank AS
(
SELECT  RANK() OVER (ORDER BY IntegerValue DESC) AS MyRank,
        *
FROM    SampleData
)
SELECT  IntegerValue
FROM    cte_Rank
WHERE   MyRank = 2;--Solution 2
--Top 1 and Max
SELECT IntegerValue
FROM    SampleData
WHERE   IntegerValue <> (SELECT MAX(IntegerValue) FROM SampleData)
ORDER BY IntegerValue DESC
LIMIT 1;

--Solution 3
--Offset and Fetch
SELECT  IntegerValue
FROM    SampleData
ORDER BY IntegerValue DESC
OFFSET 1 ROWS
FETCH NEXT 1 ROWS ONLY;--Solution 4
--Top 1 and Top 2
SELECT IntegerValue
FROM    (
        SELECT *
        FROM    SampleData
        ORDER BY IntegerValue DESC
        ) a
ORDER BY IntegerValue ASC
LIMIT 1
LIMIT 2;--Solution 5
--Min and Top 2
WITH cte_TopMin AS
(
SELECT  MIN(IntegerValue) AS MinIntegerValue
FROM   (
       SELECT *
       FROM    SampleData
       ORDER BY IntegerValue DESC
       ) a
)
SELECT  IntegerValue
FROM    SampleData
WHERE   IntegerValue IN (SELECT MinIntegerValue FROM cte_TopMin)
LIMIT 2;

--Solution 6
--Correlated Sub-Query
SELECT  IntegerValue
FROM    SampleData a
WHERE   2 = (SELECT COUNT(DISTINCT b.IntegerValue)
             FROM SampleData b
             WHERE a.IntegerValue <= b.IntegerValue);--Solution 7
--Top 1 and Lag
WITH cte_LeadLag AS
(
SELECT  *,
        LAG(IntegerValue, 1, NULL) OVER (ORDER BY IntegerValue DESC) AS PreviousValue
FROM    SampleData
)
SELECT IntegerValue
FROM    cte_LeadLag
WHERE   PreviousValue IS NOT NULL
ORDER BY IntegerValue DESC
LIMIT 1;
