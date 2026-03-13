/*
### Problem Description
Write a query to report the sum of all total investment values (`tiv_2016`), for all policyholders who:
1. Have the same `tiv_2015` value as one or more other policyholders, and
2. Are not located in the same city as any other policyholder (i.e., the `(lat, lon)` attribute pairs must be unique).

Round `tiv_2016` to two decimal places.

### Sample Input and Output
**Input: Insurance**
| pid | tiv_2015 | tiv_2016 | lat | lon |
|---|---|---|---|---|
| 1 | 10 | 5 | 10 | 10 |
| 2 | 20 | 20 | 20 | 20 |
| 3 | 10 | 30 | 20 | 20 |
| 4 | 10 | 40 | 40 | 40 |

**Output:**
| tiv_2016 |
|---|
| 45.00 |

*Explanation:* 
- pid 1 and pid 4 share the same `tiv_2015` value (10). Notice pid 3 also shares this value. So they all meet condition 1.
- pid 3 resides in identical lat/lon location as pid 2. Thus pid 3 and pid 2 fail condition 2.
- The only valid policyholders remaining are pid 1 and pid 4. Summing their 2016 TIVs: 5 + 40 = 45.
*/

-- DDL and DML commands
DROP TABLE IF EXISTS Insurance;
CREATE TABLE Insurance (
    pid INT,
    tiv_2015 FLOAT,
    tiv_2016 FLOAT,
    lat FLOAT,
    lon FLOAT
);

INSERT INTO Insurance (pid, tiv_2015, tiv_2016, lat, lon) VALUES
(1, 10, 5, 10, 10),
(2, 20, 20, 20, 20),
(3, 10, 30, 20, 20),
(4, 10, 40, 40, 40);


/*
### Approach
This is a classic LeetCode problem (LeetCode 585). 
We can use window functions to dynamically count occurrences of specific values to fulfill the conditions.
Condition 1: `COUNT(pid) OVER (PARTITION BY tiv_2015) > 1` (shares 2015 TIV with at least 1 other).
Condition 2: `COUNT(pid) OVER (PARTITION BY lat, lon) = 1` (unique geographic location).

Once bounded in a CTE, we apply the two conditions to the `WHERE` clause and sum the resulting 2016 TIV values.
*/










-- Optimized Solution
WITH AnalyzedInsurance AS (
    SELECT 
        pid,
        tiv_2015,
        tiv_2016,
        COUNT(pid) OVER (PARTITION BY tiv_2015) AS shared_2015_count,
        COUNT(pid) OVER (PARTITION BY lat, lon) AS location_count
    FROM Insurance
)
SELECT ROUND(CAST(SUM(tiv_2016) AS DECIMAL(10,2)), 2) AS tiv_2016
FROM AnalyzedInsurance
WHERE shared_2015_count > 1 
  AND location_count = 1;
