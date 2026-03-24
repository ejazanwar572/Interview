/*
Problem Description:
Identify 'Power Users'. A power user is defined as a user who has logged in on at least 10 distinct days within any 30-day rolling window.

Sample Input:
user_logins table:
+---------+---------------------+
| user_id | login_timestamp     |
+---------+---------------------+
| 1       | 2023-10-01 10:00:00 |
| 1       | 2023-10-02 11:00:00 |
... (assume user 1 logs in exactly 10 times in Oct)
| 2       | 2023-10-01 10:00:00 |
| 2       | 2023-10-15 11:00:00 |
+---------+---------------------+

Sample Output:
+---------+
| user_id |
+---------+
| 1       |
+---------+
*/

-- DDL and DML
DROP TABLE IF EXISTS user_logins;
CREATE TABLE user_logins (
    user_id INT,
    login_timestamp DATETIME
);

INSERT INTO user_logins (user_id, login_timestamp) VALUES
(1, '2023-10-01 10:00:00'),
(1, '2023-10-02 11:00:00'),
(1, '2023-10-05 09:00:00'),
(1, '2023-10-06 14:00:00'),
(1, '2023-10-09 16:00:00'),
(1, '2023-10-10 18:00:00'),
(1, '2023-10-12 20:00:00'),
(1, '2023-10-15 22:00:00'),
(1, '2023-10-18 23:00:00'),
(1, '2023-10-25 10:00:00'),
(2, '2023-10-01 10:00:00'),
(2, '2023-10-15 11:00:00');

/*
Problem Solving Approach:
1. Reduce timestamps to distinct dates per user.
2. Since we need to check if there are 10 distinct days within a 30-day window, we can use window functions.
3. Order the distinct login dates for each user.
4. Using `LEAD(login_date, 9)`, we can peek at the 10th login date (since the current row is the 1st).
5. Calculate the difference in days using `DATEDIFF(LEAD(login_date, 9), login_date)`.
6. If the difference is <= 29 days (meaning 30-day inclusive window), then they are a power user.
*/

-- Optimized Solution
WITH DistinctDays AS (
    SELECT DISTINCT user_id, DATE(login_timestamp) as login_date
    FROM user_logins
),
LoginSequences AS (
    SELECT 
        user_id,
        login_date,
        LEAD(login_date, 9) OVER(PARTITION BY user_id ORDER BY login_date) as tenth_login_date
    FROM DistinctDays
)
SELECT DISTINCT user_id
FROM LoginSequences
WHERE tenth_login_date IS NOT NULL 
  AND DATEDIFF(tenth_login_date, login_date) <= 29;
