-- Alternative Solutions for "Consecutive Numbers" (Find numbers appearing at least 3 times consecutively)

-- Option 1: Using LEAD twice (Check next 1 and next 2)
-- This is often cleaner than checking prev and next, as it looks "forward" for a sequence.
SELECT DISTINCT Num
FROM (
    SELECT 
        Num,
        LEAD(Num, 1) OVER (ORDER BY Id) AS next_1,
        LEAD(Num, 2) OVER (ORDER BY Id) AS next_2
    FROM `interview_practice.Logs`
)
WHERE Num = next_1 AND Num = next_2;


-- Option 2: Self Joins (Standard SQL, no Window Functions)
-- Good for databases that don't support window functions, but generally slower on large data.
SELECT DISTINCT L1.Num
FROM `interview_practice.Logs` L1
JOIN `interview_practice.Logs` L2 ON L1.Id = L2.Id - 1
JOIN `interview_practice.Logs` L3 ON L2.Id = L3.Id - 1
WHERE L1.Num = L2.Num AND L2.Num = L3.Num;


-- Option 3: Gaps and Islands (Most Robust for "N" consecutive)
-- This creates a unique group ID for every sequence of identical numbers.
-- You can then simply filter for COUNT(*) >= 3.
WITH GroupedLogs AS (
    SELECT 
        Num,
        -- The difference between Row_Number and a Row_Number partitioned by Num 
        -- will be constant for consecutive sequences.
        ROW_NUMBER() OVER (ORDER BY Id) - 
        ROW_NUMBER() OVER (PARTITION BY Num ORDER BY Id) AS grp
    FROM `interview_practice.Logs`
)
SELECT DISTINCT Num
FROM GroupedLogs
GROUP BY Num, grp
HAVING COUNT(*) >= 3;
