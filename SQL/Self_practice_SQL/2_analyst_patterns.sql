USE practice_sql_db;

-- =============================================
-- SECTION 2: Analyst Patterns (Retention, Funnels, Sessionization)
-- =============================================
/*
OBJECTIVE:
Solve common "Product Analyst" case study problems.

PROBLEMS:
1. Day 1 Retention:
- Calculate the Day 1 Retention Rate.
- Definition: Logic used to identify users who logged in the very next day after their signup.
- Formula: (Users who came back on Day 1 / Total Users signed up on Day 0)

2. Conversion Funnel:
- Calculate the conversion rate from 'view_item' -> 'add_to_cart' -> 'purchase'.
- Result should look like: Step, User_Count, Conversion_Rate.

3. Sessionization (Gaps & Islands) - CHALLENGE:
- Group user clicks into "Sessions".
- A new session starts if a user is inactive for more than 30 minutes.
- Assign a unique session_id to each group of clicks.
*/

-- ---------------------------------------------
-- Write your queries below:
-- ---------------------------------------------

-- 1. Day 1 Retention

-- 2. Conversion Funnel

-- 3. Sessionization (Gap of 30 mins)

-- =============================================
-- DDL: RESTORE TABLES (Run this block first)
-- =============================================
DROP TABLE IF EXISTS user_logins;

DROP TABLE IF EXISTS user_events;

DROP TABLE IF EXISTS clickstream;

-- 1. User Logins (For Retention)
CREATE TABLE user_logins (user_id INT, login_date DATE);

INSERT INTO
    user_logins
VALUES (1, '2024-01-01'), -- Signup
    (1, '2024-01-02'), -- Retained Day 1
    (1, '2024-01-05'),
    (2, '2024-01-01'), -- Signup
    (2, '2024-01-08'), -- Not Retained Day 1
    (3, '2024-01-02'), -- Signup
    (3, '2024-01-03');
-- Retained Day 1

-- 2. User Events (For Funnel)
CREATE TABLE user_events (
    user_id INT,
    event_name VARCHAR(50),
    event_time DATETIME
);

INSERT INTO
    user_events
VALUES (
        1,
        'view_item',
        '2024-01-01 10:00:00'
    ),
    (
        1,
        'add_to_cart',
        '2024-01-01 10:05:00'
    ),
    (
        1,
        'purchase',
        '2024-01-01 10:10:00'
    ), -- Converted
    (
        2,
        'view_item',
        '2024-01-01 11:00:00'
    ),
    (
        2,
        'add_to_cart',
        '2024-01-01 11:05:00'
    ), -- Dropped off
    (
        3,
        'view_item',
        '2024-01-01 12:00:00'
    );
-- Dropped off

-- 3. Clickstream (For Sessionization)
CREATE TABLE clickstream (
    user_id INT,
    click_time DATETIME
);

INSERT INTO
    clickstream
VALUES (1, '2024-01-01 08:00:00'),
    (1, '2024-01-01 08:05:00'), -- Session 1
    (1, '2024-01-01 08:29:00'), -- Session 1
    (1, '2024-01-01 09:15:00'), -- Session 2 (Gap > 30 mins)
    (1, '2024-01-01 09:18:00'), -- Session 2
    (2, '2024-01-01 10:00:00');