-- 1596. The Most Frequently Ordered Products for Each Customer
-- Difficulty: Medium
-- Description:
-- Find the most frequently ordered product(s) for each customer.
-- Schema:
-- Table: Customers
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | customer_id   | int     |
-- | name          | varchar |
-- +---------------+---------+
-- customer_id is the primary key for this table.
-- 
-- Table: Orders
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | order_id      | int     |
-- | order_date    | date    |
-- | customer_id   | int     |
-- | product_id    | int     |
-- +---------------+---------+
-- order_id is the primary key for this table.
-- 
-- Table: Products
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | product_id    | int     |
-- | product_name  | varchar |
-- | price         | int     |
-- +---------------+---------+
-- product_id is the primary key for this table.
-- Example Input/Output:
-- Output:
-- +-------------+------------+--------------+
-- | customer_id | product_id | product_name |
-- +-------------+------------+--------------+
-- | 1           | 2          | keyboard     |
-- | 2           | 1          | mouse        |
-- +-------------+------------+--------------+
-- Solution:
WITH ProductCounts AS (
    SELECT
        customer_id,
        product_id,
        COUNT(*) AS cnt
    FROM
        Orders
    GROUP BY
        customer_id,
        product_id
),
RankedCounts AS (
    SELECT
        customer_id,
        product_id,
        cnt,
        RANK() OVER (
            PARTITION BY customer_id 
            ORDER BY cnt DESC
        ) AS rn
    FROM
        ProductCounts
)
SELECT
    r.customer_id,
    r.product_id,
    p.product_name
FROM
    RankedCounts r
    JOIN Products p ON r.product_id = p.product_id
WHERE
    r.rn = 1;
