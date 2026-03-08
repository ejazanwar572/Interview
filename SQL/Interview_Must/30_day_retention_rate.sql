/*
================================================================================
Problem Description
================================================================================
Calculate 30-day retention: what percentage of users who signed up in a given 
cohort returned within 30 days? 
This tests: Cohort analysis, date arithmetic, joins across aggregated data.
*/

/*
================================================================================
Sample Input & Output Tables
================================================================================
Input Table: users
+---------+------------+
| user_id | created_at |
+---------+------------+
| 1       | 2023-01-05 |
| 2       | 2023-01-15 |
| 3       | 2023-02-10 |
+---------+------------+

Input Table: logins
+---------+------------+
| user_id | login_date |
+---------+------------+
| 1       | 2023-01-20 | -- Within 30 days of signup
| 1       | 2023-03-01 | -- Outside window
| 2       | 2023-03-05 | -- More than 30 days later
| 3       | 2023-02-15 | -- Within 30 days of signup
+---------+------------+

Output Table:
+--------------+-------------+----------------+----------------+
| cohort_month | total_users | retained_users | retention_rate |
+--------------+-------------+----------------+----------------+
| 2023-01-01   | 2           | 1              | 50.0           |
| 2023-02-01   | 1           | 1              | 100.0          |
+--------------+-------------+----------------+----------------+
*/

-- ================================================================================
-- DDL & DML Commands
-- ================================================================================

DROP TABLE IF EXISTS users ;

CREATE  TABLE users (
    user_id INT,
    created_at DATE
);

DROP TABLE IF EXISTS logins;

CREATE TABLE logins (
    user_id INT,
    login_date DATE
);

INSERT INTO users (user_id, created_at) VALUES 
(1, '2023-01-05'),
(2, '2023-01-15'),
(3, '2023-02-10');

INSERT INTO logins (user_id, login_date) VALUES 
(1, '2023-01-20'),
(1, '2023-03-01'),
(2, '2023-03-05'),
(3, '2023-02-15');

/*
================================================================================
Approach / Problem Solving Ideas
================================================================================
Step 1: Get the signup date for each user using a CTE.
Step 2: Check if that user also has a login within 30 days of their signup.
Step 3: Group by signup cohort (by month), count total users and retained users.
Retention rate = retained / total.

Note: Cohort retention is a very common analytics question. The key design choice 
is defining what 'retention' means — confirm whether it means any login within 30 
days, or logging in at least once in the 30th-day window specifically. Use a LEFT 
JOIN so that users who didn't return still appear in the denominator.
*/







-- ================================================================================
-- Optimized Solution
-- ================================================================================
WITH cohort AS (
  SELECT user_id, MIN(created_at) AS signup_date
  FROM users
  GROUP BY user_id
),
retained AS (
  SELECT c.user_id
  FROM cohort c
  JOIN logins l ON c.user_id = l.user_id
  WHERE l.login_date BETWEEN c.signup_date + INTERVAL '1 day'
    AND c.signup_date + INTERVAL '30 days'
)
SELECT
  DATE_TRUNC('month', c.signup_date) AS cohort_month,
  COUNT(DISTINCT c.user_id) AS total_users,
  COUNT(DISTINCT r.user_id) AS retained_users,
  ROUND(100.0 * COUNT(DISTINCT r.user_id) / COUNT(DISTINCT c.user_id), 1) AS retention_rate
FROM cohort c
LEFT JOIN retained r ON c.user_id = r.user_id
GROUP BY 1
ORDER BY 1;
