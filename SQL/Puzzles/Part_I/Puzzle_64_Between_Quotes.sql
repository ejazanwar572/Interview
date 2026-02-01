-- Puzzle 64 - Between Quotes
--

-- Given the following table of strings that have embedded quotes, return the result based on the following:

-- 1. If the string has more than two quotes or has zero quotes, return `Error`.
-- 2. If the string has two quotes and more than 10 characters between the quotes, return `True`.
-- 3. If the string has two quotes and fewer than or equal to 10 characters between the quotes, return `False`.

/*
| ID |      String       | Result |
|----|-------------------|--------|
| 1  | "12345678901234"  | True   |
| 2  | 1"12345678901234" | True   |
| 3  | 123"45678"901234" | Error  |
| 4  | 123"45678901234"  | True   |
| 5  | 12345678901"234"  | False  |
| 6  | 12345678901234    | Error  |
*/

-- Here is the expected output.

/*
| ID |      String       | Result |
|-----|------------------|--------|
| 1  | "12345678901234"  | True   |
| 2  | 1"12345678901234" | True   |
| 3  | 123"45678"901234" | Error  |
| 4  | 123"45678901234"  | True   |
| 5  | 12345678901"234"  | False  |
| 6  | 12345678901234    | Error  |
*/


-- ==================================================
-- Solution for Puzzle 64
-- ==================================================

DROP TABLE IF EXISTS Strings;

CREATE TABLE Strings
(
ID      INTEGER IDENTITY(1,1) PRIMARY KEY,
String  VARCHAR(256) NOT NULL
);

INSERT INTO Strings (String) VALUES
('"12345678901234"'),
('1"2345678901234"'),
('123"45678"901234"'),
('123"45678901234"'),
('12345678901"234"'),
('12345678901234');

--Note that STRING_SPLIT does not guarantee order.  Use enable_oridinal if you need to order the output.
--The enable_ordinal argument and ordinal output column are currently supported in Azure SQL Database, Azure SQL Managed Instance, 
--and Azure Synapse Analytics (serverless SQL pool only). Beginning with SQL Server 2022 (16.x), the argument and output column are available in SQL Server.
WITH cte_Strings AS
(
SELECT  ID,
        String,
        (CASE WHEN LENGTH(String) - LENGTH(REPLACE(String,'"','')) <> 2 THEN 'Error' END) AS Result
FROM    Strings
),
cte_StringSplit AS
(
SELECT  ROW_NUMBER() OVER (PARTITION BY String ORDER BY NOW()) AS RowNumber,
        *
FROM    cte_Strings CROSS JOIN LATERAL
        STRING_SPLIT(String,'"')
)
SELECT  ID,
        String,
        (CASE WHEN LENGTH(Value) > 10 THEN 'True' ELSE 'False' END) AS Result
FROM    cte_StringSplit
WHERE   Result IS NULL AND 
        RowNumber = 2
UNION
SELECT  ID,
        String,
        Result
FROM    cte_Strings
WHERE  Result = 'Error'
ORDER BY 1;
