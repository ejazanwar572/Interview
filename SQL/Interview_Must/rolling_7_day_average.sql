-- Advanced SQL Challenge: 7-Day Rolling Average
-- Difficulty: Senior

/*
Problem Statement:
Calculate a 7-day rolling average of user sign-ups to smooth out daily volatility.

For any given day, the rolling average should be the average of the sign-ups 
on that day PLUS the preceding 6 days.

Edge Cases Handled:
- If a date has fewer than 6 preceding days recorded in the database, 
the average should compute correctly using only the available days in that window.

Example Input (DailySignups):
| signup_date | signup_count |
|-------------|--------------|
| 2023-01-01  | 10           |
| 2023-01-02  | 20           |
| 2023-01-03  | 15           |
| 2023-01-04  | 30           |
| 2023-01-05  | 25           |
| 2023-01-06  | 40           |
| 2023-01-07  | 35           |
| 2023-01-08  | 50           |

Expected Output:
| signup_date | signup_count | 7_day_rolling_avg |
|-------------|--------------|-------------------|
| 2023-01-01  | 10           | 10.00             |
| 2023-01-02  | 20           | 15.00             |
| 2023-01-03  | 15           | 15.00             |
| 2023-01-04  | 30           | 18.75             |
| 2023-01-05  | 25           | 20.00             |
| 2023-01-06  | 40           | 23.33             |
| 2023-01-07  | 35           | 25.00             |
| 2023-01-08  | 50           | 30.71             |

Schema & DML Data:
*/
USE practice_sql_db;

DROP TABLE IF EXISTS DailySignups;

CREATE TABLE DailySignups (
    signup_date DATE,
    signup_count INT
);

INSERT INTO
    DailySignups (signup_date, signup_count)
VALUES ('2023-01-01', 10),
    ('2023-01-02', 20),
    ('2023-01-03', 15),
    ('2023-01-04', 30),
    ('2023-01-05', 25),
    ('2023-01-06', 40),
    ('2023-01-07', 35), -- First full 7-day window. Avg: (10+20+15+30+25+40+35)/7 = 25
    ('2023-01-08', 50);
-- Next 7-day window. (Drops the 'Jan 1st' 10). Avg: (20+15+30+25+40+35+50)/7 = 30.7

-- ==========================================
-- Your Sol
-- ==========================================
SELECT signup_date , signup_count , AVG(signup_count) OVER(ORDER BY signup_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
FROM `DailySignups` a
GROUP BY 1,2
ORDER BY 1
-- LEFT JOIN `DailySignups` b ON a.signup_date >= b.signup_date - 6
-- ==========================================
-- Solutions Provided
-- ==========================================

/*
SELECT 
signup_date,
signup_count,
-- Calculate Average using a physical row window frame.
ROUND(
AVG(signup_count) OVER (
ORDER BY signup_date 
ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
), 
2) AS 7_day_rolling_avg
FROM DailySignups
ORDER BY signup_date;
*/