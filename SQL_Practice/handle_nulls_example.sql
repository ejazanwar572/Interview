-- Handling NULLs in LEAD and LAG
-- Option 1: Use the 3rd argument of LEAD/LAG to specify a default value (e.g., 0 or -1)
SELECT 
    Id, 
    Num,
    LEAD(Num, 1, 0) OVER (ORDER BY Id) AS next_num, -- Returns 0 instead of NULL
    LAG(Num, 1, 0) OVER (ORDER BY Id) AS prev_num   -- Returns 0 instead of NULL
FROM `interview_practice.Logs`;

-- Option 2: Use IFNULL or COALESCE on the result
SELECT 
    Id, 
    Num,
    IFNULL(LEAD(Num) OVER (ORDER BY Id), 0) AS next_num_explicit,
    COALESCE(LAG(Num) OVER (ORDER BY Id), 0) AS prev_num_explicit
FROM `interview_practice.Logs`;
