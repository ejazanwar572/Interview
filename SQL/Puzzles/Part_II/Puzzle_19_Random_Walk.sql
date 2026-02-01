-- Puzzle 19 - Random Walk
--

-- Perform a random walk best described by the following puzzle:

-- As the host of a weekly dinner gathering with you and seven friends (8 people total), you devise a method to choose next week’s host. After the meal, everyone sits around a circular table. As the current host, you flip a fair coin. If it’s heads, pass the coin to the person on your right; if it’s tails, pass it to your left. Whoever receives the coin repeats the process—flipping and passing right on heads, left on tails.

-- The game continues until exactly one person remains who has not yet received the coin. The last person to be untouched is declared the winner and will host the next dinner party.

-- Because you were the first to flip, you are ineligible to host next week.


-- ==================================================
-- Solution for Puzzle 19
-- ==================================================

/*********************************************************************
Scott Peters
Random Walk
https://advancedsqlpuzzles.com
Last Updated: 02/07/2023
Microsoft SQL Server T-SQL

https://en.wikipedia.org/wiki/Random_walk
**********************************************************************/

---------------------
---------------------
--Tables used in script
DROP TABLE IF EXISTS Numbers;
DROP TABLE IF EXISTS ParticipantsASC;
DROP TABLE IF EXISTS ParticipantsDESC;
DROP TABLE IF EXISTS Participants;
DROP TABLE IF EXISTS CoinFlipResults;
DROP TABLE IF EXISTS WinnerResults;
DROP TABLE IF EXISTS WinnerResultsHistory;

---------------------
---------------------
--Create WinnerResultsHistory table
CREATE TABLE WinnerResultsHistory
(
Iteration INTEGER IDENTITY(1,1) PRIMARY KEY,
Participant INTEGER NOT NULL,
CoinFlips INTEGER NOT NULL
);

------------------------
------------------------
------------------------
--Create Numbers table
CREATE TABLE Numbers
(
Number INTEGER IDENTITY(0,1) PRIMARY KEY, -- Begin at 0 and increase by 1
InsertDate DATETIME NOT NULL
);

INSERT INTO Numbers(InsertDate) VALUES (NOW()); 300

------------------------
------------------------
------------------------
--Create ParticipantsASC table
CREATE TABLE ParticipantsASC
(
CoinFlipSum INTEGER IDENTITY(0,1) PRIMARY KEY, -- Begin at 0 and increase by 1
Participant INTEGER
);

--Create ParticipantsDESC table
CREATE TABLE ParticipantsDESC
(
CoinFlipSum INTEGER IDENTITY(-1,-1) PRIMARY KEY, -- Begin at -1 and increase by -1
Participant INTEGER
);

--Create Participants table
CREATE TABLE Participants
(
CoinFlipSum INTEGER NOT NULL,
Participant INTEGER NOT NULL
);

------------------------
------------------------
------------------------
--Create and populate the Participants table
--For simplicity, I create separate sequences and tables
DROP SEQUENCE IF EXISTS dbo.MySequenceASC;
DROP SEQUENCE IF EXISTS dbo.MySequenceDESC;

--Start with 0, increment by 1
CREATE SEQUENCE dbo.MySequenceASC AS INTEGER
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 7-----------------Set to number of participants!
    CYCLE;

--Start with 7, increment by -1
CREATE SEQUENCE dbo.MySequenceDESC AS INTEGER
    START WITH 7
    INCREMENT BY -1
    MINVALUE 0
    MAXVALUE 7-----------------Set to number of participants!
    CYCLE;

INSERT INTO ParticipantsASC (Participant)
SELECT  (NEXT VALUE FOR dbo.MySequenceASC) AS Participant; 300

INSERT INTO ParticipantsDESC (Participant)
SELECT  (NEXT VALUE FOR dbo.MySequenceDESC) AS Participant; 300

INSERT INTO Participants (CoinFlipSum, Participant)
SELECT CoinFlipSum, Participant FROM ParticipantsASC
UNION ALL
SELECT CoinFlipSum, Participant FROM ParticipantsDESC;

------------------------
------------------------
------------------------
--Perform an evaluation of the Participants and Numbers table
--Ensure you have enough records in the Participants and Numbers tables
IF((SELECT COUNT(*) FROM Participants) < (SELECT COUNT(*) FROM Numbers))
    BEGIN
    PRINT('Participants record count is less than Numbers')
    RETURN;
    END;
------------------------
------------------------
------------------------
--Create table CoinFlipResults
CREATE TABLE CoinFlipResults
(
StepNumber INTEGER PRIMARY KEY,
WindowSum INTEGER
);

------------------------
------------------------
------------------------
--Create table WinnerResults
CREATE TABLE WinnerResults
(
Participant INTEGER PRIMARY KEY,
StepNumberFirstTouched INTEGER
);

------------------------
------------------------
------------------------
--Set the number of iterations
DECLARE @Iterations INTEGER = 1000;

------------------------
------------------------
------------------------
--Perform the random walk
WHILE @Iterations >= 1
BEGIN

    SET @Iterations = @Iterations - 1;

    TRUNCATE TABLE CoinFlipResults;
    TRUNCATE TABLE WinnerResults;
	
	------------------------
    ------------------------
    ------------------------
    --Insert into CoinFlipResults table
    ;WITH cte_RandomNumber AS
    (
    SELECT  Number AS StepNumber
            ,ABS(CHECKSUM(NEWID()) % 2) + 1 AS RandomNumber
    FROM    Numbers
    WHERE   Number > 0
    ),
    cte_Pass AS
    (
    SELECT StepNumber
            ,(CASE RandomNumber WHEN 1 THEN -1 WHEN 2 THEN 1 END) AS PassDetermination
    FROM    cte_RandomNumber
    )
    INSERT INTO CoinFlipResults
    SELECT  StepNumber
            ,SUM(PassDetermination) OVER (ORDER BY StepNumber) AS WindowSum
    FROM cte_Pass
    ORDER BY StepNumber;

    ------------------------
    ------------------------
    ------------------------
    --Insert into WinnerResults table
    WITH cte_ResultsView AS
    (
    SELECT  A.*, '----' AS ID, B.*
    FROM    CoinFlipResults a LEFT OUTER JOIN
            Participants b on a.WindowSum = b.CoinFlipSum
    )
    INSERT INTO WinnerResults
    SELECT  Participant,
            MIN(StepNumber) AS StepNumberFirstTouched
    FROM    cte_ResultsView
    GROUP BY Participant
    ORDER BY 2 DESC;------------------------
    ------------------------
    ------------------------
    --Insert into WinnerResultsHistory table
    INSERT INTO WinnerResultsHistory (Participant, CoinFlips)
    SELECT
            (SELECT Participant FROM WinnerResults WHERE Participant <> 0 ORDER BY StepNumberFirstTouched DESC),
            (SELECT StepNumberFirstTouched
            FROM    WinnerResults 
            WHERE   StepNumberFirstTouched < (SELECT MAX(StepNumberFirstTouched) FROM WinnerResults) 
            ORDER BY StepNumberFirstTouched DESC)
LIMIT 1
LIMIT 1;

END--END LOOP

------------------------
------------------------
------------------------
--Display summary statistics of the results
SELECT  Participant,
        COUNT(*) AS Count,
        MIN(CoinFlips) AS Min,
        MAX(CoinFlips) AS Max,
        AVG(CoinFlips) AS Avg,
        MAX(CoinFlips) - MIN(CoinFlips) AS Range,
        STDEV(CoinFlips) AS StandardDeviation
FROM    WinnerResultsHistory
GROUP BY Participant
UNION
SELECT  99999 AS Participant,
        COUNT(*) AS Count,
        MIN(CoinFlips) AS Min,
        MAX(CoinFlips) AS Max,
        AVG(CoinFlips) AS Avg,
        MAX(CoinFlips) - MIN(CoinFlips) AS Range,
        STDEV(CoinFlips) AS StandardDeviation
FROM    WinnerResultsHistory;
