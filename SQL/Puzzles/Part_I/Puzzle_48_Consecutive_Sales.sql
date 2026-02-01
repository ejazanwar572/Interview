-- Puzzle 48 - Consecutive Sales
--

-- Write an SQL statement to determine the `Sales IDs` that have a record in the current year, plus the previous two consecutive years.

-- You will need to adjust the test data for the current year, as it is coded for the year 2021.

/*
| Sales ID | Year |
|----------|------|
| 1001     | 2018 |
| 1001     | 2019 |
| 1001     | 2020 |
| 2002     | 2020 |
| 2002     | 2021 |
| 3003     | 2018 |
| 3003     | 2020 |
| 3003     | 2021 |
| 4004     | 2019 |
| 4004     | 2020 |
| 4004     | 2021 |
*/

-- Here is the expected output.

/*
| Sales ID |
|----------|
| 4004     |
*/

-- - `Sales ID` `4004` would be in the expected output as this salesman had a sale in the current year, plus the previous two years.


-- ==================================================
-- Solution for Puzzle 48
-- ==================================================

DROP TABLE IF EXISTS Sales;

CREATE TABLE Sales
(
SalesID  INTEGER,
[Year]   INTEGER,
PRIMARY KEY (SalesID, [Year])
);

INSERT INTO Sales (SalesID, [Year]) VALUES
(1001,2018),(1001,2019),(1001,2020),(2002,2020),(2002,2021),
(3003,2018),(3003,2020),(3003,2021),(4004,2019),(4004,2020),(4004,2021);

SELECT  SalesID
FROM    Sales
GROUP BY SalesID
HAVING  SUM(CASE WHEN [Year] = '2021'     THEN 1 ELSE 0 END) > 0
    AND SUM(CASE WHEN [Year] = '2021' - 1 THEN 1 ELSE 0 END) > 0
    AND SUM(CASE WHEN [Year] = '2021' - 2 THEN 1 ELSE 0 END) > 0
ORDER BY SalesID;
