-- Puzzle 18 - Seating Chart
--

-- Given the set of integers provided in the following DDL statement, write the SQL statements to determine the following:
-- - Gap start and end
-- - Total missing numbers
-- - Count of odd and even numbers

CREATE TABLE SeatingChart (SeatNumber INTEGER);

INSERT INTO SeatingChart VALUES
(7),(13),(14),(15),(27),(28),(29),(30),
(31),(32),(33),(34),(35),(52),(53),(54);

-- Here is the expected output.

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
|----------------------|
| 38                   |
*/

/*
| Type         | Count |
|--------------|-------|
| Even Numbers | 7     |
| Odd Numbers  | 9     |
*/


-- ==================================================
-- Solution for Puzzle 18
-- ==================================================

DROP TABLE IF EXISTS SeatingChart;

CREATE TABLE SeatingChart
(
SeatNumber  INTEGER PRIMARY KEY
);

INSERT INTO SeatingChart (SeatNumber) VALUES
(7),(13),(14),(15),(27),(28),(29),(30),(31),(32),(33),(34),(35),(52),(53),(54);

--Place a value of 0 in the SeatingChart table
INSERT INTO SeatingChart (SeatNumber) VALUES (0);

-------------------
--Gap start and gap end
WITH cte_Gaps AS 
(
SELECT  SeatNumber AS GapStart,
        LEAD(SeatNumber,1,0) OVER (ORDER BY SeatNumber) AS GapEnd,
        LEAD(SeatNumber,1,0) OVER (ORDER BY SeatNumber) - SeatNumber AS Gap
FROM    SeatingChart
)
SELECT  GapStart + 1 AS GapStart,
        GapEnd - 1 AS GapEnd
FROM    cte_Gaps
WHERE Gap > 1;

-------------------
--Sequence start and sequence End
WITH cte_Sequences AS 
(
SELECT  SeatNumber,
        SeatNumber - ROW_NUMBER() OVER (ORDER BY SeatNumber) AS GroupID
FROM    SeatingChart
)
SELECT  MIN(SeatNumber) AS SequenceStart,
        MAX(SeatNumber) AS SequenceEnd
FROM    cte_Sequences
GROUP BY GroupID
ORDER BY SequenceStart;

-------------------
--Missing Numbers
--Solution 1
--This solution provides a method if you need to window/partition the records
WITH cte_Rank
AS
(
SELECT  SeatNumber,
        ROW_NUMBER() OVER (ORDER BY SeatNumber) AS RowNumber,
        SeatNumber - ROW_NUMBER() OVER (ORDER BY SeatNumber) AS Rnk
FROM    SeatingChart
WHERE   SeatNumber > 0
)
SELECT  MAX(Rnk) AS MissingNumbers 
FROM    cte_Rank;

--Solution 2
SELECT  MAX(SeatNumber) - COUNT(SeatNumber) AS MissingNumbers
FROM    SeatingChart
WHERE   SeatNumber <> 0;

-------------------
--Odd and even number count
WITH cte_Seats AS
(
SELECT  *
FROM    SeatingChart
WHERE   SeatNumber > 0
)
SELECT  (CASE SeatNumber%2 WHEN 1 THEN 'Odd' WHEN 0 THEN 'Even' END) AS Modulus,
        COUNT(*) AS [Count]
FROM    cte_Seats
GROUP BY (CASE SeatNumber%2 WHEN 1 THEN 'Odd' WHEN 0 THEN 'Even' END);
