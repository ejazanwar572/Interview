-- 1107. New Users Daily Count
-- Difficulty: Medium
-- Table: Traffic
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | user_id       | int     |
-- | activity      | enum    |
-- | activity_date | date    |
-- +---------------+---------+
-- There is no primary key for this table, it may have duplicate rows.
-- The activity column is an ENUM type of ('login', 'logout', 'jobs', 'groups', 'homepage').
-- Write an SQL query that reports for every date within at most 90 days from today, the number of users that logged in for the first time on that date. Assume today is 2019-06-30.
-- Example:
-- Input:
-- Traffic table:
-- +---------+----------+---------------+
-- | user_id | activity | activity_date |
-- +---------+----------+---------------+
-- | 1       | login    | 2019-05-01    |
-- | 1       | homepage | 2019-05-01    |
-- | 1       | logout   | 2019-05-01    |
-- | 2       | login    | 2019-06-21    |
-- | 2       | logout   | 2019-06-21    |
-- | 3       | login    | 2019-01-01    |
-- | 3       | jobs     | 2019-01-01    |
-- | 3       | logout   | 2019-01-01    |
-- | 4       | login    | 2019-06-21    |
-- | 4       | groups   | 2019-06-21    |
-- | 4       | logout   | 2019-06-21    |
-- | 5       | login    | 2019-03-01    |
-- | 5       | logout   | 2019-03-01    |
-- | 5       | login    | 2019-06-21    |
-- | 5       | logout   | 2019-06-21    |
-- +---------+----------+---------------+
-- Output:
-- +------------+-------------+
-- | login_date | user_count  |
-- +------------+-------------+
-- | 2019-05-01 | 1           |
-- | 2019-06-21 | 2           |
-- +------------+-------------+
-- Note: We only care about "login" activity.
-- First login date must be within [2019-04-01, 2019-06-30] (90 days inclusive). 2019-06-30 minus 90 days?
-- "At most 90 days from today" usually means DATEDIFF(today, date) <= 90.
-- 90 days prior to 2019-06-30 is approx 2019-04-01.
SELECT
    login_date,
    COUNT(user_id) AS user_count
FROM (
    SELECT
        user_id,
        MIN(activity_date) AS login_date
    FROM
        Traffic
    WHERE
        activity = 'login'
    GROUP BY
        user_id
) t
WHERE
    DATEDIFF('2019-06-30', login_date) <= 90
    AND login_date <= '2019-06-30' -- Just in case there are future dates
GROUP BY
    login_date
ORDER BY
    login_date;
-- Solution:
