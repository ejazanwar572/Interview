/*
Problem Description:
Identify "resurrected" users - users who logged in, were inactive for at least 30 days, and then logged in again.

Sample Input:
logins table:
+---------+------------+
| user_id | login_date |
+---------+------------+
| 1       | 2023-01-01 |
| 1       | 2023-01-15 |
| 1       | 2023-03-01 |
| 2       | 2023-02-01 |
| 2       | 2023-02-10 |
+---------+------------+

Sample Output:
+---------+----------------+
| user_id | resurrect_date |
+---------+----------------+
| 1       | 2023-03-01     |
+---------+----------------+
*/

-- DDL and DML
DROP TABLE IF EXISTS logins;
CREATE TABLE logins (
    user_id INT,
    login_date DATE
);

INSERT INTO logins (user_id, login_date) VALUES
(1, '2023-01-01'),
(1, '2023-01-15'),
(1, '2023-03-01'),
(2, '2023-02-01'),
(2, '2023-02-10');

/*
Problem Solving Approach:
1. First, ensure dates are distinct by user and order them sequentially using `LAG()`.
2. Compute `DATEDIFF(login_date, prev_login_date)` to find the gap between sequential logins.
3. Filter out rows where this difference is greater than or equal to 30.
*/

-- Optimized Solution
WITH DistinctLogins AS (
    SELECT DISTINCT user_id, login_date
    FROM logins
),
LaggedLogins AS (
    SELECT 
        user_id,
        login_date,
        LAG(login_date) OVER(PARTITION BY user_id ORDER BY login_date) as prev_login_date
    FROM DistinctLogins
)
SELECT 
    user_id,
    login_date as resurrect_date
FROM LaggedLogins
WHERE prev_login_date IS NOT NULL 
AND DATEDIFF(login_date, prev_login_date) >= 30;
