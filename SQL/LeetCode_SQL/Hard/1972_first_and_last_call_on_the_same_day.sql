-- 1972. First and Last Call On the Same Day
-- Difficulty: Hard
-- Description:
-- Write an SQL query to report the IDs of the users whose first and last calls on any day were with the same person. Calls are counted regardless of being the caller or the recipient.
-- Schema:
-- Table: Calls
-- +--------------+----------+
-- | Column Name  | Type     |
-- +--------------+----------+
-- | caller_id    | int      |
-- | recipient_id | int      |
-- | call_time    | datetime |
-- +--------------+----------+
-- (caller_id, recipient_id, call_time) is the primary key for this table.
-- Example Input/Output:
-- Output:
-- +---------+
-- | user_id |
-- +---------+
-- | 1       |
-- | 2       |
-- +---------+
-- Solution:
WITH AllCalls AS (
    SELECT caller_id AS user_id, recipient_id AS other_id, call_time FROM Calls
    UNION ALL
    SELECT recipient_id AS user_id, caller_id AS other_id, call_time FROM Calls
),
DailyCalls AS (
    SELECT
        user_id,
        DATE(call_time) AS call_date,
        other_id,
        FIRST_VALUE(other_id) OVER (PARTITION BY user_id, DATE(call_time) ORDER BY call_time ASC) AS first_person,
        FIRST_VALUE(other_id) OVER (PARTITION BY user_id, DATE(call_time) ORDER BY call_time DESC) AS last_person
    FROM
        AllCalls
)
SELECT DISTINCT
    user_id
FROM
    DailyCalls
WHERE
    first_person = last_person;
