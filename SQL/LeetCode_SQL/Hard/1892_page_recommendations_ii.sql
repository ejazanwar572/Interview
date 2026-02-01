-- 1892. Page Recommendations II
-- Difficulty: Hard
-- Description:
-- You are implementing a page recommendation system for a social media website. Your system will recommend a page to user_id if the page is liked by at least one friend of user_id and is not liked by user_id.
-- Write an SQL query to find all the possible page recommendations for every user. Each recommendation should appear as a row in the result table with these columns:
-- user_id: The ID of the user that your system is making the recommendation to.
-- page_id: The ID of the page that will be recommended to user_id.
-- friends_likes: The number of the friends of user_id that like page_id.
-- Schema:
-- Table: Friendship
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | user1_id      | int     |
-- | user2_id      | int     |
-- +---------------+---------+
-- (user1_id, user2_id) is the primary key for this table.
-- 
-- Table: Likes
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | user_id       | int     |
-- | page_id       | int     |
-- +---------------+---------+
-- (user_id, page_id) is the primary key for this table.
-- Example Input/Output:
-- Output:
-- +---------+---------+---------------+
-- | user_id | page_id | friends_likes |
-- +---------+---------+---------------+
-- | 1       | 77      | 2             |
-- | 1       | 23      | 1             |
-- ...
-- +---------+---------+---------------+
-- Solution:
WITH AllFriends AS (
    SELECT user1_id AS user_id, user2_id AS friend_id FROM Friendship
    UNION ALL
    SELECT user2_id AS user_id, user1_id AS friend_id FROM Friendship
),
FriendLikes AS (
    SELECT
        f.user_id,
        l.page_id,
        COUNT(l.user_id) AS friends_likes
    FROM
        AllFriends f
        JOIN Likes l ON f.friend_id = l.user_id
    GROUP BY
        f.user_id,
        l.page_id
)
SELECT
    fl.user_id,
    fl.page_id,
    fl.friends_likes
FROM
    FriendLikes fl
    LEFT JOIN Likes l_self ON fl.user_id = l_self.user_id AND fl.page_id = l_self.page_id
WHERE
    l_self.page_id IS NULL
ORDER BY
    fl.user_id,
    fl.page_id,
    fl.friends_likes;
