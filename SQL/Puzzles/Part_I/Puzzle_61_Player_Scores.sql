-- Puzzle 61 - Player Scores
--

-- In this SQL puzzle, your task is to analyze a dataset of players' scores across multiple attempts. For each player, you need to calculate two key differences: the change in score from their first attempt to the current record, and the change from their last attempt to the current record. A record should be flagged as improved if the player's score has increased from their previous attempt or if it's their first attempt. Additionally, determine if a player has shown consistent improvement across all attempts. If so, mark them as overall improved.

/*
| Attempt ID | Player ID | Score |
|------------|-----------|-------|
| 1          | 1001      | 2     |
| 2          | 1001      | 7     |
| 3          | 1001      | 8     |
| 1          | 2002      | 6     |
| 2          | 2002      | 9     |
| 3          | 2002      | 7     |
*/

-- Here is the expected output.

/*
| Attempt ID | Player ID | Score | Difference First | Difference Last | Is Previous Score Lower | Is Overall Improved |
|------------|-----------|-------|------------------|-----------------|-------------------------|---------------------|
| 1          | 1001      | 2     | 0                | -6              | 1                       | 1                   |
| 2          | 1001      | 7     | 5                | -1              | 1                       | 1                   |
| 3          | 1001      | 8     | 6                | 0               | 1                       | 1                   |
| 1          | 2002      | 6     | 0                | -1              | 1                       | 0                   |
| 2          | 2002      | 9     | 3                | 2               | 1                       | 0                   |
| 3          | 2002      | 7     | 1                | 0               | 0                       | 0                   |
*/


-- ==================================================
-- Solution for Puzzle 61
-- ==================================================

DROP TABLE IF EXISTS PlayerScores;

CREATE TABLE PlayerScores
(
AttemptID  INTEGER,
PlayerID   INTEGER,
Score      INTEGER,
PRIMARY KEY (AttemptID, PlayerID)
);

INSERT INTO PlayerScores (AttemptID, PlayerID, Score) VALUES
(1,1001,2),(2,1001,7),(3,1001,8),(1,2002,6),(2,2002,9),(3,2002,7);

WITH cte_FirstLastValues AS
(
SELECT  *
        ,FIRST_VALUE(Score) OVER (PARTITION BY PlayerID ORDER BY AttemptID) AS FirstValue
        ,LAST_VALUE(Score) OVER  (PARTITION BY PlayerID ORDER BY AttemptID
                                  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) LastValue
        ,LAG(Score,1,99999999) OVER (PARTITION BY PlayerID ORDER BY AttemptID) AS LagScore
        ,CASE WHEN Score - LAG(Score,1,0) OVER (PARTITION BY PlayerID ORDER BY AttemptID) > 0 THEN 1 ELSE 0 END AS IsImproved
FROM    PlayerScores
)
SELECT  AttemptID
       ,PlayerID
       ,Score
       ,Score - FirstValue AS Difference_First
       ,Score - LastValue AS Difference_Last
       ,IsImproved AS IsPreviousScoreLower
       ,MIN(IsImproved) OVER (PARTITION BY PlayerID) AS IsOverallImproved
FROM   cte_FirstLastValues;
