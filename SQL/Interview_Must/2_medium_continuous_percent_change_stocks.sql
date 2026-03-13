-- Advanced SQL Challenge: Continuous Percentage Change
-- Difficulty: Senior

/*
Problem Statement:
Given a table of daily stock prices, write a query to calculate the continuous 
percentage change in price from the previous trading day.

Crucially, you must handle gaps in trading days. Specifically, calculate the 
percentage change strictly relative to the *most recent valid trading day* in 
the past, explicitly skipping weekends and holidays where no data exists. 

Formula for Percentage Change:
((Current Price - Previous Price) / Previous Price) * 100

Edge Cases Handled:
- Gaps in the date sequence (e.g., Friday to Monday skipping the weekend).
- The very first day for a stock should show a NULL percentage change.
- Percentage change should be rounded to 2 decimal places.

Example Input (StockPrices):
| stock_symbol | trading_date | closing_price |
|--------------|--------------|---------------|
| AAPL         | 2023-11-01   | 170.00        |
| AAPL         | 2023-11-02   | 172.50        |
| AAPL         | 2023-11-03   | 171.00        |
| AAPL         | 2023-11-06   | 175.00        |
| MSFT         | 2023-11-01   | 345.00        |
| MSFT         | 2023-11-02   | 350.00        |

Expected Output:
| stock_symbol | trading_date | closing_price | percentage_change |
|--------------|--------------|---------------|-------------------|
| AAPL         | 2023-11-01   | 170.00        | NULL              |
| AAPL         | 2023-11-02   | 172.50        | 1.47              |
| AAPL         | 2023-11-03   | 171.00        | -0.87             |
| AAPL         | 2023-11-06   | 175.00        | 2.34              |
| MSFT         | 2023-11-01   | 345.00        | NULL              |
| MSFT         | 2023-11-02   | 350.00        | 1.45              |

Schema & DML Data:
*/
USE practice_sql_db;

DROP TABLE IF EXISTS StockPrices;

CREATE TABLE StockPrices (
    stock_symbol VARCHAR(10),
    trading_date DATE,
    closing_price DECIMAL(10, 2)
);

INSERT INTO
    StockPrices (
        stock_symbol,
        trading_date,
        closing_price
    )
VALUES ('AAPL', '2023-11-01', 170.00), -- Wednesday
    ('AAPL', '2023-11-02', 172.50), -- Thursday (Normal next day)
    ('AAPL', '2023-11-03', 171.00), -- Friday (Normal next day)
    -- Notice: Nov 4th & 5th (Weekend) are MISSING
    ('AAPL', '2023-11-06', 175.00), -- Monday (Should compare to Friday Nov 3rd)
    ('AAPL', '2023-11-08', 174.00), -- Wednesday (Holiday skipped Nov 7th, compare to Nov 6th)
    ('MSFT', '2023-11-01', 345.00), -- Separate partitioned stock
    ('MSFT', '2023-11-02', 350.00);

-- ==========================================
-- Your Sol
-- ==========================================

SELECT a.*, b.closing_price
FROM
    StockPrices a
    LEFT JOIN StockPrices b On a.stock_symbol = b.stock_symbol
    AND a.trading_date > b.trading_date
    AND DATEDIFF(
        a.trading_date,
        b.trading_date
    ) = 1
ORDER BY 1, 2

-- ==========================================
-- Solutions Provided
-- ==========================================

WITH
    PreviousPrices AS (
        SELECT
            stock_symbol,
            trading_date,
            closing_price,
            -- Using LAG() to get the previous row chronologically, regardless of actual date gaps
            LAG(closing_price, 1) OVER (
                PARTITION BY
                    stock_symbol
                ORDER BY trading_date ASC
            ) as prev_price
        FROM StockPrices
    )
SELECT
    stock_symbol,
    trading_date,
    closing_price,
    ROUND(
        (
            (closing_price - prev_price) / prev_price
        ) * 100,
        2
    ) AS percentage_change
FROM PreviousPrices
ORDER BY stock_symbol, trading_date;