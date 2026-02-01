-- Puzzle 77 - Temperature Readings
--

-- You have been given a table of temperature readings, but some readings are missing. Please fill in the missing values with the larger of either the known previous value or the known following value.

/*
| Temperature ID | Temperature Value |
|----------------|-------------------|
| 1              | 52                |
| 2              |                   |
| 3              |                   |
| 4              | 65                |
| 5              |                   |
| 6              | 72                |
| 7              |                   |
| 8              | 70                |
| 9              |                   |
| 10             | 75                |
| 11             |                   |
| 12             | 80                |
*/

-- Here is the expected output.

/*
| Temperature ID | Temperature Value |
|----------------|-------------------|
| 1              | 52                |
| 2              | 65                |
| 3              | 65                |
| 4              | 65                |
| 5              | 72                |
| 6              | 72                |
| 7              | 72                |
| 8              | 70                |
| 9              | 75                |
| 10             | 75                |
| 11             | 80                |
| 12             | 80                |
*/


-- ==================================================
-- Solution for Puzzle 77
-- ==================================================

DROP TABLE IF EXISTS TemperatureData;

CREATE TABLE TemperatureData
(
TempID     INTEGER PRIMARY KEY,
TempValue  INTEGER NULL
);

INSERT INTO TemperatureData (TempID, TempValue) VALUES
(1,52),(2,NULL),(3,NULL),(4,65),(5,NULL),(6,72),
(7,NULL),(8,70),(9,NULL),(10,75),(11,NULL),(12,80);

WITH cte_Lag AS
(
SELECT  *,
        LAG(TempValue) IGNORE NULLS OVER (ORDER BY TempID) AS LagIgnoreNulls
FROM    TemperatureData
),
cte_Lead AS
(
SELECT  *,
        LEAD(TempValue) IGNORE NULLS OVER (ORDER BY TempID) AS LeadIgnoreNulls
FROM    TemperatureData
)
SELECT  a.TempID,
        COALESCE(a.TempValue, GREATEST(a.LagIgnoreNulls, b.LeadIgnoreNulls)) AS TempValue
FROM    cte_Lag a INNER JOIN
        cte_Lead b ON a.TempID = b.TempID
ORDER BY 1;

/*----------------------------------------------------
The End
*/----------------------------------------------------
