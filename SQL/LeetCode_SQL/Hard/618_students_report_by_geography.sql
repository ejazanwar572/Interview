-- 618. Students Report By Geography
-- Difficulty: Hard
-- Table: Student
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | name        | varchar |
-- | continent   | varchar |
-- +-------------+---------+
-- Pivot the continent column in the Student table so that each name is sorted alphabetically and displayed underneath its corresponding continent.
-- The output headers should be America, Asia, and Europe.
SELECT
    MAX(CASE WHEN continent = 'America' THEN name END) AS America,
    MAX(CASE WHEN continent = 'Asia' THEN name END) AS Asia,
    MAX(CASE WHEN continent = 'Europe' THEN name END) AS Europe
FROM (
    SELECT
        name,
        continent,
        ROW_NUMBER() OVER (PARTITION BY continent ORDER BY name) AS rn
    FROM
        Student
) t
GROUP BY
    rn;
-- Solution:
