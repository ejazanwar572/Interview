-- 1613. Find the Missing IDs
-- Difficulty: Medium
-- Description:
-- Find the missing customer IDs in the range between 1 and the maximum customer_id in the table.
-- Schema:
-- Table: Customers
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | customer_id   | int     |
-- | customer_name | varchar |
-- +---------------+---------+
-- customer_id is the primary key for this table.
-- Example Input/Output:
-- Input:
-- Customers table:
-- +-------------+---------------+
-- | customer_id | customer_name |
-- +-------------+---------------+
-- | 1           | Alice         |
-- | 4           | Bob           |
-- +-------------+---------------+
-- Output:
-- +-----+
-- | ids |
-- +-----+
-- | 2   |
-- | 3   |
-- +-----+
-- Solution:
WITH RECURSIVE NumberSeq AS (
    SELECT 1 AS ids
    UNION ALL
    SELECT ids + 1
    FROM NumberSeq
    WHERE ids < (SELECT MAX(customer_id) FROM Customers)
)
SELECT
    ids
FROM
    NumberSeq
WHERE
    ids NOT IN (SELECT customer_id FROM Customers);
