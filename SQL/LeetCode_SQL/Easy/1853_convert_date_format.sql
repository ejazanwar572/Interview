-- 1853. Convert Date Format
-- Difficulty: Easy
-- Description:
-- Write an SQL query to convert each date in Days into a string formatted as "day_name, month_name day, year".
-- Schema:
-- Table: Days
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | day         | date |
-- +-------------+------+
-- day is the primary key for this table.
-- Example Input/Output:
-- Output:
-- +-------------------------+
-- | day                     |
-- +-------------------------+
-- | Tuesday, April 12, 2022 |
-- | Monday, August 9, 2021  |
-- | Friday, June 26, 2020   |
-- +-------------------------+
-- Solution:
SELECT
    DATE_FORMAT(day, '%W, %M %e, %Y') AS day
FROM
    Days;
