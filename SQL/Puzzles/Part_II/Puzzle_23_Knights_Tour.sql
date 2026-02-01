-- Puzzle 23 - Knight's Tour
--

-- This type of problem is often referred to as the [Knight’s Tour](https://en.wikipedia.org/wiki/Knight%27s_tour).

-- Write an SQL query to identify all possible next moves for a Knight piece from its current position on an 8×8 chessboard.  
-- Account for the Knight’s L-shaped movement pattern: two squares along one axis and one square along the perpendicular axis.  
-- Assume the chessboard is numerically indexed 1 to 8 on both axes.

-- For example, if you placed a Knight into square 4D, the output of the SQL statement would be 5B, 3B, 
-- 6C, 2C, 6E, 2E, 5F, and 3F.


-- ==================================================
-- Solution for Puzzle 23
-- ==================================================

/*********************************************************************
Scott Peters
Knight's Tour
https://advancedsqlpuzzles.com
Last Updated: 02/10/2024
Microsoft SQL Server T-SQL

https://en.wikipedia.org/wiki/Knight%27s_tour
**********************************************************************/

DECLARE @CurrentPosition VARCHAR(2);
SET @CurrentPosition = '4D'; -- Example starting position

-- Mapping Letters to Numbers for calculation 
WITH cte_ChessBoard AS
(
SELECT v.Letter, v.Num
FROM (VALUES
    ('A', 1),
    ('B', 2),
    ('C', 3),
    ('D', 4),
    ('E', 5),
    ('F', 6),
    ('G', 7),
    ('H', 8)
) AS v(Letter, Num)
),
cte_CurrentPosition AS
(
SELECT  CAST(SUBSTRING(@CurrentPosition, 1, 1) AS INTEGER) AS CurrentNumber,
        Num AS CurrentLetter 
FROM    cte_ChessBoard a
WHERE   Letter = SUBSTRING(@CurrentPosition, 2, 1)
),
cte_PossibleMoves AS
(
SELECT  CurrentNumber + i.NumberOffset AS NewNumber,
        CurrentLetter + i.LetterOffset AS NewLetter
FROM    cte_CurrentPosition,
        (VALUES (2, 1), (2, -1), (-2, 1), (-2, -1), (1, 2), (1, -2), 
                (-1, 2), (-1, -2)) AS i(NumberOffset, LetterOffset)
WHERE   CurrentNumber + i.NumberOffset BETWEEN 1 AND 8 AND
        CurrentLetter + i.LetterOffset BETWEEN 1 AND 8
)
SELECT  CAST(NewNumber AS VARCHAR(1)) + b.Letter AS NewPosition 
FROM    cte_PossibleMoves a INNER JOIN 
        cte_Chessboard b ON a.NewLetter = b.Num;
