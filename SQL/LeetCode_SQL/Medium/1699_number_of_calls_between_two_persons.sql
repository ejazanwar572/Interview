-- 1699. Number of Calls Between Two Persons
-- Difficulty: Medium
-- Description:
-- Write an SQL query to report the number of calls and the total call duration between each pair of distinct persons (person1, person2) where person1 < person2.
-- Schema:
-- Table: Calls
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | from_id       | int     |
-- | to_id         | int     |
-- | duration      | int     |
-- +---------------+---------+
-- No primary key.
-- Example Input/Output:
-- Output:
-- +---------+---------+------------+----------------+
-- | person1 | person2 | call_count | total_duration |
-- +---------+---------+------------+----------------+
-- | 1       | 2       | 2          | 70             |
-- | 1       | 3       | 1          | 20             |
-- | 3       | 4       | 2          | 300            |
-- +---------+---------+------------+----------------+
-- Solution:
SELECT
    CASE
        WHEN from_id < to_id THEN from_id
        ELSE to_id
    END AS person1,
    CASE
        WHEN from_id < to_id THEN to_id
        ELSE from_id
    END AS person2,
    COUNT(*) AS call_count,
    SUM(duration) AS total_duration
FROM
    Calls
GROUP BY
    person1,
    person2
ORDER BY
    person1,
    person2;
