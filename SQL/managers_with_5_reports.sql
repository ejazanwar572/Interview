-- Solution for LeetCode 570: Managers with at Least 5 Direct Reports

-- Approach 1: Using JOIN and GROUP BY
-- We count the number of reports for each managerId and join with Employee to get the name.
SELECT Name
FROM Employee AS t1 
JOIN (
    SELECT ManagerId
    FROM Employee
    GROUP BY ManagerId
    HAVING COUNT(Id) >= 5
) AS t2 ON t1.Id = t2.ManagerId;

-- Approach 2: Subquery with IN (Often cleaner)
-- SELECT name 
-- FROM Employee 
-- WHERE id IN (
--     SELECT managerId 
--     FROM Employee 
--     GROUP BY managerId 
--     HAVING COUNT(*) >= 5
-- );
