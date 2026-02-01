-- Puzzle 19 - Back to the Future
--

-- Here is one of the more difficult puzzles to solve with a declarative SQL statement.

-- Write an SQL statement to merge the overlapping time periods.

/*
| Start Date | End Date  |
|------------|-----------|
| 1/1/2018   | 1/5/2018  |
| 1/3/2018   | 1/9/2018  |
| 1/10/2018  | 1/11/2018 |
| 1/12/2018  | 1/16/2018 |
| 1/15/2018  | 1/19/2018 |
*/

-- Here is the expected output.

/*
| Start Date | End Date  |
|------------|-----------|
| 1/1/2018   | 1/9/2018  |
| 1/10/2018  | 1/11/2018 |
| 1/12/2018  | 1/19/2018 |
*/


-- ==================================================
-- Solution for Puzzle 19
-- ==================================================

DROP TABLE IF EXISTS TimePeriods;
DROP TABLE IF EXISTS Distinct_StartDates;
DROP TABLE IF EXISTS OuterJoin;
DROP TABLE IF EXISTS DetermineValidEndDates;
DROP TABLE IF EXISTS DetermineValidEndDates2;

CREATE TABLE TimePeriods
(
StartDate  DATE,
EndDate    DATE,
PRIMARY KEY (StartDate, EndDate)
);

INSERT INTO TimePeriods (StartDate, EndDate) VALUES
('1/1/2018','1/5/2018'),
('1/3/2018','1/9/2018'),
('1/10/2018','1/11/2018'),
('1/12/2018','1/16/2018'),
('1/15/2018','1/19/2018');

--Step 1
SELECT  DISTINCT
        StartDate
INTO    Distinct_StartDates
FROM    TimePeriods;

--Step 2
SELECT  a.StartDate AS StartDate_A,
        a.EndDate AS EndDate_A,
        b.StartDate AS StartDate_B,
        b.EndDate AS EndDate_B
INTO    OuterJoin
FROM    TimePeriods AS a LEFT OUTER JOIN
        TimePeriods AS b ON a.EndDate >= b.StartDate AND
                                a.EndDate < b.EndDate;

--Step 3
SELECT  EndDate_A
INTO    DetermineValidEndDates
FROM    OuterJoin
WHERE   StartDate_B IS NULL
GROUP BY EndDate_A;

--Step 4
SELECT  a.StartDate, MIN(b.EndDate_A) AS MinEndDate_A
INTO    DetermineValidEndDates2
FROM    Distinct_StartDates a INNER JOIN
        DetermineValidEndDates b ON a.StartDate <= b.EndDate_A
GROUP BY a.StartDate;

--Results
SELECT  MIN(StartDate) AS StartDate,
        MAX(MinEndDate_A) AS EndDate
FROM    DetermineValidEndDates2
GROUP BY MinEndDate_A;
