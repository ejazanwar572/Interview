-- 1369. Get the Second Most Recent Activity
-- Difficulty: Hard
-- Description:
-- Write an SQL query to show the second most recent activity of each user. If the user only has one activity, return that one.
-- A user cannot perform more than one activity at the same time.
-- Return the result table in any order.
-- Schema:
-- Table: UserActivity
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | username      | varchar |
-- | activity      | varchar |
-- | startDate     | Date    |
-- | endDate       | Date    |
-- +---------------+---------+
-- This table does not contain a primary key.
-- A person with username performed an activity from startDate to endDate.
-- Example Input/Output:
-- UserActivity table:
-- +------------+--------------+-------------+-------------+
-- | username   | activity     | startDate   | endDate     |
-- +------------+--------------+-------------+-------------+
-- | Alice      | Travel       | 2020-02-12  | 2020-02-20  |
-- | Alice      | Dancing      | 2020-02-21  | 2020-02-23  |
-- | Alice      | Travel       | 2020-02-24  | 2020-02-28  |
-- | Bob        | Travel       | 2020-02-11  | 2020-02-18  |
-- +------------+--------------+-------------+-------------+
-- Result table:
-- +------------+--------------+-------------+-------------+
-- | username   | activity     | startDate   | endDate     |
-- +------------+--------------+-------------+-------------+
-- | Alice      | Dancing      | 2020-02-21  | 2020-02-23  |
-- | Bob        | Travel       | 2020-02-11  | 2020-02-18  |
-- +------------+--------------+-------------+-------------+
-- Solution:
WITH RankedActivities AS (
    SELECT
        username,
        activity,
        startDate,
        endDate,
        ROW_NUMBER() OVER (PARTITION BY username ORDER BY startDate DESC) AS rn,
        COUNT(*) OVER (PARTITION BY username) AS total_activities
    FROM
        UserActivity
)
SELECT
    username,
    activity,
    startDate,
    endDate
FROM
    RankedActivities
WHERE
    rn = 2
    OR total_activities = 1;
