-- 1501. Countries You Can Safely Invest In
-- Difficulty: Medium
-- Description:
-- A country is considered safe to invest in if the average call duration of the calls from that country is strictly greater than the global average call duration.
-- Find all such countries.
-- Schema:
-- Table: Person
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | name          | varchar |
-- | phone_number  | varchar |
-- +---------------+---------+
-- id is the primary key for this table.
-- 
-- Table: Country
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | name          | varchar |
-- | country_code  | varchar |
-- +---------------+---------+
-- country_code is the primary key for this table.
-- 
-- Table: Calls
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | caller_id     | int     |
-- | callee_id     | int     |
-- | duration      | int     |
-- +---------------+---------+
-- No primary key.
-- Example Input/Output:
-- Person table:
-- +----+-------+--------------+
-- | id | name  | phone_number |
-- +----+-------+--------------+
-- | 1  | Jonathan | 051-1234567 |
-- | 2  | Elvis    | 051-7654321 |
-- +----+-------+--------------+
-- Country table:
-- +----------+--------------+
-- | name     | country_code |
-- +----------+--------------+
-- | Peru     | 051          |
-- +----------+--------------+
-- Output:
-- +---------+
-- | country |
-- +---------+
-- | Peru    |
-- +---------+
-- Solution:
WITH GlobalAvg AS (
    SELECT AVG(duration) AS avg_duration FROM Calls
),
PersonCountry AS (
    SELECT
        p.id,
        c.name AS country_name
    FROM
        Person p
        JOIN Country c ON LEFT(p.phone_number, 3) = c.country_code
),
CountryDuration AS (
    SELECT
        pc.country_name,
        AVG(c.duration) AS country_avg
    FROM
        Calls c
        JOIN PersonCountry pc ON c.caller_id = pc.id OR c.callee_id = pc.id
    GROUP BY
        pc.country_name
)
SELECT
    cd.country_name AS country
FROM
    CountryDuration cd
    JOIN GlobalAvg ga
WHERE
    cd.country_avg > ga.avg_duration;
