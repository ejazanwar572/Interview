-- Solution for "Investments in 2016"
-- Objective: Calculate the sum of tiv_2016 for all policyholders who:
-- 1. Have the same tiv_2015 value as one or more other policyholders.
-- 2. Are not located at the same coordinates (lat, lon) as any other policyholder.

SELECT ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM `interview_practice.Insurance`
WHERE tiv_2015 IN (
    -- Condition 1: Shared tiv_2015
    SELECT tiv_2015
    FROM `interview_practice.Insurance`
    GROUP BY tiv_2015
    HAVING COUNT(*) > 1
)
AND (lat, lon) IN (
    -- Condition 2: Unique location
    SELECT lat, lon
    FROM `interview_practice.Insurance`
    GROUP BY lat, lon
    HAVING COUNT(*) = 1
);
