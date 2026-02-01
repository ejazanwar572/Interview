-- Puzzle 26 - Previous Year’s Sales
--

-- Write an SQL statement that shows the current year’s sales, along with the previous year’s sales, and the sales from two years ago.

/*
| Year |  Amount  |
|------|----------|
| 2018 | 352,645  |
| 2017 | 165,565  |
| 2017 | 254,654  |
| 2016 | 159,521  |
| 2016 | 251,696  |
| 2016 | 111,894  |
*/

-- Here is the expected output.

/*
|   2018  |  2017   |  2016   |
|---------|---------|---------|
| 352,645 | 420,219 | 411,217 |
*/


-- ==================================================
-- Solution for Puzzle 26
-- ==================================================

DROP TABLE IF EXISTS Sales;

CREATE TABLE Sales
(
[Year]  INTEGER NOT NULL,
Amount  INTEGER NOT NULL
);

INSERT INTO Sales ([Year], Amount) VALUES
(YEAR(NOW()),352645),
(YEAR(DATEADD(YEAR,-1,NOW())),165565),
(YEAR(DATEADD(YEAR,-1,NOW())),254654),
(YEAR(DATEADD(YEAR,-2,NOW())),159521),
(YEAR(DATEADD(YEAR,-2,NOW())),251696),
(YEAR(DATEADD(YEAR,-3,NOW())),111894);

--Solution 1 (This has hardcoded dates)
--/* MySQL_Conversion_Warning: PIVOT not supported. Use CASE/Aggregation. */ PIVOT
SELECT [2023],[2022],[2021] FROM Sales
/* MySQL_Conversion_Warning: PIVOT not supported. Use CASE/Aggregation. */ PIVOT (SUM(Amount) FOR [Year] IN ([2023],[2022],[2021])) AS PivotClause;

--Solution 2 (This has hardcoded dates)
--LAG
WITH cte_AggregateTotal AS
(
SELECT  [Year],
        SUM(Amount) AS Amount
FROM    Sales
GROUP BY [Year]
),
cte_Lag AS
(
SELECT  [Year],
        Amount,
        LAG(Amount,1,0) OVER (ORDER BY Year) AS Lag1,
        LAG(Amount,2,0) OVER (ORDER BY Year) AS Lag2
FROM    cte_AggregateTotal
)
SELECT  Amount AS '2023',
        Lag1 AS '2022',
        Lag2 AS '2021'
FROM    cte_Lag
WHERE   [Year] = 2023;

--Solution 3
--Dynamic SQL without hardcoded dates
BEGIN
    
    DECLARE @CurrentYear VARCHAR(MAX) =
                CAST(YEAR(NOW()) AS VARCHAR);
    DECLARE @CurrentYearLag1 VARCHAR(MAX) =
                CAST(YEAR(DATEADD(YEAR,-1,NOW())) AS VARCHAR);
    DECLARE @CurrentYearLag2 VARCHAR(MAX) =
                CAST(YEAR(DATEADD(YEAR,-2,NOW())) AS VARCHAR);
    DECLARE @DynamicSQL NVARCHAR(MAX);

    SET @DynamicSQL =
    'SELECT [' + @CurrentYear + '],
            [' + @CurrentYearLag1 + '],
            [' + @CurrentYearLag2 + ']
    FROM Sales 
    /* MySQL_Conversion_Warning: PIVOT not supported. Use CASE/Aggregation. */ PIVOT (SUM(AMOUNT) FOR YEAR IN (
            [' + @CurrentYear + '],
            [' + @CurrentYearLag1 + '],
            [' + @CurrentYearLag2 + '])) AS PivotClause;'

    PRINT @DynamicSQL;
    EXECUTE SP_EXECUTESQL @DynamicSQL;

END;
