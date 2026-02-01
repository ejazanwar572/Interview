-- 1479. Sales by Day of the Week
-- Difficulty: Hard
-- Description:
-- Write a solution to report the number of units of each category of items ordered each day of the week.
-- Return the result table ordered by category.
-- Schema:
-- Table: Orders
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | order_id      | int     |
-- | customer_id   | int     |
-- | order_date    | date    |
-- | item_id       | varchar |
-- | quantity      | int     |
-- +---------------+---------+
-- order_id is the primary key for this table.
-- 
-- Table: Items
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | item_id       | varchar |
-- | item_name     | varchar |
-- | item_category | varchar |
-- +---------------+---------+
-- item_id is the primary key for this table.
-- Example Input/Output:
-- Orders table:
-- +----------+-------------+------------+---------+----------+
-- | order_id | customer_id | order_date | item_id | quantity |
-- +----------+-------------+------------+---------+----------+
-- | 1        | 1           | 2020-06-01 | 1       | 10       |
-- | 2        | 1           | 2020-06-08 | 2       | 10       |
-- +----------+-------------+------------+---------+----------+
-- Items table:
-- +---------+-----------+---------------+
-- | item_id | item_name | item_category |
-- +---------+-----------+---------------+
-- | 1       | LC Phone  | Phone         |
-- | 2       | LC T-Shirt| T-Shirt       |
-- +---------+-----------+---------------+
-- Output:
-- +------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
-- | Category   | Monday    | Tuesday   | Wednesday | Thursday  | Friday    | Saturday  | Sunday    |
-- +------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
-- | Phone      | 10        | 0         | 0         | 0         | 0         | 0         | 0         |
-- | T-Shirt    | 10        | 0         | 0         | 0         | 0         | 0         | 0         |
-- +------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
-- Solution:
SELECT
    i.item_category AS Category,
    SUM(CASE WHEN DAYOFWEEK(o.order_date) = 2 THEN o.quantity ELSE 0 END) AS Monday,
    SUM(CASE WHEN DAYOFWEEK(o.order_date) = 3 THEN o.quantity ELSE 0 END) AS Tuesday,
    SUM(CASE WHEN DAYOFWEEK(o.order_date) = 4 THEN o.quantity ELSE 0 END) AS Wednesday,
    SUM(CASE WHEN DAYOFWEEK(o.order_date) = 5 THEN o.quantity ELSE 0 END) AS Thursday,
    SUM(CASE WHEN DAYOFWEEK(o.order_date) = 6 THEN o.quantity ELSE 0 END) AS Friday,
    SUM(CASE WHEN DAYOFWEEK(o.order_date) = 7 THEN o.quantity ELSE 0 END) AS Saturday,
    SUM(CASE WHEN DAYOFWEEK(o.order_date) = 1 THEN o.quantity ELSE 0 END) AS Sunday
FROM
    Items i
    LEFT JOIN Orders o ON i.item_id = o.item_id
GROUP BY
    i.item_category
ORDER BY
    i.item_category;
