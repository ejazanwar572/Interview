-- Puzzle 15 - Group Concatenation
--

-- Write an SQL statement that can group-concatenate the following values.  

/*
| Sequence |     Syntax    |
|----------|---------------|
| 1        | SELECT        |
| 2        | Product,      |
| 3        | UnitPrice,    |
| 4        | EffectiveDate |
| 5        | FROM          |
| 6        | Products      |
| 7        | WHERE         |
| 8        | UnitPrice     |
| 9        | > 100         |
*/

-- Here is the expected output.

/*
| Syntax                                                                       |
|------------------------------------------------------------------------------|
| SELECT Product, UnitPrice, EffectiveDate FROM Products WHERE UnitPrice > 100 |
*/


-- Solution
-- Solution for Puzzle 15: Group Concatenation
SELECT GROUP_CONCAT(Syntax ORDER BY Sequence SEPARATOR ' ')
FROM GroupConcatTable;


-- ==================================================
-- Solution for Puzzle 15
-- ==================================================

DROP TABLE IF EXISTS DMLTable;

CREATE TABLE DMLTable
(
SequenceNumber  INTEGER PRIMARY KEY,
String          VARCHAR(100) NOT NULL
);

INSERT INTO DMLTable (SequenceNumber, String) VALUES
(1,'SELECT'),
(2,'Product,'),
(3,'UnitPrice,'),
(4,'EffectiveDate'),
(5,'FROM'),
(6,'Products'),
(7,'WHERE'),
(8,'UnitPrice'),
(9,'> 100');

--Solution 1
--STRING_AGG
SELECT  GROUP_CONCAT(String ORDER BY SequenceNumber ASC SEPARATOR ' ')
FROM    DMLTable;

--Solution 2
--Recursion
WITH cte_DMLGroupConcat(String2,Depth) AS
(
SELECT  CAST('' AS NVARCHAR(MAX)),
        CAST(MAX(SequenceNumber) AS INTEGER)
FROM    DMLTable
UNION ALL
SELECT  cte_Ordered.String + ' ' + cte_Concat.String2, cte_Concat.Depth-1
FROM    cte_DMLGroupConcat cte_Concat INNER JOIN
        DMLTable cte_Ordered ON cte_Concat.Depth = cte_Ordered.SequenceNumber
)
SELECT  String2
FROM    cte_DMLGroupConcat
WHERE   Depth = 0;

--Solution 3
--XML Path
--There is an error; the ">" gets converted to "&gt;".
SELECT  DISTINCT
        STUFF((
            SELECT  CAST(' ' AS VARCHAR(MAX)) + String
            FROM    DMLTable U
            ORDER BY SequenceNumber
        FOR XML PATH('')), 1, 1, '') AS DML_String
FROM    DMLTable;
