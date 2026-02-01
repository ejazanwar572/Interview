-- Puzzle 16 - Reciprocals
--

-- You work for a software company that released a 2-player game, and you need to tally the scores.  

-- Given the following table, write an SQL statement to determine the reciprocals and calculate their aggregate score.  

-- In the data below, players `3003` and `4004` have two valid entries, but their scores need to be aggregated together.  

/*
| Player A | Player B | Score |
|----------|----------|-------|
| 1001     | 2002     | 150   |
| 3003     | 4004     | 15    |
| 4004     | 3003     | 125   |
*/

-- Here is the expected output.

/*
| Player A | Player B | Score |
|----------|----------|-------|
| 1001     | 2002     | 150   |
| 3003     | 4004     | 140   |
*/


-- ==================================================
-- Solution for Puzzle 16
-- ==================================================

DROP TABLE IF EXISTS PlayerScores;

CREATE TABLE PlayerScores
(
PlayerA  INTEGER,
PlayerB  INTEGER,
Score    INTEGER NOT NULL,
PRIMARY KEY (PlayerA, PlayerB)
);

INSERT INTO PlayerScores (PlayerA, PlayerB, Score) VALUES
(1001,2002,150),(3003,4004,15),(4004,3003,125);

SELECT  PlayerA,
        PlayerB,
        SUM(Score) AS Score
FROM    (
        SELECT
                (CASE WHEN PlayerA <= PlayerB THEN PlayerA ELSE PlayerB END) PlayerA,
                (CASE WHEN PlayerA <= PlayerB THEN PlayerB ELSE PlayerA END) PlayerB,
                Score
        FROM    PlayerScores
        ) a
GROUP BY PlayerA, PlayerB;
