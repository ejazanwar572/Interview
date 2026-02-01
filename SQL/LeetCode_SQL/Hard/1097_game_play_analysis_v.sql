-- 1097. Game Play Analysis V
-- Difficulty: Hard
-- Table: Activity
-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | player_id    | int     |
-- | device_id    | int     |
-- | event_date   | date    |
-- | games_played | int     |
-- +--------------+---------+
-- (player_id, event_date) is the primary key of this table.
-- This table shows the activity of players of some games.
-- Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on someday using some device.
-- We define the install date of a player to be the first login day of that player.
-- We also define day one retention of some date x to be the number of players whose install date is x and they logged back in on the day right after x, divided by the number of players whose install date is x, rounded to 2 decimal places.
-- Write an SQL query to report for each install date, the number of players that installed the game on that day, and the day one retention.
-- Example:
-- Input:
-- Activity table:
-- +-----------+-----------+------------+--------------+
-- | player_id | device_id | event_date | games_played |
-- +-----------+-----------+------------+--------------+
-- | 1         | 2         | 2016-03-01 | 5            |
-- | 1         | 2         | 2016-03-02 | 6            |
-- | 2         | 3         | 2017-06-25 | 1            |
-- | 3         | 1         | 2016-03-01 | 0            |
-- | 3         | 4         | 2016-07-03 | 5            |
-- +-----------+-----------+------------+--------------+
-- Output:
-- +------------+----------+----------------+
-- | install_dt | installs | Day1_retention |
-- +------------+----------+----------------+
-- | 2016-03-01 | 2        | 0.50           |
-- | 2017-06-25 | 1        | 0.00           |
-- +------------+----------+----------------+
WITH PlayerInstalls AS (
    SELECT
        player_id,
        MIN(event_date) AS install_dt
    FROM
        Activity
    GROUP BY
        player_id
),
InstallStats AS (
    SELECT
        pi.install_dt,
        COUNT(pi.player_id) AS installs,
        SUM(CASE WHEN a.event_date IS NOT NULL THEN 1 ELSE 0 END) AS retained_count
    FROM
        PlayerInstalls pi
        LEFT JOIN Activity a ON pi.player_id = a.player_id 
                             AND a.event_date = DATE_ADD(pi.install_dt, INTERVAL 1 DAY)
    GROUP BY
        pi.install_dt
)
SELECT
    install_dt,
    installs,
    ROUND(retained_count / installs, 2) AS Day1_retention
FROM
    InstallStats
ORDER BY
    install_dt;
-- Solution:
