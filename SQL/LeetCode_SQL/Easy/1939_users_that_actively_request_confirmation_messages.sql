-- 1939. Users That Actively Request Confirmation Messages
-- Difficulty: Easy
-- Description:
-- Write an SQL query to find the IDs of the users that requested a confirmation message twice within a 24-hour window. Two messages exactly 24 hours apart are considered to be within the window. The action does not affect the answer, only the request time.
-- Schema:
-- Table: Confirmations
-- +----------------+----------+
-- | Column Name    | Type     |
-- +----------------+----------+
-- | user_id        | int      |
-- | time_stamp     | datetime |
-- | action         | ENUM     |
-- +----------------+----------+
-- (user_id, time_stamp) is the primary key for this table.
-- Example Input/Output:
-- Output:
-- +---------+
-- | user_id |
-- +---------+
-- | 3       |
-- +---------+
-- Solution:
SELECT DISTINCT
    c1.user_id
FROM
    Confirmations c1
    JOIN Confirmations c2 ON c1.user_id = c2.user_id
    AND c1.time_stamp < c2.time_stamp
    AND TIMESTAMPDIFF(SECOND, c1.time_stamp, c2.time_stamp) <= 86400;
