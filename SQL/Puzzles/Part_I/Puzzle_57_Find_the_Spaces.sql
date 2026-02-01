-- Puzzle 57 - Find the Spaces
--

-- Given the following table containing SQL statements, write an SQL statement that displays the following summary.

/*
|           Statement           |
|-------------------------------|
| SELECT EmpID FROM Employees;  |
| SELECT `*` FROM Transactions; |
*/

-- Here is the expected output.

/*
| Row Number | Quote ID |              String           | Starts | Ends |     Word      |
|------------|----------|-------------------------------|--------|------|---------------|
| 1          | 1        | SELECT EmpID FROM Employees;  | 1      | 6    | SELECT        |
| 2          | 1        | SELECT EmpID FROM Employees;  | 8      | 12   | EmpID         |
| 3          | 1        | SELECT EmpID FROM Employees;  | 14     | 17   | FROM          |
| 4          | 1        | SELECT EmpID FROM Employees;  | 19     | 28   | Employees;    |
| 1          | 2        | SELECT `*` FROM Transactions; | 1      | 6    | SELECT        |
| 2          | 2        | SELECT `*` FROM Transactions; | 8      | 8    | `*`           |
| 3          | 2        | SELECT `*` FROM Transactions; | 10     | 13   | FROM          |
| 4          | 2        | SELECT `*` FROM Transactions; | 15     | 27   | Transactions; |
*/


-- ==================================================
-- Solution for Puzzle 57
-- ==================================================

DROP TABLE IF EXISTS Strings;

CREATE TABLE Strings
(
QuoteId  INTEGER IDENTITY(1,1) PRIMARY KEY,
String   VARCHAR(100) NOT NULL
);

INSERT INTO Strings (String) VALUES
('SELECT EmpID FROM Employees;'),('SELECT * FROM Transactions;');

WITH cte_StringSplit AS
(
SELECT b.Ordinal AS RowNumber,
       a.QuoteId,
       a.String,
       b.[Value] AS Word,
       LENGTH(b.[Value]) AS WordLength
FROM   Strings a CROSS JOIN LATERAL
       STRING_SPLIT(String,' ', 1) b
)
SELECT RowNumber,
       QuoteID,
       String,
       INSTR(String, Word) AS Starts,
       (INSTR(String, Word) + WordLength) - 1 AS Ends,
       Word
FROM cte_StringSplit;
