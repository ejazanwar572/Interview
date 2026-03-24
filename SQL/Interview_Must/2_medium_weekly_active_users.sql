/*
Problem Description:
Calculate the Weekly Active Users (WAU) - the distinct number of users active per week.

Sample Input:
user_activity table:
+---------+------------+
| user_id | login_date |
+---------+------------+
| 1       | 2023-01-02 |
| 1       | 2023-01-05 |
| 2       | 2023-01-06 |
| 3       | 2023-01-09 |
| 4       | 2023-01-11 |
+---------+------------+

Sample Output:
+----------+-------------+-----+
| act_year | act_week    | wau |
+----------+-------------+-----+
| 2023     | 1           | 2   |
| 2023     | 2           | 2   |
+----------+-------------+-----+
*/

-- DDL and DML
DROP TABLE IF EXISTS user_activity;
CREATE TABLE user_activity (
    user_id INT,
    login_date DATE
);

INSERT INTO user_activity (user_id, login_date) VALUES
(1, '2023-01-02'),
(1, '2023-01-05'),
(2, '2023-01-06'),
(3, '2023-01-09'),
(4, '2023-01-11');

/*
Problem Solving Approach:
1. Extract the `YEAR` and `WEEK` from the `login_date` using MySQL functions `YEAR()` and `WEEK()`.
   (Note: `WEEK(date, 1)` uses Monday as the first day of the week).
2. Group the data by both `YEAR` and `WEEK`.
3. Count the `DISTINCT user_id` for each grouping to determine WAU.
*/

-- Optimized Solution
SELECT 
    YEAR(login_date) as act_year,
    WEEK(login_date, 1) as act_week,
    COUNT(DISTINCT user_id) as wau
FROM user_activity
GROUP BY YEAR(login_date), WEEK(login_date, 1)
ORDER BY act_year, act_week;
