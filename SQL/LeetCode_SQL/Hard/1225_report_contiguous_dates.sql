-- 1225. Report Contiguous Dates
-- Difficulty: Hard
-- Table: Failed
-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | fail_date    | date    |
-- +--------------+---------+
-- Primary key for this table is fail_date.
-- Contains the days of failed tasks.
-- Table: Succeeded
-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | success_date | date    |
-- +--------------+---------+
-- Primary key for this table is success_date.
-- Contains the days of succeeded tasks.
-- A system is running one task every day. Every task is independent of the previous tasks. The tasks can fail or succeed.
-- Write an SQL query to generate a report of period_state for each continuous interval of days in the period from 2019-01-01 to 2019-12-31.
-- period_state is 'failed' if tasks in this interval failed or 'succeeded' if tasks in this interval succeeded. Interval of days are retrieved as start_date and end_date.
-- Order result by start_date.
-- Example:
-- Input:
-- Failed table:
-- +-------------------+
-- | fail_date         |
-- +-------------------+
-- | 2019-01-04        |
-- | 2019-01-05        |
-- | 2019-01-11        |
-- | 2019-01-12        |
-- +-------------------+
-- Succeeded table:
-- +-------------------+
-- | success_date      |
-- +-------------------+
-- | 2019-01-01        |
-- | 2019-01-02        |
-- | 2019-01-03        |
-- | 2019-01-06        |
-- +-------------------+
-- Output:
-- +--------------+------------+------------+
-- | period_state | start_date | end_date   |
-- +--------------+------------+------------+
-- | succeeded    | 2019-01-01 | 2019-01-03 |
-- | failed       | 2019-01-04 | 2019-01-05 |
-- | succeeded    | 2019-01-06 | 2019-01-06 |
-- | failed       | 2019-01-11 | 2019-01-12 |
-- +--------------+------------+------------+
WITH AllDates AS (
    SELECT success_date AS dt, 'succeeded' AS period_state FROM Succeeded
    WHERE success_date BETWEEN '2019-01-01' AND '2019-12-31'
    UNION ALL
    SELECT fail_date AS dt, 'failed' AS period_state FROM Failed
    WHERE fail_date BETWEEN '2019-01-01' AND '2019-12-31'
),
RankedDates AS (
    SELECT
        dt,
        period_state,
        RANK() OVER (ORDER BY dt) AS overall_rank,
        RANK() OVER (PARTITION BY period_state ORDER BY dt) AS state_rank
    FROM
        AllDates
),
Groups AS (
    SELECT
        dt,
        period_state,
        (overall_rank - state_rank) AS group_id
    FROM
        RankedDates
)
SELECT
    period_state,
    MIN(dt) AS start_date,
    MAX(dt) AS end_date
FROM
    Groups
GROUP BY
    period_state,
    group_id
ORDER BY
    start_date;
-- Solution:
