-- 571. Find Median Given Frequency of Numbers
-- Difficulty: Hard
-- 
-- Table: Numbers
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | num         | int  |
-- | frequency   | int  |
-- +-------------+------+
-- num is the primary key (column with unique values) for this table.
-- Each row of this table shows the frequency of a number in the database.
-- 
-- The median is the value separating the higher half from the lower half of a data sample.
-- Write a solution to report the median of all the numbers in the database after decompressing the Numbers table. Round the median to one decimal point.
-- Return the result table in any order.
/*
-- Example 1:
Input: 
Numbers table:
+-----+-----------+
| num | frequency |
+-----+-----------+
| 0   | 7         |
| 1   | 1         |
| 2   | 3         |
| 3   | 1         |
+-----+-----------+
Output: 
+--------+
| median |
+--------+
| 0.0    |
+--------+
Explanation: 
If we decompress the Numbers table, we will get [0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3], so the median is (0 + 0) / 2 = 0.
*/
-- Solution
WITH RecursiveDecoder AS (
    SELECT num, frequency, 1 AS cnt
    FROM Numbers
    UNION ALL
    SELECT num, frequency, cnt + 1
    FROM RecursiveDecoder
    WHERE cnt < frequency
),
OrderedNumbers AS (
    SELECT num, ROW_NUMBER() OVER(ORDER BY num) AS row_num, COUNT(*) OVER() AS total_count
    FROM RecursiveDecoder
)
SELECT ROUND(AVG(num), 1) AS median
FROM OrderedNumbers
WHERE row_num BETWEEN total_count / 2.0 AND total_count / 2.0 + 1;
-- Solution:
