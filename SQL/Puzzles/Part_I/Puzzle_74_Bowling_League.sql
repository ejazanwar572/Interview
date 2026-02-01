-- Puzzle 74 - Bowling League
--

-- Determine which bowlers consistently place next to each other in your local bowling league.

/*
| Game ID | Bowler  | Score |
|---------|---------|-------|
| 1       | John    | 167   |
| 1       | Susan   | 139   |
| 1       | Ralph   | 95    |
| 1       | Mary    | 90    |
| 2       | Susan   | 187   |
| 2       | John    | 155   |
| 2       | Dennis  | 100   |
| 2       | Anthony | 78    |
*/

-- Here is the expected output.

/*
| Bowler1 | Bowler2 | Count |
|---------|---------|-------|
| John    | Susan   | 2     |
| Ralph   | Susan   | 1     |
| Mary    | Ralph   | 1     |
| Dennis  | John    | 1     |
| Anthony | Dennis  | 1     |
*/


-- ==================================================
-- Solution for Puzzle 74
-- ==================================================

DROP TABLE IF EXISTS BowlingResults;

CREATE TABLE BowlingResults 
(
GameID  INTEGER,
Bowler  VARCHAR(50),
Score   INTEGER,
PRIMARY KEY (GameID, Bowler)
);

INSERT INTO BowlingResults (GameID, Bowler, Score) VALUES
(1, 'John', 167),
(1, 'Susan', 139),
(1, 'Ralph', 95),
(1, 'Mary', 90),
(2, 'Susan', 187),
(2, 'John', 155),
(2, 'Dennis', 100),
(2, 'Anthony', 78);

WITH cte_Lead AS
(
SELECT  *,
        LEAD(Bowler,1) OVER (PARTITION BY GameID ORDER BY Score DESC) AS LeadBowler
FROM    BowlingResults
),
cte_Least_Greatest AS
(
SELECT  GameID,
        LEAST(Bowler,LeadBowler) AS Bowler1,
        GREATEST(Bowler,LeadBowler) AS Bowler2
FROM    cte_Lead a
)
SELECT  Bowler1,
        Bowler2,
        COUNT(*) AS [Count]
FROM    cte_Least_Greatest
GROUP BY Bowler1, Bowler2
ORDER BY 3 DESC;
