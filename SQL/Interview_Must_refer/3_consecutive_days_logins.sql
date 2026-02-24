-- Active: 1771836767231@@127.0.0.1@3306@practice_sql_db
/*
Problem: Find users with 3 or more consecutive days of logins.

Edge Cases Handled:
- Users logging in multiple times on the same day must be deduplicated.
- Users with more than 3 consecutive days must also be included.
- Must accurately handle month/year boundaries (built-in date functions handle this).

Schema & DML Data:
*/
USE practice_sql_db;

DROP TABLE IF EXISTS user_login_table;

CREATE TABLE user_login_table (
    user_id INT,
    login_date DATETIME
);

INSERT INTO
    user_login_table (user_id, login_date)
VALUES
    -- User 1: Has a 4-day streak (Should be included)
    (1, '2023-10-01 08:00:00'),
    (1, '2023-10-02 11:30:00'),
    (1, '2023-10-03 14:15:00'),
    (1, '2023-10-04 09:45:00'),
    -- User 2: Has a 3-day streak but logs in multiple times per day (Should be included, requires deduplication)    (2, '2023-10-10 09:00:00'),
    (2, '2023-10-10 18:00:00'),
    (2, '2023-10-11 12:00:00'),
    (2, '2023-10-12 10:30:00'),
    (2, '2023-10-12 21:00:00'),
    -- User 3: Gaps in logins, never reaches 3 consecutive days (Should NOT be included)
    (3, '2023-10-01 08:00:00'),
    (3, '2023-10-02 15:00:00'),
    (3, '2023-10-04 11:00:00'),
    -- User 4: Exactly a 3-day streak (Should be included)
    (4, '2023-10-29 08:00:00'),
    (4, '2023-10-30 09:00:00'),
    (4, '2023-10-31 10:00:00');

-- ==========================================
-- APPROACH 1: Gaps and Islands (Recommended & Scalable)
-- Note: Written in standard MySQL dialect
-- ==========================================
-- Your Sol

-- Sol 1
with
    base as (
        SELECT user_id, DATE(login_date) as login_date
        FROM user_login_table
        WHERE
            1 = 1
            AND user_id is NOT NULL
    )
    -- base table 
,
    base2 as (
        SELECT
            user_id,
            login_date,
            LEAD(login_date) OVER (
                PARTITION BY
                    user_id
                ORDER BY login_date
            ) next_login_dt,
            LAG(login_date) OVER (
                PARTITION BY
                    user_id
                ORDER BY login_date
            ) prev_login_dt
        FROM base
        GROUP BY
            1,
            2
    )
    -- 
SELECT user_id, MAX(
        case
            when DATEDIFF(next_login_dt, login_date) = 1
            AND DATEDIFF(login_date, prev_login_dt) = 1 THEN 1
            ELSE 0
        END
    ) AS streak_flag
FROM base2
GROUP BY
    1

-- Sol 2
with
    base as (
        SELECT *, ROW_NUMBER() OVER (
                PARTITION BY
                    user_id
                ORDER BY login_date
            ) login_dt_rank, DATE(
                DATE_SUB(
                    login_date, INTERVAL ROW_NUMBER() OVER (
                        PARTITION BY
                            user_id
                        ORDER BY login_date
                    ) DAY
                )
            ) date_sub
        FROM user_login_table
    )
    --
SELECT user_id, date_sub, count(*) as streak
FROM base
GROUP BY
    1,
    2
HAVING
    streak >= 3
    --

-- Solutions Provided
-- WITH
--     deduplicated_logins AS (
--         SELECT DISTINCT
--             user_id,
--             CAST(login_date AS DATE) AS login_date
--         FROM user_login_table
--     ),
--     island_groups AS (
--         SELECT
--             user_id,
--             login_date,
--             -- Subtract Row Number from Date to get the anchor 'Group Date'.
--             -- (If days are consecutive, subtracting the increasing row number yields the same anchor date)
--             DATE_SUB(
--                 login_date,
--                 INTERVAL ROW_NUMBER() OVER (
--                     PARTITION BY
--                         user_id
--                     ORDER BY login_date ASC
--                 ) DAY
--             ) AS streak_group
--         FROM deduplicated_logins
--     )
-- SELECT DISTINCT
--     user_id
-- FROM island_groups
-- GROUP BY
--     user_id,
--     streak_group
-- HAVING
--     COUNT(*) >= 3;

-- ==========================================
-- APPROACH 2: The LEAD() Method
-- ==========================================
-- WITH
--     deduplicated_logins AS (
--         SELECT DISTINCT
--             user_id,
--             CAST(login_date AS DATE) AS login_date
--         FROM user_login_table
--     ),
--     lead_dates AS (
--         SELECT
--             user_id,
--             login_date,
--             -- Look exactly 2 rows ahead chronologically
--             LEAD(login_date, 2) OVER (
--                 PARTITION BY
--                     user_id
--                 ORDER BY login_date ASC
--             ) AS login_date_in_2_rows
--         FROM deduplicated_logins
--     )
-- SELECT DISTINCT
--     user_id
-- FROM lead_dates
--     -- If the date 2 rows ahead is exactly 2 days ahead, it represents an unbroken 3-day sequence
-- WHERE
--     DATEDIFF(
--         login_date_in_2_rows,
--         login_date
--     ) = 2;

-- -- ==========================================
-- -- APPROACH 3: Self-Joins (Legacy / Pre-Window Functions)
-- -- ==========================================
-- WITH
--     deduplicated_logins AS (
--         SELECT DISTINCT
--             user_id,
--             CAST(login_date AS DATE) AS login_date
--         FROM user_login_table
--     )
-- SELECT DISTINCT
--     t1.user_id
-- FROM
--     deduplicated_logins t1
--     JOIN deduplicated_logins t2 ON t1.user_id = t2.user_id
--     AND t2.login_date = DATE_ADD(t1.login_date, INTERVAL 1 DAY)
--     JOIN deduplicated_logins t3 ON t1.user_id = t3.user_id
--     AND t3.login_date = DATE_ADD(t1.login_date, INTERVAL 2 DAY);