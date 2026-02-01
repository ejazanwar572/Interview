-- 1919. Leetcodify Similar Friends
-- Difficulty: Hard
-- Description:
-- Write a solution to report the users that are "similar friends". Two users x and y are similar friends if:
-- 1. Users x and y are friends, and
-- 2. Users x and y listened to the same three or more different songs on the same day.
-- Schema:
-- Table: Listens
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | user_id     | int     |
-- | song_id     | int     |
-- | day         | date    |
-- +-------------+---------+
-- No primary key.
-- 
-- Table: Friendship
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | user1_id      | int     |
-- | user2_id      | int     |
-- +---------------+---------+
-- (user1_id, user2_id) is the primary key for this table.
-- Example Input/Output:
-- Output:
-- +---------+----------------+
-- | user1_id| user2_id       |
-- +---------+----------------+
-- | 1       | 2              |
-- +---------+----------------+
-- Solution:
SELECT DISTINCT
    f.user1_id,
    f.user2_id
FROM
    Friendship f
    JOIN Listens l1 ON f.user1_id = l1.user_id
    JOIN Listens l2 ON f.user2_id = l2.user_id AND l1.song_id = l2.song_id AND l1.day = l2.day
GROUP BY
    f.user1_id,
    f.user2_id,
    l1.day
HAVING
    COUNT(DISTINCT l1.song_id) >= 3;
