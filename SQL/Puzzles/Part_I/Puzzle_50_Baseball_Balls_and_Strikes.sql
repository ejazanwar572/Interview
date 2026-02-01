-- Puzzle 50 - Baseball Balls and Strikes
--

-- For this puzzle, you will need to understand the rules of baseball's balls and strike count.

-- Given a table containing the columns `Batter ID`, `Pitch Number`, and `Result` for each pitch. Construct an SQL statement that returns `Start Of Pitch Count` and `End Of Pitch Count`.

-- Here is the expected output.

/*
| Batter ID | Pitch Number | Result | Start Of Pitch Count | End Of Pitch Count |
|-----------|--------------|--------|----------------------|--------------------|
| 1001      | 1            | Foul   | 0 – 0                | 0 – 1              |
| 1001      | 2            | Foul   | 0 – 1                | 0 – 2              |
| 1001      | 3            | Ball   | 0 – 2                | 1 – 2              |
| 1001      | 4            | Ball   | 1 – 2                | 2 – 2              |
| 1001      | 5            | Strike | 2 – 2                | 2 – 3              |
| 2002      | 1            | Ball   | 0 – 0                | 1 – 0              |
| 2002      | 2            | Strike | 1 – 0                | 1 – 1              |
| 2002      | 3            | Foul   | 1 – 1                | 1 – 2              |
| 2002      | 4            | Foul   | 1 – 2                | 1 – 2              |
| 2002      | 5            | Foul   | 1 – 2                | 1 – 2              |
| 2002      | 6            | In Play| 1 – 2                | In-Play            |
| 3003      | 1            | Ball   | 0 – 0                | 1 – 0              |
| 3003      | 2            | Ball   | 1 – 0                | 2 – 0              |
| 3003      | 3            | Ball   | 2 – 0                | 3 – 0              |
| 3003      | 4            | Ball   | 3 – 0                | 4 – 0              |
| 4004      | 1            | Foul   | 0 – 0                | 0 – 1              |
| 4004      | 2            | Foul   | 0 – 1                | 0 – 2              |
| 4004      | 3            | Foul   | 0 – 2                | 0 – 2              |
| 4004      | 4            | Foul   | 0 – 2                | 0 – 2              |
| 4004      | 5            | Foul   | 0 – 2                | 0 – 2              |
| 4004      | 6            | Strike | 0 – 2                | 0 – 3              |
*/


-- ==================================================
-- Solution for Puzzle 50
-- ==================================================

DROP TABLE IF EXISTS Pitches;
DROP TABLE IF EXISTS BallsStrikes;
DROP TABLE IF EXISTS BallsStrikesSumWidow;
DROP TABLE IF EXISTS BallsStrikesLag;

CREATE TABLE Pitches
(
BatterID     INTEGER,
PitchNumber  INTEGER,
Result       VARCHAR(100) NOT NULL,
PRIMARY KEY (BatterID, PitchNumber)
);

INSERT INTO Pitches (BatterID, PitchNumber, Result) VALUES
(1001,1,'Foul'), (1001,2,'Foul'),(1001,3,'Ball'),(1001,4,'Ball'),(1001,5,'Strike'),
(2002,1,'Ball'),(2002,2,'Strike'),(2002,3,'Foul'),(2002,4,'Foul'),(2002,5,'Foul'),
(2002,6,'In Play'),(3003,1,'Ball'),(3003,2,'Ball'),(3003,3,'Ball'),
(3003,4,'Ball'),(4004,1,'Foul'),(4004,2,'Foul'),(4004,3,'Foul'),
(4004,4,'Foul'),(4004,5,'Foul'),(4004,6,'Strike');

SELECT  BatterID,
        PitchNumber,
        Result,
        (CASE WHEN  Result = 'Ball' THEN 1 ELSE 0 END) AS Ball,
        (CASE WHEN  Result IN ('Foul','Strike') THEN 1 ELSE 0 END) AS Strike
INTO    BallsStrikes
FROM    Pitches;

SELECT  BatterID,
        PitchNumber,
        Result,
        SUM(Ball) OVER (PARTITION BY BatterID ORDER BY PitchNumber) AS SumBall,
        SUM(Strike) OVER (PARTITION BY BatterID ORDER BY PitchNumber) AS SumStrike
INTO    BallsStrikesSumWidow
FROM    BallsStrikes;

SELECT  BatterID,
        PitchNumber,
        Result,
        SumBall,
        SumStrike,
        LAG(SumBall,1,0) OVER (PARTITION BY BatterID ORDER BY PitchNumber) AS SumBallLag,
        (CASE   WHEN    Result IN ('Foul','In-Play') AND
                        LAG(SumStrike,1,0) OVER (PARTITION BY BatterID ORDER BY PitchNumber) >= 3 THEN 2
                WHEN    Result = 'Strike' AND SumStrike >= 2 THEN 2
                ELSE    LAG(SumStrike,1,0) OVER (PARTITION BY BatterID ORDER BY PitchNumber)
        END) AS SumStrikeLag
INTO    BallsStrikesLag
FROM    BallsStrikesSumWidow;

SELECT  BatterID,
        PitchNumber,
        Result,
        CONCAT(SumBallLag, ' - ', SumStrikeLag) AS StartOfPitchCount,
        (CASE WHEN Result = 'In Play' THEN Result
                ELSE CONCAT(SumBall, ' - ', (CASE   WHEN Result = 'Foul' AND SumStrike >= 3 THEN 2
                                                    WHEN Result = 'Strike' AND SumStrike >= 2 THEN 3
                                                    ELSE SumStrike END))
        END) AS EndOfPitchCount
FROM    BallsStrikesLag
ORDER BY 1,2;
