-- 1555. Bank Account Summary
-- Difficulty: Medium
-- Description:
-- Calculate the current balance of all users. Each user has an initial credit and a list of transactions.
-- Report the current balance and whether they are liquidated (balance < 0).
-- Schema:
-- Table: Users
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | user_id       | int     |
-- | user_name     | varchar |
-- | credit        | int     |
-- +---------------+---------+
-- user_id is the primary key for this table.
-- 
-- Table: Transactions
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | trans_id      | int     |
-- | paid_by       | int     |
-- | paid_to       | int     |
-- | amount        | int     |
-- | transacted_on | date    |
-- +---------------+---------+
-- trans_id is the primary key for this table.
-- Example Input/Output:
-- Output:
-- +---------+------------+---------+----------------+
-- | user_id | user_name  | credit  | is_liquidated  |
-- +---------+------------+---------+----------------+
-- | 1       | Moustafa   | -100    | Yes            |
-- | 2       | Jonathan   | 500     | No             |
-- +---------+------------+---------+----------------+
-- Solution:
SELECT
    u.user_id,
    u.user_name,
    u.credit - IFNULL(SUM(CASE WHEN t.paid_by = u.user_id THEN t.amount ELSE 0 END), 0)
             + IFNULL(SUM(CASE WHEN t.paid_to = u.user_id THEN t.amount ELSE 0 END), 0) AS credit,
    CASE
        WHEN u.credit - IFNULL(SUM(CASE WHEN t.paid_by = u.user_id THEN t.amount ELSE 0 END), 0)
                      + IFNULL(SUM(CASE WHEN t.paid_to = u.user_id THEN t.amount ELSE 0 END), 0) < 0 THEN 'Yes'
        ELSE 'No'
    END AS is_liquidated
FROM
    Users u
    LEFT JOIN Transactions t ON u.user_id = t.paid_by OR u.user_id = t.paid_to
GROUP BY
    u.user_id,
    u.user_name,
    u.credit;
