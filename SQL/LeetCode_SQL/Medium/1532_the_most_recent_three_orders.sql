-- 1532. The Most Recent Three Orders
-- Difficulty: Medium
-- Description:
-- Find the most recent three orders of each user. If a user has less than three orders, return all of their orders.
-- Return the result table ordered by customer_name (ASC), customer_id (ASC), and order_date (DESC).
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
-- | cost          | int     |
-- +---------------+---------+
-- order_id is the primary key for this table.
-- Example Input/Output:
-- Output:
-- +---------------+-------------+----------+------------+
-- | customer_name | customer_id | order_id | order_date |
-- +---------------+-------------+----------+------------+
-- | Winston       | 1           | 2        | 2020-08-01 |
-- | Winston       | 1           | 3        | 2020-07-31 |
-- | Winston       | 1           | 1        | 2020-07-31 |
-- +---------------+-------------+----------+------------+
-- Solution:
WITH RankedOrders AS (
    SELECT
        c.name AS customer_name,
        c.customer_id,
        o.order_id,
        o.order_date,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_id 
            ORDER BY o.order_date DESC
        ) AS rn
    FROM
        Customers c
        JOIN Orders o ON c.customer_id = o.customer_id
)
SELECT
    customer_name,
    customer_id,
    order_id,
    order_date
FROM
    RankedOrders
WHERE
    rn <= 3
ORDER BY
    customer_name ASC,
    customer_id ASC,
    order_date DESC;
