-- Advanced SQL Challenge: Product Stock Out Periods (Gaps & Islands)
-- Difficulty: Senior

/*
Problem Statement:
An inventory table records product ID, date, and quantity on hand. 
Identify all continuous time periods (start date and end date) where a specific 
product had exactly 0 inventory for 3 or more consecutive days.

This is a classic "Gaps and Islands" problem testing your ability to group
sequential data that shares a state.

Example Input (DailyInventory):
| product_id | inventory_date | quantity |
|------------|----------------|----------|
| Widget-A   | 2023-11-01     | 50       |
| Widget-A   | 2023-11-02     | 0        |
| Widget-A   | 2023-11-03     | 0        |
| Widget-A   | 2023-11-04     | 0        |
| Widget-A   | 2023-11-05     | 20       |
| Widget-A   | 2023-11-06     | 0        |
| Widget-A   | 2023-11-07     | 0        |
| Widget-A   | 2023-11-08     | 5        |
| Widget-B   | 2023-11-01     | 0        |
| Widget-B   | 2023-11-02     | 0        |
| Widget-B   | 2023-11-03     | 0        |
| Widget-B   | 2023-11-04     | 0        |

Expected Output:
| product_id | out_of_stock_start | out_of_stock_end | total_consecutive_days_empty |
|------------|--------------------|------------------|------------------------------|
| Widget-A   | 2023-11-02         | 2023-11-04       | 3                            |
| Widget-B   | 2023-11-01         | 2023-11-04       | 4                            |

Schema & DML Data:
*/
USE practice_sql_db;

DROP TABLE IF EXISTS DailyInventory;

CREATE TABLE DailyInventory (
    product_id VARCHAR(10),
    inventory_date DATE,
    quantity INT
);

INSERT INTO
    DailyInventory (
        product_id,
        inventory_date,
        quantity
    )
VALUES ('Widget-A', '2023-11-01', 50),
    ('Widget-A', '2023-11-02', 0), -- Start of 1st streak (3 days)
    ('Widget-A', '2023-11-03', 0),
    ('Widget-A', '2023-11-04', 0),
    ('Widget-A', '2023-11-05', 20), -- Streak broken
    ('Widget-A', '2023-11-06', 0), -- Start of 2nd streak (Only 2 days - filter out)
    ('Widget-A', '2023-11-07', 0),
    ('Widget-A', '2023-11-08', 5),
    ('Widget-B', '2023-11-01', 0), -- Start of B's streak (4 days)
    ('Widget-B', '2023-11-02', 0),
    ('Widget-B', '2023-11-03', 0),
    ('Widget-B', '2023-11-04', 0);

-- ==========================================
-- Your Sol
-- ==========================================




SELECT product_id , anc_date , COUNT(*) as streak
FROM (SELECT product_id , inventory_date 
    , ROW_NUMBER() OVER(PARTITION BY product_id ORDER BY inventory_date)
    , DATE_SUB(inventory_date, INTERVAL ROW_NUMBER() OVER(PARTITION BY product_id ORDER BY inventory_date) DAY) anc_date
FROM  DailyInventory 
WHERE quantity = 0
) t
GROUP BY 1,2







-- ==========================================
-- Solutions Provided
-- ==========================================

/*
WITH ZeroDays AS (
-- Step 1: Filter only to days with zero inventory
SELECT * FROM DailyInventory WHERE quantity = 0
),
IslandGrouping AS (
SELECT 
product_id,
inventory_date,
-- The Core Gaps & Islands Trick:
-- Subtracting a sequential row number from a sequential date yields a CONSTANT
-- date "anchor" for any contiguous, uninterrupted sequence of days.
DATE_SUB(
inventory_date, 
INTERVAL ROW_NUMBER() OVER(PARTITION BY product_id ORDER BY inventory_date) DAY
) as streak_group
FROM ZeroDays
)
SELECT 
product_id,
MIN(inventory_date) AS out_of_stock_start,
MAX(inventory_date) AS out_of_stock_end,
COUNT(*) AS total_consecutive_days_empty
FROM IslandGrouping
GROUP BY 
product_id, 
streak_group
-- Only keep streaks of 3 or more empty days
HAVING COUNT(*) >= 3;
*/