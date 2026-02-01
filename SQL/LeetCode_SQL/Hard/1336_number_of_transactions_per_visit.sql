-- 1336. Number of Transactions per Visit
-- Difficulty: Hard
-- Table: Visits
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | user_id       | int     |
-- | visit_date    | date    |
-- +---------------+---------+
-- (user_id, visit_date) is the primary key for this table.
-- Each row of this table indicates that user_id has visited the bank in visit_date.
-- Table: Transactions
-- +------------------+---------+
-- | Column Name      | Type    |
-- +------------------+---------+
-- | user_id          | int     |
-- | transaction_date | date    |
-- | amount           | int     |
-- +------------------+---------+
-- There is no primary key for this table, it may have duplicate rows.
-- Each row of this table indicates that user_id has done a transaction of amount in transaction_date.
-- It is guaranteed that the user has visited the bank in the transaction_date.(i.e The Visits table contains (user_id, transaction_date) in one row)
-- Write an SQL query to find how many users visited the bank and didn't do any transactions, how many visited the bank and did one transaction and so on.
-- Example:
-- Input:
-- Visits table:
-- +---------+------------+
-- | user_id | visit_date |
-- +---------+------------+
-- | 1       | 2020-01-01 |
-- | 2       | 2020-01-03 |
-- | 1       | 2020-01-02 |
-- | 2       | 2020-01-01 |
-- | 3       | 2020-01-02 |
-- +---------+------------+
-- Transactions table:
-- +---------+------------------+--------+
-- | user_id | transaction_date | amount |
-- +---------+------------------+--------+
-- | 1       | 2020-01-02       | 120    |
-- | 2       | 2020-01-03       | 22     |
-- | 7       | 2020-01-11       | 232    |
-- | 1       | 2020-01-04       | 7      |
-- +---------+------------------+--------+
-- Output:
-- +--------------------+--------------+
-- | transactions_count | visits_count |
-- +--------------------+--------------+
-- | 0                  | 4            |
-- | 1                  | 5            |
-- | 2                  | 0            |
-- | 3                  | 0            |
-- +--------------------+--------------+
-- Approach:
-- 1. Count transactions for each visit (Visits LEFT JOIN Transactions). Care must be taken: A user can transaction multiple times in one visit.
-- 2. Group by (user_id, visit_date) to get trans_count per visit.
-- 3. We need a list of all possible transaction counts (0, 1, 2... max_trans_count) to display 0 visits_count even if no visit had that many transactions.
--    The max transaction count we need to cover is the max number of transactions done by any user in one visit.
--    However, usually recursive CTE is used to generate numbers from 0 to MAX(trans_count).
WITH VisitStats AS (
    SELECT
        v.user_id,
        v.visit_date,
        COUNT(t.amount) AS trans_count
    FROM
        Visits v
        LEFT JOIN Transactions t ON v.user_id = t.user_id AND v.visit_date = t.transaction_date
    GROUP BY
        v.user_id,
        v.visit_date
),
MaxTrans AS (
    SELECT MAX(trans_count) AS max_c FROM VisitStats
),
Numbers AS (
    SELECT 0 AS n
    UNION ALL
    SELECT n + 1 FROM Numbers WHERE n < (SELECT max_c FROM MaxTrans)
)
SELECT
    n.n AS transactions_count,
    COUNT(v.trans_count) AS visits_count
FROM
    Numbers n
    LEFT JOIN VisitStats v ON n.n = v.trans_count
GROUP BY
    n.n
ORDER BY
    n.n;
-- Solution:
