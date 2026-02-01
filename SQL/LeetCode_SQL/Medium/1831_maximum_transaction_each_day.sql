-- 1831. Maximum Transaction Each Day
-- Difficulty: Medium
-- Description:
-- Write an SQL query to find the transaction_id(s) with the maximum amount on their respective day. If there is a tie, report all of them.
-- Schema:
-- Table: Transactions
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | transaction_id| int     |
-- | day           | datetime|
-- | amount        | int     |
-- +---------------+---------+
-- transaction_id is the primary key for this table.
-- Example Input/Output:
-- Output:
-- +----------------+
-- | transaction_id |
-- +----------------+
-- | 1              |
-- | 5              |
-- | 8              |
-- +----------------+
-- Solution:
WITH RankedTransactions AS (
    SELECT
        transaction_id,
        day,
        amount,
        RANK() OVER (
            PARTITION BY DATE(day) 
            ORDER BY amount DESC
        ) AS rn
    FROM
        Transactions
)
SELECT
    transaction_id
FROM
    RankedTransactions
WHERE
    rn = 1
ORDER BY
    transaction_id;
