-- Solution for "Consecutive Numbers"
-- Objective: Find all numbers that appear at least three times consecutively.

SELECT DISTINCT num AS ConsecutiveNums
FROM (
    SELECT 
        num,
        -- Look at the next number
        LEAD(num, 1) OVER (ORDER BY id) AS next_1,
        -- Look at the number after that
        LEAD(num, 2) OVER (ORDER BY id) AS next_2
    FROM 
        `interview_practice.Logs`
)
WHERE 
    num = next_1 
    AND num = next_2;
