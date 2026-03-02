/*
================================================================================
Problem: Active Subscriptions Per Day (Date Scaffolding)
================================================================================
Difficulty: Hard
Pattern: Recursive CTEs, Date Explosion, Range Joins

Description:
You have a `subscriptions` table tracking user subscription periods.
Each row contains a `user_id`, a `start_date`, and an `end_date`.
(If a user is still active, `end_date` might be NULL, but for this problem, 
assume we cap active subscriptions at today's date).

Write a query to generate a report showing the TOTAL number of active 
subscriptions for every single day in the month of March 2026.
If no users were active on a specific day, return 0 for that day.

Return columns: `calendar_date` and `active_users`, ordered by date.

================================================================================
Input constraints / Data examples:
================================================================================
Table: subscriptions
+---------+------------+------------+
| user_id | start_date | end_date   |
+---------+------------+------------+
| 1       | 2026-02-25 | 2026-03-02 | -- Active Mar 1 to Mar 2
| 2       | 2026-03-02 | 2026-03-04 | -- Active Mar 2 to Mar 4
| 3       | 2026-03-04 | 2026-03-04 | -- Active only Mar 4
+---------+------------+------------+

Expected Output (Partial):
+---------------+--------------+
| calendar_date | active_users |
+---------------+--------------+
| 2026-03-01    | 1            | (User 1)
| 2026-03-02    | 2            | (User 1, User 2)
| 2026-03-03    | 1            | (User 2)
| 2026-03-04    | 2            | (User 2, User 3)
| 2026-03-05    | 0            | (Nobody)
+---------------+--------------+
*/

-- ==========================================
-- Your Solution Here
-- ==========================================





-- ==========================================
-- Provided Solution
-- ==========================================
/*
-- Goal: Generate a daily calendar dynamically using a Recursive CTE, 
-- then LEFT JOIN the subscriptions table onto the calendar.

WITH RECURSIVE calendar AS (
    -- Anchor member
    SELECT CAST('2026-03-01' AS DATE) AS date_val
    UNION ALL
    -- Recursive member
    SELECT DATE_ADD(date_val, INTERVAL 1 DAY)
    FROM calendar
    WHERE date_val < '2026-03-31'
)
SELECT 
    c.date_val AS calendar_date,
    COUNT(s.user_id) AS active_users
FROM calendar c
LEFT JOIN subscriptions s
    ON c.date_val BETWEEN s.start_date AND s.end_date
GROUP BY c.date_val
ORDER BY c.date_val;
*/

/*
================================================================================
DDL & DML (For Testing)
================================================================================

CREATE TABLE subscriptions (
    user_id INT,
    start_date DATE,
    end_date DATE
);

INSERT INTO subscriptions (user_id, start_date, end_date) VALUES
(1, '2026-01-15', '2026-03-04'),
(2, '2026-02-28', '2026-03-02'),
(3, '2026-03-05', '2026-03-10'),
(4, '2026-03-15', '2026-03-20'),
(5, '2026-03-01', '2026-03-31'), -- Active all month
(6, '2026-02-01', '2026-02-28'), -- Never active in March
(7, '2026-03-30', '2026-04-05'),
(8, '2026-03-12', '2026-03-15'),
(9, '2026-03-14', '2026-03-14'), -- 1-day subscription
(10, '2026-03-25', '2026-04-10');
*/
