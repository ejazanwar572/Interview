-- 2159. Order Two Columns Independently
-- Difficulty: Medium
-- Description:
--     - Database
-- 
-- ## Description
-- 
-- Table: Data
-- 
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | first_col   | int  |
-- | second_col  | int  |
-- +-------------+------+
-- This table may contain duplicate rows.
-- 
-- Write a solution to independently:
-- 
-- 	- order first_col in ascending order.
-- 	- order second_col in descending order.
-- 
-- The result format is in the following example.
-- 
-- Example 1:
-- 
-- Input:
-- Data table:
-- +-----------+------------+
-- | first_col | second_col |
-- +-----------+------------+
-- | 4         | 2          |
-- | 2         | 3          |
-- | 3         | 1          |
-- | 1         | 4          |
-- +-----------+------------+
-- Output:
-- +-----------+------------+
-- | first_col | second_col |
-- +-----------+------------+
-- | 1         | 4          |
-- | 2         | 3          |
-- | 3         | 2          |
-- | 4         | 1          |
-- +-----------+------------+
-- 
-- Solution:
# Write your MySQL query statement below
WITH
    S AS (
        SELECT
            first_col,
            ROW_NUMBER() OVER (ORDER BY first_col) AS rk
        FROM Data
    ),
    T AS (
        SELECT
            second_col,
            ROW_NUMBER() OVER (ORDER BY second_col DESC) AS rk
        FROM Data
    )
SELECT first_col, second_col
FROM
    S
    JOIN T USING (rk);
