/*
Problem Description:
Write a SQL query to find all users who have logged in for at least 3 consecutive days.

Sample Input:
logins table:
+---------+------------+
| user_id | login_date |
+---------+------------+
| 1       | 2023-10-01 |
| 1       | 2023-10-02 |
| 1       | 2023-10-03 |
| 1       | 2023-10-05 |
| 2       | 2023-10-01 |
| 2       | 2023-10-02 |
| 3       | 2023-10-05 |
| 3       | 2023-10-06 |
| 3       | 2023-10-07 |
| 3       | 2023-10-08 |
+---------+------------+

Sample Output:
+---------+
| user_id |
+---------+
| 1       |
| 3       |
+---------+
*/

-- DDL and DML
DROP TABLE IF EXISTS logins;
CREATE TABLE logins (
    user_id INT,
    login_date DATE
);

INSERT INTO logins (user_id, login_date) VALUES
(1, '2023-10-01'),
(1, '2023-10-02'),
(1, '2023-10-03'),
(1, '2023-10-05'),
(2, '2023-10-01'),
(2, '2023-10-02'),
(3, '2023-10-05'),
(3, '2023-10-06'),
(3, '2023-10-07'),
(3, '2023-10-08');

/*
Problem Solving Approach:
1. Ensure distinct logins to avoid duplicate dates for the same user on the same day.
2. Use the "Islands and Gaps" technique: generate a `ROW_NUMBER()` ordered by `login_date` for each `user_id`.
3. Subtract the `ROW_NUMBER()` integer from the `login_date` using `DATE_SUB()`. Consecutive dates will yield the same result ("island" grouping ID).
4. Group by `user_id` and the grouping ID, using `HAVING COUNT(*) >= 3` to find streaks of at least 3 days.
*/

-- Optimized Solution
WITH DistinctLogins AS (
    SELECT DISTINCT user_id, login_date
    FROM logins
),
GroupedLogins AS (
    SELECT 
        user_id,
        login_date,
        ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY login_date) as rn,
        DATE_SUB(login_date, INTERVAL ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY login_date) DAY) as grp_date
    FROM DistinctLogins
)
SELECT DISTINCT user_id
FROM GroupedLogins
GROUP BY user_id, grp_date
HAVING COUNT(*) >= 3;
