-- 1783. Grand Slam Titles
-- Difficulty: Medium
-- Description:
-- Write an SQL query to report the number of grand slam titles won by each player. Report only players who won at least one title.
-- Schema:
-- Table: Players
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | player_id     | int     |
-- | player_name   | varchar |
-- +---------------+---------+
-- player_id is the primary key for this table.
-- 
-- Table: Championships
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | year          | int     |
-- | Wimbledon     | int     |
-- | Fr_open       | int     |
-- | US_open       | int     |
-- | Au_open       | int     |
-- +---------------+---------+
-- year is the primary key for this table.
-- Example Input/Output:
-- Output:
-- +-----------+-------------+-------------------+
-- | player_id | player_name | grand_slams_count |
-- +-----------+-------------+-------------------+
-- | 1         | Nadal       | 5                 |
-- | 2         | Federer     | 3                 |
-- +-----------+-------------+-------------------+
-- Solution:
SELECT
    p.player_id,
    p.player_name,
    COUNT(*) AS grand_slams_count
FROM
    Players p
    JOIN (
        SELECT Wimbledon AS winner_id FROM Championships
        UNION ALL
        SELECT Fr_open FROM Championships
        UNION ALL
        SELECT US_open FROM Championships
        UNION ALL
        SELECT Au_open FROM Championships
    ) t ON p.player_id = t.winner_id
GROUP BY
    p.player_id,
    p.player_name
ORDER BY
    grand_slams_count DESC;
