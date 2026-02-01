-- Puzzle 23 - Divide in Half
--

-- You work for a gaming company and need to rank players by their score into two categories.

-- Players that rank in the top half must be given a value of `1`, and the remaining players must be given a value of `2`.

-- Write an SQL statement that meets these requirements.

/*
| Player ID | Score |
|-----------|-------|
| 1001      | 2343  |
| 2002      | 9432  |
| 3003      | 6548  |
| 4004      | 1054  |
| 5005      | 6832  |
*/

-- Here is the expected output.

/*
| Quartile | Player ID | Score |
|----------|-----------|-------|
| 1        | 2002      | 9432  |
| 1        | 3003      | 6548  |
| 1        | 5005      | 6832  |
| 2        | 1001      | 2343  |
| 2        | 4004      | 1054  |
*/


-- ==================================================
-- Solution for Puzzle 23
-- ==================================================

DROP TABLE IF EXISTS PlayerScores;

CREATE TABLE PlayerScores
(
PlayerID  INTEGER PRIMARY KEY,
Score     INTEGER NOT NULL
);

INSERT INTO PlayerScores (PlayerID, Score) VALUES
(1001,2343),(2002,9432),
(3003,6548),(4004,1054),
(5005,6832);

SELECT  NTILE(2) OVER (ORDER BY Score DESC) AS Quartile,
        PlayerID,
        Score
FROM    PlayerScores a
ORDER BY Score DESC;
