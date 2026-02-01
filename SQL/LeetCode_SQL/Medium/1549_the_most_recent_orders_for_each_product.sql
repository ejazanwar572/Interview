-- 1549. The Most Recent Orders for Each Product
-- Difficulty: Medium
-- Description:
-- Find the most recent orders for each product.
-- Return the result table ordered by product_name (ASC), product_id (ASC), and order_id (ASC).
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
-- Table: Products
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | product_id    | int     |
-- | name          | varchar |
-- | price         | int     |
-- +---------------+---------+
-- product_id is the primary key for this table.
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
-- Example Input/Output:
-- Output:
-- +--------------+------------+----------+------------+
-- | product_name | product_id | order_id | order_date |
-- +--------------+------------+----------+------------+
-- | keyboard     | 1          | 2        | 2020-06-16 |
-- | mouse        | 2          | 3        | 2020-06-10 |
-- +--------------+------------+----------+------------+
-- Solution:
WITH RankedProductOrders AS (
    SELECT
        p.name AS product_name,
        p.product_id,
        o.order_id,
        o.order_date,
        RANK() OVER (
            PARTITION BY p.product_id 
            ORDER BY o.order_date DESC
        ) AS rn
    FROM
        Products p
        JOIN Orders o ON p.product_id = o.product_id
)
SELECT
    product_name,
    product_id,
    order_id,
    order_date
FROM
    RankedProductOrders
WHERE
    rn = 1
ORDER BY
    product_name ASC,
    product_id ASC,
    order_id ASC;
