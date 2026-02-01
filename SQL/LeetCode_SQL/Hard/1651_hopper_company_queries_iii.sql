-- 1651. Hopper Company Queries III
-- Difficulty: Hard
-- Description:
-- Compute the average ride distance and average ride duration of every 3-month window in 2020.
-- Specifically, for each month 'm' from 1 to 10, calculate the average for the 3-month period [m, m+1, m+2].
-- Schema:
-- Table: Drivers
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | driver_id     | int     |
-- | join_date     | date    |
-- +---------------+---------+
-- driver_id is the primary key for this table.
-- 
-- Table: Rides
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | ride_id       | int     |
-- | user_id       | int     |
-- | requested_at  | date    |
-- +---------------+---------+
-- ride_id is the primary key for this table.
-- 
-- Table: AcceptedRides
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | ride_id       | int     |
-- | driver_id     | int     |
-- | ride_distance | int     |
-- | ride_duration | int     |
-- +---------------+---------+
-- ride_id is the primary key for this table.
-- Example Input/Output:
-- Output:
-- +-------+-----------------------+-----------------------+
-- | month | average_ride_distance | average_ride_duration |
-- +-------+-----------------------+-----------------------+
-- | 1     | 21.00                 | 46.67                 |
-- | 2     | 22.33                 | 44.00                 |
-- ...
-- +-------+-----------------------+-----------------------+
-- Solution:
WITH RECURSIVE Months AS (
    SELECT 1 AS month
    UNION ALL
    SELECT month + 1
    FROM Months
    WHERE month < 12
),
MonthlyStats AS (
    SELECT
        m.month,
        IFNULL(SUM(a.ride_distance), 0) AS total_distance,
        IFNULL(SUM(a.ride_duration), 0) AS total_duration
    FROM
        Months m
        LEFT JOIN Rides r ON MONTH(r.requested_at) = m.month AND YEAR(r.requested_at) = 2020
        LEFT JOIN AcceptedRides a ON r.ride_id = a.ride_id
    GROUP BY
        m.month
)
SELECT
    m.month,
    ROUND(IFNULL(SUM(s.total_distance) / 3, 0), 2) AS average_ride_distance,
    ROUND(IFNULL(SUM(s.total_duration) / 3, 0), 2) AS average_ride_duration
FROM
    Months m
    JOIN MonthlyStats s ON s.month BETWEEN m.month AND m.month + 2
WHERE
    m.month <= 10
GROUP BY
    m.month
ORDER BY
    m.month;
