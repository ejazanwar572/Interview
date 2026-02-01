-- Puzzle 15 - High-Low Card Game
--

-- Write a program that shuffles a standard deck of cards and plays a game of High-Low.  

-- The game is played by receiving an initial card and then determining if the next card will be of higher or lower value based on probability.  
-- Make a random decision of higher or lower where necessary.  


-- Solution
-- Solution for Puzzle 15: Group Concatenation
SELECT GROUP_CONCAT(Syntax ORDER BY Sequence SEPARATOR ' ')
FROM GroupConcatTable;


-- ==================================================
-- Solution for Puzzle 15
-- ==================================================

/*********************************************************************
Scott Peters
High-Low Card Game
https://advancedsqlpuzzles.com
Last Updated: 01/13/2023
Microsoft SQL Server T-SQL
**********************************************************************/

-------------------------------
-------------------------------
--Tables used
DROP SEQUENCE IF EXISTS dbo.CardDeckSequence; --Sequence
DROP TABLE IF EXISTS Numbers;
DROP TABLE IF EXISTS CardShuffle;
DROP TABLE IF EXISTS CardShuffle2;
DROP TABLE IF EXISTS CardShuffle3;
DROP TABLE IF EXISTS CardShuffle4;
DROP TABLE IF EXISTS CardShuffle5;
DROP TABLE IF EXISTS CardShuffleResults;
-------------------------------
-------------------------------
--Create and populate a Numbers table
WITH cte_Number (Number)
AS (
    SELECT 1 AS Number
    UNION ALL
    SELECT  Number + 1
    FROM   cte_Number
    WHERE  Number < 52 --52 cards in deck
    )
SELECT Number,
       (CASE Number WHEN 1 THEN 1 ELSE NULL END) AS Calculation
INTO   Numbers
FROM   cte_Number;
-------------------------------
-------------------------------
--Create sequence table
CREATE SEQUENCE dbo.CardDeckSequence AS TINYINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 13
    CYCLE;
-------------------------------
-------------------------------
--Create table CardShuffle
CREATE TABLE CardShuffle
(
RandomNumber UNIQUEIDENTIFIER DEFAULT NEWID(),
CardNumber   TINYINT
);
-------------------------------
-------------------------------
--Create table CardShuffleResults
CREATE TABLE CardShuffleResults
(
Iteration INTEGER IDENTITY(1,1) PRIMARY KEY,
Result    INTEGER NOT NULL
);
-------------------------------
-------------------------------
--Declare and set the variables
DECLARE @vIterations INTEGER = 1000;

-------------------------------
-------------------------------
--Begin WHILE loop
WHILE (SELECT COUNT(*) FROM CardShuffleResults) <= @vIterations --Number of simulations to run
    BEGIN

    TRUNCATE TABLE CardShuffle;
    DROP TABLE IF EXISTS CardShuffle2;
    DROP TABLE IF EXISTS CardShuffle3;
    DROP TABLE IF EXISTS CardShuffle4;
    DROP TABLE IF EXISTS CardShuffle5;

    INSERT INTO CardShuffle (CardNumber)
    SELECT  (NEXT VALUE FOR dbo.CardDeckSequence)
    FROM    Numbers;

    SELECT  ROW_NUMBER() OVER (ORDER BY RandomNumber) AS StepNumber,
            *
    INTO    CardShuffle2
    FROM    CardShuffle
    ORDER BY 1;

    SELECT  DISTINCT
            a.StepNumber,
            a.CardNumber,
            SUM(CASE WHEN a.CardNumber > b.CardNumber THEN 1 ELSE 0 END) AS LowerCardCount,
            SUM(CASE WHEN a.CardNumber < b.CardNumber THEN 1 ELSE 0 END) AS HigherCardCount,
            SUM(CASE WHEN a.CardNumber = b.CardNumber THEN 1 ELSE 0 END) AS SameCardCount
    INTO    CardShuffle3
    FROM    CardShuffle2 a LEFT OUTER JOIN
            CardShuffle2 b on a.StepNumber < b.StepNumber
    GROUP BY a.StepNumber,
            a.CardNumber
    ORDER BY 1;

    SELECT  StepNumber,
            CardNumber,
            HigherCardCount,
            LowerCardCount,
            SameCardCount,
            LEAD(CardNumber,1) OVER (ORDER BY StepNumber) AS NextCardNumber,
            (CASE   WHEN HigherCardCount > LowerCardCount THEN 'Higher'
                    WHEN LowerCardCount > HigherCardCount THEN 'Lower'
                    WHEN LowerCardCount = HigherCardCount THEN IIF(ABS(CHECKSUM(NEWID()) % 2) + 1 = 1,'Higher','Lower') END) AS Prediction,
            (CASE   WHEN CardNumber < LEAD(CardNumber,1) OVER (ORDER BY StepNumber) THEN 'Higher'
                    WHEN CardNumber > LEAD(CardNumber,1) OVER (ORDER BY StepNumber) THEN 'Lower'
                    WHEN CardNumber = LEAD(CardNumber,1) OVER (ORDER BY StepNumber) THEN 'Same'
                    END) AS Outcome
    INTO    CardShuffle4
    FROM    CardShuffle3;
    
    SELECT  *,
            (CASE WHEN Prediction = Outcome THEN 1 ELSE 0 END) AS Result
    INTO    CardShuffle5
    FROM    CardShuffle4;

    INSERT INTO CardShuffleResults (Result)
    SELECT  SUM(Result)
    FROM    CardShuffle5;

    END--End Loop
-------------------------------
-------------------------------
--Display the results
SELECT * FROM CardShuffleResults ORDER BY 2 DESC;
