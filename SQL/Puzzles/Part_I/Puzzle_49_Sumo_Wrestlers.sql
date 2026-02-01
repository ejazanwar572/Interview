-- Puzzle 49 - Sumo Wrestlers
--

-- A group of Sumo wrestlers are forming a line to board an elevator. Unfortunately, the elevator can only hold 2,000 pounds, and not all Sumo wrestlers can board. Which Sumo wrestler would be the last to enter, given the following queue order?

/*
| Line Order |  Name  | Weight |
|------------|--------|--------|
| 1          | Haruto | 611    |
| 2          | Minato | 533    |
| 3          | Haruki | 623    |
| 4          | Sota   | 569    |
| 5          | Aoto   | 610    |
| 6          | Hinata | 525    |
*/

-- Here is the expected output.

/*
|  Name  |
|--------|
| Haruki |
*/


-- ==================================================
-- Solution for Puzzle 49
-- ==================================================

DROP TABLE IF EXISTS ElevatorOrder;

CREATE TABLE ElevatorOrder
(
LineOrder  INTEGER PRIMARY KEY,
[Name]     VARCHAR(100) NOT NULL,
[Weight]   INTEGER NOT NULL
);

INSERT INTO ElevatorOrder ([Name], [Weight], LineOrder)
VALUES
('Haruto',611,1),('Minato',533,2),('Haruki',623,3),
('Sota',569,4),('Aoto',610,5),('Hinata',525,6);WITH cte_Running_Total AS
(
SELECT  [Name], [Weight], LineOrder,
        SUM(Weight) OVER (ORDER BY LineOrder) AS Running_Total
FROM    ElevatorOrder
)
SELECT [Name], [Weight], LineOrder, Running_Total
FROM    cte_Running_Total
WHERE   Running_Total <= 2000
ORDER BY Running_Total DESC
LIMIT 1;
