/*
Problem Description:
Calculate the number of days since each user's last login, considering today's date as '2023-11-01'.

Sample Input:
user_activity table:
+---------+------------+
| user_id | login_date |
+---------+------------+
| 1       | 2023-10-25 |
| 1       | 2023-10-30 |
| 2       | 2023-09-15 |
| 3       | 2023-10-31 |
+---------+------------+

Sample Output:
+---------+-----------------------+
| user_id | days_since_last_login |
+---------+-----------------------+
| 1       | 2                     |
| 2       | 47                    |
| 3       | 1                     |
+---------+-----------------------+
*/

-- DDL and DML
DROP TABLE IF EXISTS user_activity;
CREATE TABLE user_activity (
    user_id INT,
    login_date DATE
);

INSERT INTO user_activity (user_id, login_date) VALUES
(1, '2023-10-25'),
(1, '2023-10-30'),
(2, '2023-09-15'),
(3, '2023-10-31');

/*
Problem Solving Approach:
1. Group the records by `user_id` to compute the `MAX(login_date)` per user.
2. Calculate the difference between the target date ('2023-11-01' or `CURRENT_DATE()` in real cases) and their maximum login date.
3. Use `DATEDIFF(target_date, last_login_date)` for the scalar difference in days.
*/

-- Optimized Solution
SELECT 
    user_id,
    DATEDIFF('2023-11-01', MAX(login_date)) as days_since_last_login
FROM user_activity
GROUP BY user_id
ORDER BY days_since_last_login;
