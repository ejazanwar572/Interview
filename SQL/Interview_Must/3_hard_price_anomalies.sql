/*
### Problem Description
You have a table of daily stock prices. An anomaly is defined as a day where the stock price is more than twice the running 7-day average (including the current day). Write a query to find all such days.

### Sample Input and Output
**Input: StockPrices**
| date | price |
|---|---|
| '2024-01-01' | 100 |
| '2024-01-02' | 110 |
| '2024-01-03' | 105 |
| '2024-01-04' | 102 |
| '2024-01-05' | 108 |
| '2024-01-06' | 115 |
| '2024-01-07' | 250 | -- < Anomaly
| '2024-01-08' | 110 |

**Output:**
| date | price | running_avg |
|---|---|---|
| '2024-01-07' | 250 | 112.86 |
*/

-- DDL and DML commands
DROP TABLE IF EXISTS StockPrices;
CREATE TABLE StockPrices (
    date DATE,
    price INT
);

INSERT INTO StockPrices (date, price) VALUES
('2024-01-01', 100),
('2024-01-02', 110),
('2024-01-03', 105),
('2024-01-04', 102),
('2024-01-05', 108),
('2024-01-06', 115),
('2024-01-07', 350),
('2024-01-08', 110);


/*
### Approach
This question combines rolling window functions with conditional filtering.
1. Calculate the 7-day rolling average (the current row + 6 preceding rows) using `AVG(price) OVER(ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)`.
2. Wrap that calculation in a CTE to make it referenceable in a `WHERE` clause.
3. Apply the anomaly filter: `WHERE price > 2 * running_avg`.
*/


SELECT date , price , ROUND(AVG(price) OVER(ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW))
    , IF(price > 2*ROUND(AVG(price) OVER(ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)),1,0) as anm_flag
FROM `StockPrices`







-- Optimized Solution
WITH RollingAverages AS (
    SELECT 
        date,
        price,
        ROUND(AVG(price) OVER(ORDER BY date ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS running_avg
    FROM StockPrices
)
SELECT date, price, running_avg
FROM RollingAverages
WHERE price > 2 * running_avg;
