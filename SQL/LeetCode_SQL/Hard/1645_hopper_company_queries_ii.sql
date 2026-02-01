-- 1645. Hopper Company Queries II
-- Difficulty: Hard
-- Description:
-- Write an SQL query to report the percentage of working drivers for each month of 2020.
-- The percentage of working drivers in a month is defined as:
-- (Number of drivers who accepted at least one ride during the month / Number of available drivers during the month) * 100.
-- Note: Available drivers are those who joined on or before the current month and have not left (the problem assumes no drivers leave).
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
-- +-------+--------------------+
-- | month | working_percentage |
-- +-------+--------------------+
-- | 1     | 50.00              |
-- | 2     | 0.00               |
-- ...
-- +-------+--------------------+
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
        COUNT(d.driver_id) AS available_drivers
    FROM
        Months m
        LEFT JOIN Drivers d ON YEAR(d.join_date) < 2020 OR (YEAR(d.join_date) = 2020 AND MONTH(d.join_date) <= m.month)
    GROUP BY
        m.month
),
WorkingDrivers AS (
    SELECT
        m.month,
        COUNT(DISTINCT a.driver_id) AS working_drivers
    FROM
        Months m
        JOIN Rides r ON MONTH(r.requested_at) = m.month AND YEAR(r.requested_at) = 2020
        JOIN AcceptedRides a ON r.ride_id = a.ride_id
    GROUP BY
        m.month
)
SELECT
    m.month,
    IFNULL(ROUND((wd.working_drivers / ad.available_drivers) * 100, 2), 0.00) AS working_percentage
FROM
    Months m
    LEFT JOIN ActiveDrivers ad ON m.month = ad.month
    LEFT JOIN WorkingDrivers wd ON m.month = wd.month
ORDER BY
    m.month;
