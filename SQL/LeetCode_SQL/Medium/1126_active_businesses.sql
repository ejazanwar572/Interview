-- 1126. Active Businesses
-- Difficulty: Medium
-- Table: Events
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | business_id   | int     |
-- | event_type    | varchar |
-- | occurrences   | int     |
-- +---------------+---------+
-- (business_id, event_type) is the primary key of this table.
-- An active business is a business that has more than one event type with occurrences greater than the average occurrences of that event type among all businesses.
-- Write an SQL query to find all active businesses.
-- Example:
-- Input:
-- Events table:
-- +-------------+------------+-------------+
-- | business_id | event_type | occurrences |
-- +-------------+------------+-------------+
-- | 1           | reviews    | 7           |
-- | 3           | reviews    | 3           |
-- | 1           | ads        | 11          |
-- | 2           | ads        | 7           |
-- | 3           | ads        | 6           |
-- | 1           | page views | 3           |
-- | 2           | page views | 12          |
-- +-------------+------------+-------------+
-- Output:
-- +-------------+
-- | business_id |
-- +-------------+
-- | 1           |
-- +-------------+
-- Explanation:
-- Average for 'reviews': (7+3)/2 = 5
-- Average for 'ads': (11+7+6)/3 = 8
-- Average for 'page views': (3+12)/2 = 7.5
-- Business 1: reviews (7 > 5), ads (11 > 8), page views (3 < 7.5). Two events > avg. Active.
-- Business 2: ads (7 < 8), page views (12 > 7.5). One event > avg. inactive.
-- Business 3: reviews (3 < 5), ads (6 < 8). Zero events > avg. inactive.
WITH AvgOccurrences AS (
    SELECT
        event_type,
        AVG(occurrences) AS avg_occ
    FROM
        Events
    GROUP BY
        event_type
)
SELECT
    e.business_id
FROM
    Events e
    JOIN AvgOccurrences a ON e.event_type = a.event_type
WHERE
    e.occurrences > a.avg_occ
GROUP BY
    e.business_id
HAVING
    COUNT(DISTINCT e.event_type) > 1;
-- Solution:
