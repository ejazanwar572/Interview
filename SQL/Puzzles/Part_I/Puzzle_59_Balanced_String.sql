-- Puzzle 59 - Balanced String
--

-- Given a string containing parentheses, brackets, and braces, determine if the string is a balanced string.

-- A balanced string must have an opening symbol, a corresponding closing symbol, and the symbols must appear in the correct order.

-- For example, the string "([])" is balanced because the opening square bracket is followed by the closing square bracket, and the opening parenthesis is followed by the closing parenthesis, and they are in the correct order. However, the string "([)]" is not balanced because the closing parenthesis appears before the closing square bracket.

-- Can you discover an efficient algorithm for determining whether a given string is balanced or not?

/*
| ID |  String  |
|----|----------|
| 1  | ()       |
| 2  | []       |
| 3  | {}       |
| 4  | ((({}))) |
| 5  | ()[]     |
| 6  | ({})     |
| 7  | ({)      |
| 8  | ((())))  |
| 9  | }()[][   |
*/

-- Here is the expected output.

/*
| ID |  String  |   Outcome  |
|----|----------|------------|
| 1  | ()       | Balanced   |
| 2  | []       | Balanced   |
| 3  | {}       | Balanced   |
| 4  | ((({}))) | Balanced   |
| 5  | ()[]     | Balanced   |
| 6  | ({})     | Balanced   |
| 7  | ({)      | Unbalanced |
| 8  | ((())))  | Unbalanced |
| 9  | }()[][   | Unbalanced |
*/


-- ==================================================
-- Solution for Puzzle 59
-- ==================================================

DROP TABLE IF EXISTS BalancedString;

CREATE TABLE BalancedString
(
RowNumber        INTEGER IDENTITY(1,1) PRIMARY KEY,
ExpectedOutcome  VARCHAR(50),
MatchString      VARCHAR(50),
UpdateString     VARCHAR(50)
);

INSERT INTO BalancedString (ExpectedOutcome, MatchString) VALUES
('Balanced','( )'),
('Balanced','[]'),
('Balanced','{}'),
('Balanced','( ( { [] } ) )'),
('Balanced','( ) [ ]'),
('Balanced','( { } )'),
('Unbalanced','( { ) }'),
('Unbalanced','( { ) }}}()'),
('Unbalanced','}{()][');

--Remove any spaces
--Populates the column UpdateString that we will manipulate with the below UPDATE statements
UPDATE BalancedString
SET MatchString = REPLACE(MatchString,' ',''),
    UpdateString = REPLACE(MatchString,' ','');

--Set a Loop Counter
DECLARE @vLoop INTEGER = 1;
WHILE @vLoop <> 0

    --Update the UpdateString column to remove any matching objects
    BEGIN
    ------------------
    UPDATE  BalancedString
    SET UpdateString = REPLACE(UpdateString,'()','');
    ------------------
    UPDATE  BalancedString
    SET UpdateString = REPLACE(UpdateString,'[]','');
    -------------------
    UPDATE  BalancedString
    SET UpdateString = REPLACE(UpdateString,'{}','');
    -------------------

    --Determine if there are any more matching objects to update
    WITH cte_Charindex AS
    (
    SELECT INSTR(UpdateString, '()') AS LoopDetermine FROM BalancedString
    UNION
    SELECT INSTR(UpdateString, '[]') AS LoopDetermine FROM BalancedString
    UNION
    SELECT INSTR(UpdateString, '{}') AS LoopDetermine FROM BalancedString
    )
    SELECT @vLoop = MAX(LoopDetermine) FROM cte_Charindex;
    -------------------

    END;

--If the UpdateString column is empty, then it is a balanced string 
SELECT  *, CASE WHEN UpdateString = '' THEN 'Balanced' ELSE 'Unbalanced' END AS FinalResult 
FROM    BalancedString;
