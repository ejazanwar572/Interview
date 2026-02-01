-- 1747. Leetflex Banned Accounts
-- Difficulty: Medium
-- Description:
-- Write an SQL query to find the account_id(s) that should be banned from Leetflex.
-- An account should be banned if it was logged in from two different IP addresses at the same time (i.e., the login time intervals overlap).
-- Schema:
-- Table: Logins
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | account_id    | int     |
-- | ip_address    | int     |
-- | login         | datetime|
-- | logout        | datetime|
-- +---------------+---------+
-- No primary key.
-- Example Input/Output:
-- Output:
-- +------------+
-- | account_id |
-- +------------+
-- | 1          |
-- +------------+
-- Solution:
SELECT DISTINCT
    l1.account_id
FROM
    Logins l1
    JOIN Logins l2 ON l1.account_id = l2.account_id
WHERE
    l1.ip_address != l2.ip_address
    AND (
        (l1.login BETWEEN l2.login AND l2.logout)
        OR (l1.logout BETWEEN l2.login AND l2.logout)
    );
