USE practice_sql_db;

-- =============================================
-- SECTION 3: Date & Time Manipulation
-- =============================================
/*
OBJECTIVE:
Handle dates, times, intervals, and consecutive day logic.

PROBLEMS:
1. Business Days Diff:
- Calculate the number of days between 'created_at' and 'resolved_at'.
- BUT exclude weekends (Saturday, Sunday).

2. Monthly Active Users (MAU):
- Calculate the number of distinct active users per month.
- Format the month as 'YYYY-MM'.

3. Consecutive Days (Self Join):
- Find users who logged in for 3 consecutive days.
- Hint: Use Lead/Lag or Self Joins on date math.
*/

-- ---------------------------------------------
-- Write your queries below:
-- ---------------------------------------------

-- 1. Business Days Calculation

-- 2. MAU (Monthly Active Users)

-- 3. Users with 3 Consecutive Days Login

-- =============================================
-- DDL: RESTORE TABLES (Run this block first)
-- =============================================
DROP TABLE IF EXISTS tickets;

DROP TABLE IF EXISTS active_users;

-- 1. Tickets (For Business Days)
CREATE TABLE tickets (
    ticket_id INT,
    created_at DATE,
    resolved_at DATE
);

INSERT INTO
    tickets
VALUES (1, '2024-01-01', '2024-01-05'), -- Mon to Fri (4 days diff)
    (2, '2024-01-05', '2024-01-08');
-- Fri to Mon (Includes Sat/Sun)

-- 2. Active Users (For MAU & Consecutive)
CREATE TABLE active_users (
    user_id INT,
    activity_date DATE
);

INSERT INTO
    active_users
VALUES (1, '2024-01-01'),
    (1, '2024-01-02'),
    (1, '2024-01-03'), -- 3 Consecutive
    (1, '2024-02-10'),
    (2, '2024-01-01'),
    (2, '2024-01-03'), -- Not Consecutive
    (2, '2024-01-05'),
    (3, '2024-01-01'),
    (3, '2024-01-02');