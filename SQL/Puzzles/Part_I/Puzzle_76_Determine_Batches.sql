-- Puzzle 76 - Determine Batches
--

-- You are tasked with providing the details of each batch from two tables: one detailing the start of each batch, and another chronicling the lines of SQL code, including the `GO` statements that separate batch ends. Write an SQL statement to create the expected output.

-- **Batch Starts**
/*
| Batch | Batch Start |
|-------|-------------|
| A     | 1           |
| A     | 5           |
*/

-- **Code Lines**
/*
| Batch | Line |          Syntax          |
|-------|------|--------------------------|
| A     | 1    | SELECT `*`               |
| A     | 2    | FROM Account;            |
| A     | 3    | GO                       |
| A     | 4    | &nbsp;                   |
| A     | 5    | TRUNCATE TABLE Accounts; |
| A     | 6    | GO                       |
*/

-- Here is the expected output.

/*
| Batch | Batch Start | Batch End |
|-------|-------------|-----------|
| A     | 1           | 3         |
| A     | 5           | 6         |
*/


-- ==================================================
-- Solution for Puzzle 76
-- ==================================================

DROP TABLE IF EXISTS BatchStarts;
DROP TABLE IF EXISTS BatchLines;

CREATE TABLE BatchStarts
(
Batch       CHAR(1),
BatchStart  INTEGER,
PRIMARY KEY (Batch, BatchStart)
);

CREATE TABLE BatchLines
(
Batch   CHAR(1),
Line    INTEGER,
Syntax  VARCHAR(MAX),
PRIMARY KEY (Batch, Line)
);

INSERT INTO BatchStarts (Batch, BatchStart) VALUES
('A', 1),
('A', 5);

INSERT INTO BatchLines (Batch, Line, Syntax) VALUES
('A', 1, 'SELECT *'),
('A', 2, 'FROM Account;'),
('A', 3, 'GO'),
('A', 4, ''),
('A', 5, 'TRUNCATE TABLE Accounts;'),
('A', 6, 'GO');

--Solution 1
--CTE with MIN
WITH cte_BatchLines_Go AS
(
SELECT  *
FROM    BatchLines
WHERE   Syntax = 'GO'
)
SELECT  a.Batch, a.BatchStart, MIN(b.Line) AS MinLine
FROM    BatchStarts a LEFT JOIN
        cte_BatchLines_Go b ON b.Line >= a.BatchStart AND a.Batch = b.Batch
GROUP BY a.Batch, a.BatchStart;

--Solution 2
--Correlated Subquery
SELECT  a.*,
        b.MinLine
FROM    BatchStarts a CROSS JOIN LATERAL
        (SELECT  MIN(Line) AS MinLine
         FROM    BatchLines b
         WHERE   b.Line >= a.BatchStart AND Syntax = 'GO' AND a.Batch = b.Batch) b;
