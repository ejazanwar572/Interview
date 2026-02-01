-- 1917. Leetcodify Friends Recommendations
-- Difficulty: Hard
-- Description:
-- Write an SQL query to recommend user x to user y if:
-- 1. Users x and y are not friends, and
-- 2. Users x and y listened to the same three or more different songs on the same day.
-- Note that friend recommendations are unidirectional, meaning if user x and user y should be recommended to each other, the result table should have both recommending x to y and recommending y to x.
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
-- | user_id | recommended_id |
-- +---------+----------------+
-- | 1       | 3              |
-- | 2       | 3              |
-- | 3       | 1              |
-- | 3       | 2              |
-- +---------+----------------+
-- Solution:
WITH DailyListens AS (
    SELECT DISTINCT
        user_id,
        song_id,
        day
    FROM
        Listens
),
SimilarListeners AS (
    SELECT
        l1.user_id AS user_id,
        l2.user_id AS recommended_id,
        l1.day
    FROM
        DailyListens l1
        JOIN DailyListens l2 ON l1.song_id = l2.song_id AND l1.day = l2.day AND l1.user_id != l2.user_id
    GROUP BY
        l1.user_id,
        l2.user_id,
        l1.day
    HAVING
        COUNT(DISTINCT l1.song_id) >= 3
)
SELECT DISTINCT
    s.user_id,
    s.recommended_id
FROM
    SimilarListeners s
    LEFT JOIN Friendship f ON (s.user_id = f.user1_id AND s.recommended_id = f.user2_id)
                           OR (s.user_id = f.user2_id AND s.recommended_id = f.user1_id)
WHERE
    f.user1_id IS NULL;
