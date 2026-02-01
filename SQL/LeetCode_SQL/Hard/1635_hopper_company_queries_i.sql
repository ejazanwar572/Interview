-- 1635. Hopper Company Queries I
-- Difficulty: Hard
-- Description:
-- Report the statistics for each month of 2020:
-- - Number of drivers active at the end of the month.
-- - Number of accepted rides in that month.
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
-- +-------+----------------+----------------+
-- | month | active_drivers | accepted_rides |
-- +-------+----------------+----------------+
-- | 1     | 2              | 5              |
-- | 2     | 3              | 2              |
-- +-------+----------------+----------------+
-- Solution:
WITH RECURSIVE Months AS (
    SELECT 1 AS month
    UNION ALL
    SELECT month + 1
    FROM Months
    WHERE month < 12
),
ActiveDrivers AS (
    SELECT
        m.month,
        COUNT(d.driver_id) AS active_drivers
    FROM
        Months m
        LEFT JOIN Drivers d ON YEAR(d.join_date) < 2020 OR (YEAR(d.join_date) = 2020 AND MONTH(d.join_date) <= m.month)
    GROUP BY
        m.month
),
AcceptedRidesForMonth AS (
    SELECT
        m.month,
        COUNT(a.ride_id) AS accepted_rides
    FROM
        Months m
        LEFT JOIN Rides r ON MONTH(r.requested_at) = m.month AND YEAR(r.requested_at) = 2020
        JOIN AcceptedRides a ON r.ride_id = a.ride_id
    GROUP BY
        m.month
)
SELECT
    ad.month,
    ad.active_drivers,
    IFNULL(ar.accepted_rides, 0) AS accepted_rides
FROM
    ActiveDrivers ad
    LEFT JOIN AcceptedRidesForMonth ar ON ad.month = ar.month
ORDER BY
    ad.month;
