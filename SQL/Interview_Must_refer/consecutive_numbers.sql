-- Solution for LeetCode 180: Consecutive Numbers

-- Approach 1: Three-way Join
-- We join the table with itself 3 times to find 3 consecutive IDs with the same number.
SELECT DISTINCT l1.num AS ConsecutiveNums
FROM Logs l1
JOIN Logs l2 ON l1.id = l2.id - 1
JOIN Logs l3 ON l2.id = l3.id - 1
WHERE l1.num = l2.num
  AND l2.num = l3.num;

-- Approach 2: Using Window Functions (LEAD/LAG)
-- This is often more efficient on larger datasets.
/*
SELECT DISTINCT num AS ConsecutiveNums
FROM (
    SELECT num,
           LEAD(num, 1) OVER (ORDER BY id) AS next_1,
           LEAD(num, 2) OVER (ORDER BY id) AS next_2
    FROM Logs
) t
WHERE num = next_1 AND num = next_2;
*/
