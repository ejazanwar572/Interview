-- 1355. Activity Participants
-- Difficulty: Medium
-- Description:
-- Write an SQL query to find the names of all the activities with neither maximum nor minimum number of participants.
-- Return the result table in any order.
-- Each activity in the table Activities is performed by any person in the table Friends.
-- Schema:
-- Table: Friends
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | name          | varchar |
-- | activity      | varchar |
-- +---------------+---------+
-- id is the primary key for this table.
-- name is the name of the friend.
-- activity is the name of the activity which the friend takes part in.
-- 
-- Table: Activities
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | name          | varchar |
-- +---------------+---------+
-- id is the primary key for this table.
-- name is the name of the activity.
-- Example Input/Output:
-- Friends table:
-- +------+--------------+---------------+
-- | id   | name         | activity      |
-- +------+--------------+---------------+
-- | 1    | Jonathan     | Eating        |
-- | 2    | Jade         | Eating        |
-- | 3    | Victor       | Eating        |
-- | 4    | Elvis        | Eating        |
-- | 5    | Daniel       | Dog Walking   |
-- | 6    | Bob          | Horse Riding  |
-- +------+--------------+---------------+
-- 
-- Activities table:
-- +------+--------------+
-- | id   | name         |
-- +------+--------------+
-- | 1    | Eating       |
-- | 2    | Singing      |
-- | 3    | Horse Riding |
-- | 4    | Jazz Dancing |
-- | 5    | Reading      |
-- | 6    | Dog Walking  |
-- +------+--------------+
-- 
-- Result table:
-- +--------------+
-- | activity     |
-- +--------------+
-- | Horse Riding |
-- | Dog Walking  |
-- +--------------+
-- Solution:
WITH ActivityCounts AS (
    SELECT
        activity,
        COUNT(*) AS cnt
    FROM
        Friends
    GROUP BY
        activity
)
SELECT
    activity
FROM
    ActivityCounts
WHERE
    cnt != (SELECT MAX(cnt) FROM ActivityCounts)
    AND cnt != (SELECT MIN(cnt) FROM ActivityCounts);
