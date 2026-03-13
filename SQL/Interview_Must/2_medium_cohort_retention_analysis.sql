/*
================================================================================
Problem: Cohort Retention Analysis (Month-over-Month)
================================================================================
Difficulty: Hard
Pattern: Date Manipulation, CTEs, Self-Joins / Window Functions

Description:
You are given a `user_activity` table containing records of user logins. 
A user's "cohort month" is the month of their first-ever login.
Calculate the Month 1 retention rate for each cohort month.
The Month 1 retention rate is defined as the percentage of users in a cohort 
who logged in exactly one month after their cohort month, rounded to 2 decimal places.

Return the result organized by `cohort_month`.

================================================================================
Input constraints / Data examples:
================================================================================
Table: user_activity
+-----------+---------------+
| user_id   | activity_date |
+-----------+---------------+
| 1         | 2026-01-15    | -- Cohort: Jan 2026
| 1         | 2026-02-10    | -- Retained in Month 1 (Feb 2026)
| 2         | 2026-01-20    | -- Cohort: Jan 2026
| 3         | 2026-02-05    | -- Cohort: Feb 2026
| 3         | 2026-02-28    | -- Still Month 0
| 4         | 2026-01-05    | -- Cohort: Jan 2026
| 4         | 2026-03-15    | -- Logged in Month 2, NOT Month 1
+-----------+---------------+

Expected Output:
+--------------+-------------------+
| cohort_month | month_1_retention |
+--------------+-------------------+
| 2026-01-01   | 33.33             | -- 1 out of 3 Jan users retained in Feb
| 2026-02-01   | 0.00              | -- 0 out of 1 Feb users retained in Mar
+--------------+-------------------+
*/


================================================================================
DDL & DML (For Testing)
================================================================================

DROP TABLE IF EXISTS user_activity;
CREATE TABLE user_activity (
    user_id INT,
    activity_date DATE
);

INSERT INTO user_activity (user_id, activity_date) VALUES
(1, '2026-01-15'),
(1, '2026-02-10'),
(2, '2026-01-20'),
(3, '2026-02-05'),
(3, '2026-02-28'),
(4, '2026-01-05'),
(4, '2026-03-15'),
(5, '2026-01-28'),
(5, '2026-02-02'),
(5, '2026-03-01'),
(6, '2026-02-10'),
(6, '2026-03-08'),
(7, '2026-03-01'),
(7, '2026-04-05');


-- ==========================================
-- Your Solution Here
-- ==========================================


with cohorts as 
(SELECT user_id ,min(DATE_FORMAT(activity_date,'%Y-%m-01')) as cohort_month
FROM user_activity
GROUP BY 1
)
--
SELECT a.cohort_month , count(DISTINCT b.user_id) ret_users , count(DISTINCT a.user_id) tot_users    
FROM cohorts a
LEFT JOIN user_activity b ON a.user_id = b.user_id 
AND DATE_FORMAT(activity_date,'%Y-%m-01') = DATE_ADD(cohort_month,INTERVAL 1 Month)
GROUP BY 1
ORDER BY 1 


-- ==========================================
-- Provided Solution
-- ==========================================

WITH cohort AS (
    SELECT 
        user_id,
        MIN(DATE_FORMAT(activity_date, '%Y-%m-01')) AS cohort_month
    FROM user_activity
    GROUP BY user_id
),
monthly_activity AS (
    SELECT DISTINCT
        user_id,
        DATE_FORMAT(activity_date, '%Y-%m-01') AS activity_month
    FROM user_activity
)
SELECT 
    c.cohort_month,
    ROUND(
        100.0 * SUM(CASE WHEN m.activity_month = DATE_ADD(c.cohort_month, INTERVAL 1 MONTH) THEN 1 ELSE 0 END) 
        / COUNT(DISTINCT c.user_id), 
        2
    ) AS month_1_retention
FROM cohort c
LEFT JOIN monthly_activity m
    ON c.user_id = m.user_id
    AND m.activity_month = DATE_ADD(c.cohort_month, INTERVAL 1 MONTH)
GROUP BY c.cohort_month
ORDER BY c.cohort_month;

