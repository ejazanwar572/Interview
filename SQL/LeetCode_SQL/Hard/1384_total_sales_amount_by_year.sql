-- 1384. Total Sales Amount by Year
-- Difficulty: Hard
-- Description:
-- Write an SQL query to report the Total sales amount of each item for each year, with corresponding product name, product_id, product_name, and report_year.
-- Dates of the sales years are between 2018 to 2020.
-- Return the result table ordered by product_id and report_year.
-- Schema:
-- Table: Product
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | product_id    | int     |
-- | product_name  | varchar |
-- +---------------+---------+
-- product_id is the primary key for this table.
-- 
-- Table: Sales
-- +---------------------+---------+
-- | Column Name         | Type    |
-- +---------------------+---------+
-- | product_id          | int     |
-- | period_start        | date    |
-- | period_end          | date    |
-- | average_daily_sales | int     |
-- +---------------------+---------+
-- product_id is the primary key for this table.
-- period_start and period_end indicates the start and end date for sales period, both dates are inclusive.
-- Example Input/Output:
-- Product table:
-- +------------+--------------+
-- | product_id | product_name |
-- +------------+--------------+
-- | 1          | LC Phone     |
-- | 2          | LC T-Shirt   |
-- | 3          | LC Keychain  |
-- +------------+--------------+
-- Sales table:
-- +------------+--------------+-------------+---------------------+
-- | product_id | period_start | period_end  | average_daily_sales |
-- +------------+--------------+-------------+---------------------+
-- | 1          | 2019-01-25   | 2019-12-31  | 100                 |
-- | 2          | 2018-12-01   | 2020-01-01  | 10                  |
-- | 3          | 2019-12-01   | 2020-01-31  | 1                   |
-- +------------+--------------+-------------+---------------------+
-- Result table:
-- +------------+--------------+-------------+--------------+
-- | product_id | product_name | report_year | total_amount |
-- +------------+--------------+-------------+--------------+
-- | 1          | LC Phone     | 2019        | 34100        |
-- | 2          | LC T-Shirt   | 2018        | 310          |
-- | 2          | LC T-Shirt   | 2019        | 3650         |
-- | 2          | LC T-Shirt   | 2020        | 10           |
-- | 3          | LC Keychain  | 2019        | 31           |
-- | 3          | LC Keychain  | 2020        | 31           |
-- +------------+--------------+-------------+--------------+
-- Solution:
WITH Calendar AS (
    SELECT '2018-01-01' AS year_start, '2018-12-31' AS year_end, '2018' AS report_year
    UNION ALL
    SELECT '2019-01-01', '2019-12-31', '2019'
    UNION ALL
    SELECT '2020-01-01', '2020-12-31', '2020'
)
SELECT
    s.product_id,
    p.product_name,
    c.report_year,
    (DATEDIFF(
        LEAST(s.period_end, c.year_end),
        GREATEST(s.period_start, c.year_start)
    ) + 1) * s.average_daily_sales AS total_amount
FROM
    Sales s
    JOIN Product p ON s.product_id = p.product_id
    JOIN Calendar c ON s.period_start <= c.year_end
    AND s.period_end >= c.year_start
ORDER BY
    s.product_id,
    c.report_year;
