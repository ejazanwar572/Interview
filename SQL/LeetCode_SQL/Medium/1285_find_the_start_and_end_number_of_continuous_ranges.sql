-- 1285. Find the Start and End Number of Continuous Ranges
-- Difficulty: Medium
-- Table: Logs
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | log_id        | int     |
-- +---------------+---------+
-- log_id is the primary key of this table.
-- Each row of this table contains the ID in a log Table.
-- Write an SQL query to find the start and end number of continuous ranges in the table Logs.
-- Order result by start_id.
-- Example:
-- Input:
-- Logs table:
-- +------------+
-- | log_id     |
-- +------------+
-- | 1          |
-- | 2          |
-- | 3          |
-- | 7          |
-- | 8          |
-- | 10         |
-- +------------+
-- Output:
-- +------------+--------------+
-- | start_id   | end_id       |
-- +------------+--------------+
-- | 1          | 3            |
-- | 7          | 8            |
-- | 10         | 10           |
-- +------------+--------------+
WITH RankedLogs AS (
    SELECT
        log_id,
        ROW_NUMBER() OVER (ORDER BY log_id) AS rn
    FROM
        Logs
),
Groups AS (
    SELECT
        log_id,
        (log_id - rn) AS group_id
    FROM
        RankedLogs
)
SELECT
    MIN(log_id) AS start_id,
    MAX(log_id) AS end_id
FROM
    Groups
GROUP BY
    group_id
ORDER BY
    start_id;
-- Solution:
