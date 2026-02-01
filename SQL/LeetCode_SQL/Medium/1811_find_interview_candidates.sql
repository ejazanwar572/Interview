-- 1811. Find Interview Candidates
-- Difficulty: Medium
-- Description:
-- Find all interview candidates. A candidate is someone who:
-- 1. Won any medal in three or more consecutive contests.
-- 2. Won three or more gold medals in total.
-- Schema:
-- Table: Contests
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | contest_id    | int     |
-- | gold_medal    | int     |
-- | silver_medal  | int     |
-- | bronze_medal  | int     |
-- +---------------+---------+
-- contest_id is the primary key for this table.
-- 
-- Table: Users
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | user_id       | int     |
-- | mail          | varchar |
-- | name          | varchar |
-- +---------------+---------+
-- user_id is the primary key for this table.
-- Example Input/Output:
-- Output:
-- +-------+--------------------+
-- | name  | mail               |
-- +-------+--------------------+
-- | Sarah | sarah@leetcode.com |
-- +-------+--------------------+
-- Solution:
WITH Medals AS (
    SELECT contest_id, gold_medal AS user_id FROM Contests
    UNION ALL
    SELECT contest_id, silver_medal AS user_id FROM Contests
    UNION ALL
    SELECT contest_id, bronze_medal AS user_id FROM Contests
),
ConsecutiveMedals AS (
    SELECT
        user_id,
        contest_id,
        LAG(contest_id, 1) OVER (PARTITION BY user_id ORDER BY contest_id) AS prev1,
        LAG(contest_id, 2) OVER (PARTITION BY user_id ORDER BY contest_id) AS prev2
    FROM
        Medals
),
Candidates AS (
    -- Condition 1: Three or more consecutive contests
    SELECT DISTINCT user_id
    FROM ConsecutiveMedals
    WHERE contest_id = prev1 + 1 AND prev1 = prev2 + 1
    
    UNION
    
    -- Condition 2: Won three or more gold medals
    SELECT gold_medal AS user_id
    FROM Contests
    GROUP BY gold_medal
    HAVING COUNT(*) >= 3
)
SELECT
    u.name,
    u.mail
FROM
    Candidates c
    JOIN Users u ON c.user_id = u.user_id;
