-- Advanced SQL Challenge: Running Total Resets Monthly
-- Difficulty: Senior

/*
Problem Statement:
Calculate a running total of gross sales for each product category.
However, the running total MUST explicitly reset to 0 at the beginning 
of each new calendar month.

Expected Output Columns:
category_name, order_date, daily_sales, cumulative_monthly_sales

Edge Cases Handled:
- There may be days with no sales.
- Ensure the sum partitions strictly by both category AND the month/year.

Schema & DML Data:
*/
USE practice_sql_db;

DROP TABLE IF EXISTS DailyCategorySales;

CREATE TABLE DailyCategorySales (
    category_name VARCHAR(50),
    order_date DATE,
    daily_sales DECIMAL(10, 2)
);

INSERT INTO
    DailyCategorySales (
        category_name,
        order_date,
        daily_sales
    )
VALUES (
        'Electronics',
        '2023-10-28',
        1200.00
    ),
    (
        'Electronics',
        '2023-10-30',
        800.00
    ), -- Cumulative should be 2000.00
    (
        'Electronics',
        '2023-11-01',
        500.00
    ), -- NEW MONTH! Cumulative resets to 500.00
    (
        'Electronics',
        '2023-11-05',
        1500.00
    ), -- Cumulative should be 2000.00
    (
        'Furniture',
        '2023-10-30',
        3000.00
    ),
    (
        'Furniture',
        '2023-11-02',
        400.00
    );
-- NEW MONTH! Cumulative resets to 400.00

-- ==========================================
-- Your Sol
-- ==========================================

-- ==========================================
-- Solutions Provided
-- ==========================================

/*
SELECT 
category_name,
order_date,
daily_sales,
-- We partition by both the category and the extracted month/year
-- Ordering by date ensures the running total accumulates chronologically
SUM(daily_sales) OVER (
PARTITION BY 
category_name, 
DATE_FORMAT(order_date, '%Y-%m') 
ORDER BY order_date
) AS cumulative_monthly_sales
FROM DailyCategorySales
ORDER BY 
category_name, 
order_date;
*/