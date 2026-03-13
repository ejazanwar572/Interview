/*
================================================================================
Problem: Complex Weighted Moving Average
================================================================================
Difficulty: Hard
Pattern: Window Functions, Rolling Aggregations, Math

Description:
You are analyzing financial market data. You have a table `stock_trades` containing
daily metrics for various stock tickers.
Calculate the 3-day weighted moving average (WMA) of the stock price for each ticker.

The 3-day window includes the current day and the 2 preceding trading days.
The weight applied to the price is based on the trading `volume` of that day.
Formula:
Numerator = SUM(price * volume) over the 3-day window
Denominator = SUM(volume) over the 3-day window
WMA = Numerator / Denominator

If a stock has fewer than 3 days of historical data (e.g., the very first day), 
calculate the weighted average for whatever days DO exist currently.
Round the final WMA to 2 decimal places.

Return `trade_date`, `ticker`, and `weighted_moving_avg`.

================================================================================
Input constraints / Data examples:
================================================================================
Table: stock_trades
+------------+--------+-------+--------+
| trade_date | ticker | price | volume |
+------------+--------+-------+--------+
| 2026-01-01 | AAPL   | 150   | 1000   |
| 2026-01-02 | AAPL   | 155   | 2000   |
| 2026-01-03 | AAPL   | 160   | 3000   |
| 2026-01-04 | AAPL   | 165   | 1500   |
| 2026-01-01 | GOOG   | 2800  | 500    |
+------------+--------+-------+--------+

Expected Output (For AAPL):
+------------+--------+---------------------+
| trade_date | ticker | weighted_moving_avg |
+------------+--------+---------------------+
| 2026-01-01 | AAPL   | 150.00              | -- (150*1000) / 1000
| 2026-01-02 | AAPL   | 153.33              | -- (150*1k + 155*2k) / 3k
| 2026-01-03 | AAPL   | 156.67              | -- (150*1k + 155*2k + 160*3k) / 6k
| 2026-01-04 | AAPL   | 159.23              | -- (155*2k + 160*3k + 165*1.5k) / 6.5k
+------------+--------+---------------------+
*/

================================================================================
DDL & DML (For Testing)
================================================================================

DROP TABLE IF EXISTS stock_trades;
CREATE TABLE stock_trades (
    trade_date DATE,
    ticker VARCHAR(10),
    price DECIMAL(10,2),
    volume INT
);

INSERT INTO stock_trades (trade_date, ticker, price, volume) VALUES
('2026-01-01', 'AAPL', 150.00, 1000),
('2026-01-02', 'AAPL', 155.00, 2000),
('2026-01-03', 'AAPL', 160.00, 3000),
('2026-01-04', 'AAPL', 165.00, 1500),
('2026-01-05', 'AAPL', 170.00, 1000),
('2026-01-06', 'AAPL', 168.00, 2500),
('2026-01-07', 'AAPL', 162.00, 4000),
('2026-01-01', 'MSFT', 300.00, 5000),
('2026-01-02', 'MSFT', 305.00, 4500),
('2026-01-03', 'MSFT', 310.00, 6000),
('2026-01-04', 'MSFT', 308.00, 5500),
('2026-01-05', 'MSFT', 295.00, 8000),
('2026-01-06', 'MSFT', 290.00, 7500);

-- ==========================================
-- Your Solution Here
-- ==========================================





-- ==========================================
-- Provided Solution
-- ==========================================

SELECT 
    trade_date,
    ticker,
    ROUND(
        SUM(price * volume) OVER w 
        / 
        SUM(volume) OVER w, 
        2
    ) AS weighted_moving_avg
FROM stock_trades
WINDOW w AS (
    PARTITION BY ticker 
    ORDER BY trade_date 
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
)
ORDER BY ticker, trade_date;

-- Note: Without the named WINDOW clause, the query looks like this:
-- ROUND(
--     SUM(price * volume) OVER(PARTITION BY ticker ORDER BY trade_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) 
--     / 
--     SUM(volume) OVER(PARTITION BY ticker ORDER BY trade_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 
--     2
-- )
