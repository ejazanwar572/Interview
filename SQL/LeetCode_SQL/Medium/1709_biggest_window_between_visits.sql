-- 1709. Biggest Window Between Visits
-- Difficulty: Medium
-- Description:
-- For each user, find the biggest window of days between each two consecutive visits of that user and the last day of the year 2020 ('2020-12-31').
-- The window of days is the difference in days between two dates.
-- Schema:
-- Table: UserVisits
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | user_id       | int     |
-- | visit_date    | date    |
-- +---------------+---------+
-- No primary key.
-- Example Input/Output:
-- Output:
-- +---------+----------------+
-- | user_id | biggest_window |
-- +---------+----------------+
-- | 1       | 39             |
-- | 2       | 65             |
-- | 3       | 70             |
-- +---------+----------------+
-- Solution:
WITH VisitsWithNext AS (
    SELECT
        user_id,
        visit_date,
        LEAD(visit_date, 1, '2021-01-01') OVER (
            PARTITION BY user_id 
            ORDER BY visit_date
        ) AS next_visit
    FROM
        UserVisits
)
SELECT
    user_id,
    MAX(DATEDIFF(next_visit, visit_date)) AS biggest_window
FROM
    VisitsWithNext
GROUP BY
    user_id
ORDER BY
    user_id;
