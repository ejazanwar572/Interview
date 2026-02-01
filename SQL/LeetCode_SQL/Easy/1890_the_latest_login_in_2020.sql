-- 1890. The Latest Login in 2020
-- Difficulty: Easy
-- Description:
-- Write an SQL query to report the latest login for all users in the year 2020. Do not include users who did not login in 2020.
-- Schema:
-- Table: Logins
-- +----------------+----------+
-- | Column Name    | Type     |
-- +----------------+----------+
-- | user_id        | int      |
-- | time_stamp     | datetime |
-- +----------------+----------+
-- (user_id, time_stamp) is the primary key for this table.
-- Example Input/Output:
-- Output:
-- +---------+---------------------+
-- | user_id | last_stamp          |
-- +---------+---------------------+
-- | 6       | 2020-06-30 15:06:07 |
-- | 8       | 2020-12-30 00:46:50 |
-- | 2       | 2020-01-16 02:49:50 |
-- +---------+---------------------+
-- Solution:
SELECT
    user_id,
    MAX(time_stamp) AS last_stamp
FROM
    Logins
WHERE
    YEAR(time_stamp) = 2020
GROUP BY
    user_id;
