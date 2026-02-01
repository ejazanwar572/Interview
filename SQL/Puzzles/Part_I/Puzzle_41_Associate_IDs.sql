-- Puzzle 41 - Associate IDs
--

-- The following table shows two hierarchical structures.

-- 1. The first is the association between Anne, Betty, Charles, Dan, and Emma.
-- 2. The second is the association between Francis, George, and Harriet.

-- Write an SQL statement that creates a grouping number for each hierarchical association and displays the member in the associations.

/*
| Associate 1 | Associate 2 |
|-------------|-------------|
| Anne        | Betty       |
| Anne        | Charles     |
| Betty       | Dan         |
| Charles     | Emma        |
| Francis     | George      |
| George      | Harriet     |
*/

-- Here is the expected output.

/*
| Grouping | Associate |
|----------|-----------|
| 1        | Anne      |
| 1        | Betty     |
| 1        | Charles   |
| 1        | Dan       |
| 1        | Emma      |
| 2        | Francis   |
| 2        | George    |
| 2        | Harriet   |
*/


-- ==================================================
-- Solution for Puzzle 41
-- ==================================================

DROP TABLE IF EXISTS Associates;
DROP TABLE IF EXISTS Associates2;
DROP TABLE IF EXISTS Associates3;

CREATE TABLE Associates
(
Associate1  VARCHAR(100),
Associate2  VARCHAR(100),
PRIMARY KEY (Associate1, Associate2)
);

INSERT INTO Associates (Associate1, Associate2) VALUES
('Anne','Betty'),('Anne','Charles'),('Betty','Dan'),('Charles','Emma'),
('Francis','George'),('George','Harriet');

--Step 1
--Recursion
WITH cte_Recursive AS
(
SELECT  Associate1,
        Associate2
FROM    Associates
UNION ALL
SELECT  a.Associate1,
        b.Associate2
FROM    Associates a INNER JOIN
        cte_Recursive b ON a.Associate2 = b.Associate1
)
SELECT  Associate1,
        Associate2
INTO    Associates2
FROM    cte_Recursive
UNION ALL
SELECT  Associate1,
        Associate1
FROM    Associates;

--Step 2
SELECT  MIN(Associate1) AS Associate1,
        Associate2
INTO    Associates3
FROM    Associates2
GROUP BY Associate2;

--Results
SELECT  DENSE_RANK() OVER (ORDER BY Associate1) AS GroupingNumber,
        Associate2 AS Associate
FROM    Associates3;
