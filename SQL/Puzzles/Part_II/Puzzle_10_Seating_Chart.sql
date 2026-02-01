-- Puzzle 10 - Seating Chart
--

-- Given the set of integers provided in the following DDL statement, write the SQL statements to determine the following:
-- - Gap start and gap end
-- - Total missing numbers
-- - Count of odd and even numbers

CREATE TABLE SeatingChart
(
SeatNumber INTEGER
);

INSERT INTO SeatingChart VALUES
(7),(13),(14),(15),(27),(28),(29),(30),
(31),(32),(33),(34),(35),(52),(53),(54);

/*
| Gap Start | Gap End |
|-----------|---------|
| 1         | 6       |
| 8         | 12      |
| 16        | 26      |
| 36        | 51      |
*/

/*
| Total Missing Numbers |
|-----------------------|
| 38                    |
*/

/*
|     Type     | Count |
|--------------|-------|
| Even Numbers | 8     |
| Odd Numbers  | 9     |
*/


-- ==================================================
-- Solution for Puzzle 10
-- ==================================================

/*********************************************************************
Scott Peters
Seating Chart
https://advancedsqlpuzzles.com
Last Updated: 01/13/2023
Microsoft SQL Server T-SQL
**********************************************************************/

--------------
--------------
--Tables Used
DROP TABLE IF EXISTS SeatingChart;

--------------
--------------
--Create and populate SeatingChart
CREATE TABLE SeatingChart
(
SeatNumber INTEGER PRIMARY KEY
);

INSERT INTO SeatingChart VALUES
(7),(13),(14),(15),(27),(28),(29),(30),(31),(32),(33),(34),(35),(52),(53),(54);

--------------
--------------
--Place a value of 0 in the SeatingChart table
INSERT INTO SeatingChart VALUES (0);

--------------
--------------
--Gap start and gap end
SELECT  GapStart + 1 AS GapStart,
        GapEnd - 1 AS GapEnd
FROM
    (
    SELECT  SeatNumber AS GapStart,
        LEAD(SeatNumber,1,0) OVER (ORDER BY SeatNumber) AS GapEnd,
        LEAD(SeatNumber,1,0) OVER (ORDER BY SeatNumber) - SeatNumber AS Gap
    FROM SeatingChart
    ) a
WHERE Gap > 1;
        
--Missing Numbers
WITH cte_Rank
AS
(
SELECT  SeatNumber,
        ROW_NUMBER() OVER (ORDER BY SeatNumber) AS RowNumber,
        SeatNumber - ROW_NUMBER() OVER (ORDER BY SeatNumber) AS Rnk
FROM    SeatingChart
WHERE   SeatNumber > 0
)
SELECT MAX(Rnk) AS MissingNumbers FROM cte_Rank;

--Odd and even number count
SELECT  (CASE SeatNumber%2 WHEN 1 THEN 'Odd' WHEN 0 THEN 'Even' END) AS Modulus,
        COUNT(*) AS [Count]
FROM    SeatingChart
GROUP BY (CASE SeatNumber%2 WHEN 1 THEN 'Odd' WHEN 0 THEN 'Even' END);
