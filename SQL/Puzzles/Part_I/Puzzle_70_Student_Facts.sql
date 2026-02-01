-- Puzzle 70 - Student Facts
--

-- You have access to a database containing student enrollment information for a school. Your goal is to create the summary statistics provided below.

/*
| Parent ID | Child ID | Age | Gender |
|-----------|----------|-----|--------|
| 1001      | A        | 8   | M      |
| 1001      | B        | 12  | F      |
| 2002      | C        | 7   | F      |
| 2002      | D        | 9   | F      |
| 2002      | E        | 14  | M      |
| 3003      | F        | 12  | F      |
| 3003      | G        | 14  | M      |
| 4004      | H        | 7   | M      |
*/

-- Here is the expected output.

/*
| Parent ID | Number Children | Average Age | Age Difference | Largest Age Gap | Youngest Age | Oldest Age | Genders |
|-----------|-----------------|-------------|----------------|-----------------|--------------|------------|---------|
| 1001      | 2               | 10          | 4              | 4               | 8            | 12         | M, F    |
| 2002      | 3               | 10          | 7              | 5               | 7            | 14         | F, F, M |
| 3003      | 2               | 13          | 2              | 2               | 12           | 14         | F, M    |
| 4004      | 1               | 7           | 0              | 0               | 7            | 7          | M       |
*/


-- ==================================================
-- Solution for Puzzle 70
-- ==================================================

DROP TABLE IF EXISTS Students;

CREATE TABLE Students
(
ParentID  INTEGER NOT NULL,
ChildID   CHAR(1) PRIMARY KEY,
Age       INTEGER NOT NULL,
Gender    CHAR(1) NOT NULL
);

INSERT INTO Students (ParentID, ChildID, Age, Gender)
VALUES 
    (1001, 'A', 8, 'M'),
    (1001, 'B', 12, 'F'),
    (2002, 'C', 7, 'F'),
    (2002, 'D', 9, 'F'),
    (2002, 'E', 14, 'M'),
    (3003, 'F', 12, 'F'),
    (3003, 'G', 14, 'M'),
    (4004, 'H', 7, 'M');

WITH cte_LagAgeGap AS
(
SELECT  --ROW_NUMBER() OVER (PARTITION BY ParentID ORDER BY Age) AS RowNumber,
        ParentID,
        AGE - LAG(AGE,1) OVER (PARTITION BY ParentID ORDER BY AGE) AS AgeDifference
FROM    Students
GROUP BY ParentID, Age
),
cte_MaxAgeGap AS
(
SELECT  ParentID,
        MAX(AgeDifference) AS MaxAgeDifference
FROM    cte_LagAgeGap
GROUP BY ParentID
HAVING COUNT(*) >= 2
)
SELECT  a.ParentID,
        COUNT(*) AS NumberChildren,
        AVG(CAST(a.Age AS FLOAT)) AS AverageAge,
        CASE WHEN COUNT(*) = 1 THEN NULL ELSE MAX(a.Age) - MIN(Age) END AS AgeDifference,
        b.MaxAgeDifference,
        MIN(a.Age) AS YoungestAge,
        MAX(a.Age) AS OldestAge,
        GROUP_CONCAT(a.Gender SEPARATOR ', ') AS Genders
FROM    Students a LEFT OUTER JOIN
        cte_MaxAgeGap b ON a.ParentID = b.ParentID
GROUP BY a.ParentID, b.MaxAgeDifference
ORDER BY 1;
