-- 1867. Orders With Maximum Quantity Above Average
-- Difficulty: Medium
-- Description:
-- An imbalanced order is one whose maximum quantity is strictly greater than the average quantity of every order (including itself).
-- Write an SQL query to find the order_id of all imbalanced orders.
-- Schema:
-- Table: OrdersDetails
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | order_id    | int  |
-- | product_id  | int  |
-- | quantity    | int  |
-- +-------------+------+
-- (order_id, product_id) is the primary key for this table.
-- Example Input/Output:
-- Output:
-- +----------+
-- | order_id |
-- +----------+
-- | 1        |
-- | 3        |
-- +----------+
-- Solution:
WITH OrderStats AS (
    SELECT
        order_id,
        MAX(quantity) AS max_quantity,
        AVG(quantity) AS avg_quantity
    FROM
        OrdersDetails
    GROUP BY
        order_id
),
MaxAvg AS (
    SELECT
        MAX(avg_quantity) AS global_max_avg
    FROM
        OrderStats
)
SELECT
    order_id
FROM
    OrderStats,
    MaxAvg
WHERE
    max_quantity > global_max_avg;
