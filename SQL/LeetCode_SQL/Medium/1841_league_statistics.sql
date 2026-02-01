-- 1841. League Statistics
-- Difficulty: Medium
-- Description:
-- Write a solution to report the statistics of the league. The statistics should be built using the played matches where the winning team gets three points and the losing team gets no points. If a match ends with a draw, both teams get one point.
-- Each row in the result table should contain:
-- team_name
-- matches_played
-- points
-- goal_for
-- goal_against
-- goal_diff
-- Return the result table ordered by points in descending order. If two or more teams have the same points, order them by goal_diff in descending order. If there is still a tie, order them by team_name in ascending order.
-- Schema:
-- Table: Teams
-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | team_id        | int     |
-- | team_name      | varchar |
-- +----------------+---------+
-- team_id is the primary key for this table.
-- 
-- Table: Matches
-- +-----------------+---------+
-- | Column Name     | Type    |
-- +-----------------+---------+
-- | home_team_id    | int     |
-- | away_team_id    | int     |
-- | home_team_goals | int     |
-- | away_team_goals | int     |
-- +-----------------+---------+
-- (home_team_id, away_team_id) is the primary key for this table.
-- Example Input/Output:
-- Output:
-- +------------+----------------+--------+----------+--------------+-----------+
-- | team_name  | matches_played | points | goal_for | goal_against | goal_diff |
-- +------------+----------------+--------+----------+--------------+-----------+
-- | Dortmund   | 2              | 6      | 6        | 2            | 4         |
-- | Arsenal    | 2              | 2      | 3        | 3            | 0         |
-- | Ajax       | 4              | 2      | 5        | 9            | -4        |
-- +------------+----------------+--------+----------+--------------+-----------+
-- Solution:
WITH MatchPoints AS (
    SELECT
        home_team_id AS team_id,
        home_team_goals AS goals_for,
        away_team_goals AS goals_against,
        CASE
            WHEN home_team_goals > away_team_goals THEN 3
            WHEN home_team_goals = away_team_goals THEN 1
            ELSE 0
        END AS points
    FROM Matches
    UNION ALL
    SELECT
        away_team_id AS team_id,
        away_team_goals AS goals_for,
        home_team_goals AS goals_against,
        CASE
            WHEN away_team_goals > home_team_goals THEN 3
            WHEN away_team_goals = home_team_goals THEN 1
            ELSE 0
        END AS points
    FROM Matches
)
SELECT
    t.team_name,
    COUNT(mp.team_id) AS matches_played,
    SUM(mp.points) AS points,
    SUM(mp.goals_for) AS goal_for,
    SUM(mp.goals_against) AS goal_against,
    SUM(mp.goals_for) - SUM(mp.goals_against) AS goal_diff
FROM
    Teams t
    JOIN MatchPoints mp ON t.team_id = mp.team_id
GROUP BY
    t.team_name
ORDER BY
    points DESC,
    goal_diff DESC,
    team_name ASC;
