-- 1715. Count Apples and Oranges
-- Difficulty: Medium
-- Description:
-- Write an SQL query to count the total number of apples and oranges in all the boxes. If a box contains a chest, you should also count the apples and oranges in that chest.
-- Schema:
-- Table: Boxes
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | box_id        | int     |
-- | chest_id      | int     |
-- | apple_count   | int     |
-- | orange_count  | int     |
-- +---------------+---------+
-- box_id is the primary key for this table.
-- chest_id is a foreign key to Chests table.
-- 
-- Table: Chests
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | chest_id      | int     |
-- | apple_count   | int     |
-- | orange_count  | int     |
-- +---------------+---------+
-- chest_id is the primary key for this table.
-- Example Input/Output:
-- Output:
-- +-------------+--------------+
-- | apple_count | orange_count |
-- +-------------+--------------+
-- | 151         | 123          |
-- +-------------+--------------+
-- Solution:
SELECT
    SUM(b.apple_count + IFNULL(c.apple_count, 0)) AS apple_count,
    SUM(b.orange_count + IFNULL(c.orange_count, 0)) AS orange_count
FROM
    Boxes b
    LEFT JOIN Chests c ON b.chest_id = c.chest_id;
