-- 1127. User Purchase Platform
-- Difficulty: Hard
-- Table: Spending
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | user_id     | int     |
-- | spend_date  | date    |
-- | platform    | enum    |
-- | amount      | int     |
-- +-------------+---------+
-- The table logs the history of the spending of users that make purchases from an online shopping website which has a desktop and a mobile application.
-- (user_id, spend_date, platform) is the primary key of this table.
-- The platform column is an ENUM type of ('desktop', 'mobile').
-- Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only, and both mobile and desktop together for each date.
-- Example:
-- Input:
-- Spending table:
-- +---------+------------+----------+--------+
-- | user_id | spend_date | platform | amount |
-- +---------+------------+----------+--------+
-- | 1       | 2019-07-01 | mobile   | 100    |
-- | 1       | 2019-07-01 | desktop  | 100    |
-- | 2       | 2019-07-01 | mobile   | 100    |
-- | 2       | 2019-07-02 | mobile   | 100    |
-- | 3       | 2019-07-01 | desktop  | 100    |
-- | 3       | 2019-07-02 | desktop  | 100    |
-- +---------+------------+----------+--------+
-- Output:
-- +------------+----------+--------------+-------------+
-- | spend_date | platform | total_amount | total_users |
-- +------------+----------+--------------+-------------+
-- | 2019-07-01 | desktop  | 100          | 1           |
-- | 2019-07-01 | mobile   | 100          | 1           |
-- | 2019-07-01 | both     | 200          | 1           |
-- | 2019-07-02 | desktop  | 100          | 1           |
-- | 2019-07-02 | mobile   | 100          | 1           |
-- | 2019-07-02 | both     | 0            | 0           |
-- +------------+----------+--------------+-------------+
WITH UserDailySpend AS (
    SELECT
        spend_date,
        user_id,
        SUM(CASE WHEN platform = 'mobile' THEN amount ELSE 0 END) AS mobile_amount,
        SUM(CASE WHEN platform = 'desktop' THEN amount ELSE 0 END) AS desktop_amount
    FROM
        Spending
    GROUP BY
        spend_date,
        user_id
),
UserPlatformCat AS (
    SELECT
        spend_date,
        user_id,
        CASE
            WHEN mobile_amount > 0 AND desktop_amount > 0 THEN 'both'
            WHEN mobile_amount > 0 THEN 'mobile'
            ELSE 'desktop'
        END AS platform,
        (mobile_amount + desktop_amount) AS total_amount
    FROM
        UserDailySpend
),
AllDates AS (
    SELECT DISTINCT spend_date FROM Spending
),
AllPlatforms AS (
    SELECT 'desktop' AS platform UNION ALL
    SELECT 'mobile' UNION ALL
    SELECT 'both'
),
Template AS (
    SELECT d.spend_date, p.platform
    FROM AllDates d CROSS JOIN AllPlatforms p
)
SELECT
    t.spend_date,
    t.platform,
    IFNULL(SUM(u.total_amount), 0) AS total_amount,
    COUNT(u.user_id) AS total_users
FROM
    Template t
    LEFT JOIN UserPlatformCat u ON t.spend_date = u.spend_date AND t.platform = u.platform
GROUP BY
    t.spend_date,
    t.platform
ORDER BY
    t.spend_date,
    t.platform;
-- Solution:
