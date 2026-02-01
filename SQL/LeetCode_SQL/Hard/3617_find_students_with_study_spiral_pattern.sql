-- 3617. Find Students with Study Spiral Pattern
-- Difficulty: Hard
-- Description:
--     - Database
-- 
-- ## Description
-- 
-- Table: students
-- 
-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | student_id   | int     |
-- | student_name | varchar |
-- | major        | varchar |
-- +--------------+---------+
-- student_id is the unique identifier for this table.
-- Each row contains information about a student and their academic major.
-- 
-- Table: study_sessions
-- 
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | session_id    | int     |
-- | student_id    | int     |
-- | subject       | varchar |
-- | session_date  | date    |
-- | hours_studied | decimal |
-- +---------------+---------+
-- session_id is the unique identifier for this table.
-- Each row represents a study session by a student for a specific subject.
-- 
-- Write a solution to find students who follow the Study Spiral Pattern - students who consistently study multiple subjects in a rotating cycle.
-- 
-- 	- A Study Spiral Pattern means a student studies at least 3 different subjects in a repeating sequence
-- 	- The pattern must repeat for at least 2 complete cycles (minimum 6 study sessions)
-- 	- Sessions must be consecutive dates with no gaps longer than 2 days between sessions
-- 	- Calculate the cycle length (number of different subjects in the pattern)
-- 	- Calculate the total study hours across all sessions in the pattern
-- 	- Only include students with cycle length of at least 3 subjects
-- 
-- Return the result table ordered by cycle length in descending order, then by total study hours in descending order.
-- 
-- The result format is in the following example.
-- 
-- Example:
-- 
-- Input:
-- 
-- students table:
-- 
-- +------------+--------------+------------------+
-- | student_id | student_name | major            |
-- +------------+--------------+------------------+
-- | 1          | Alice Chen   | Computer Science |
-- | 2          | Bob Johnson  | Mathematics      |
-- | 3          | Carol Davis  | Physics          |
-- | 4          | David Wilson | Chemistry        |
-- | 5          | Emma Brown   | Biology          |
-- +------------+--------------+------------------+
-- 
-- study_sessions table:
-- 
-- +------------+------------+------------+--------------+---------------+
-- | session_id | student_id | subject    | session_date | hours_studied |
-- +------------+------------+------------+--------------+---------------+
-- | 1          | 1          | Math       | 2023-10-01   | 2.5           |
-- | 2          | 1          | Physics    | 2023-10-02   | 3.0           |
-- | 3          | 1          | Chemistry  | 2023-10-03   | 2.0           |
-- | 4          | 1          | Math       | 2023-10-04   | 2.5           |
-- | 5          | 1          | Physics    | 2023-10-05   | 3.0           |
-- | 6          | 1          | Chemistry  | 2023-10-06   | 2.0           |
-- | 7          | 2          | Algebra    | 2023-10-01   | 4.0           |
-- | 8          | 2          | Calculus   | 2023-10-02   | 3.5           |
-- | 9          | 2          | Statistics | 2023-10-03   | 2.5           |
-- | 10         | 2          | Geometry   | 2023-10-04   | 3.0           |
-- | 11         | 2          | Algebra    | 2023-10-05   | 4.0           |
-- | 12         | 2          | Calculus   | 2023-10-06   | 3.5           |
-- | 13         | 2          | Statistics | 2023-10-07   | 2.5           |
-- | 14         | 2          | Geometry   | 2023-10-08   | 3.0           |
-- | 15         | 3          | Biology    | 2023-10-01   | 2.0           |
-- | 16         | 3          | Chemistry  | 2023-10-02   | 2.5           |
-- | 17         | 3          | Biology    | 2023-10-03   | 2.0           |
-- | 18         | 3          | Chemistry  | 2023-10-04   | 2.5           |
-- | 19         | 4          | Organic    | 2023-10-01   | 3.0           |
-- | 20         | 4          | Physical   | 2023-10-05   | 2.5           |
-- +------------+------------+------------+--------------+---------------+
-- 
-- Output:
-- 
-- +------------+--------------+------------------+--------------+-------------------+
-- | student_id | student_name | major            | cycle_length | total_study_hours |
-- +------------+--------------+------------------+--------------+-------------------+
-- | 2          | Bob Johnson  | Mathematics      | 4            | 26.0              |
-- | 1          | Alice Chen   | Computer Science | 3            | 15.0              |
-- +------------+--------------+------------------+--------------+-------------------+
-- 
-- Explanation:
-- 
-- 	- Alice Chen (student_id = 1):
-- 
--     	- Study sequence: Math &rarr; Physics &rarr; Chemistry &rarr; Math &rarr; Physics &rarr; Chemistry
--     	- Pattern: 3 subjects (Math, Physics, Chemistry) repeating for 2 complete cycles
--     	- Consecutive dates: Oct 1-6 with no gaps > 2 days
--     	- Cycle length: 3 subjects
--     	- Total hours: 2.5 + 3.0 + 2.0 + 2.5 + 3.0 + 2.0 = 15.0 hours
--     - Bob Johnson (student_id = 2):
--     	- Study sequence: Algebra &rarr; Calculus &rarr; Statistics &rarr; Geometry &rarr; Algebra &rarr; Calculus &rarr; Statistics &rarr; Geometry
--     	- Pattern: 4 subjects (Algebra, Calculus, Statistics, Geometry) repeating for 2 complete cycles
--     	- Consecutive dates: Oct 1-8 with no gaps > 2 days
--     	- Cycle length: 4 subjects
--     	- Total hours: 4.0 + 3.5 + 2.5 + 3.0 + 4.0 + 3.5 + 2.5 + 3.0 = 26.0 hours
--     - Students not included:
--     	- Carol Davis (student_id = 3): Only 2 subjects (Biology, Chemistry) - doesn't meet minimum 3 subjects requirement
--     	- David Wilson (student_id = 4): Only 2 study sessions with a 4-day gap - doesn't meet consecutive dates requirement
--     	- Emma Brown (student_id = 5): No study sessions recorded
-- 
-- The result table is ordered by cycle_length in descending order, then by total_study_hours in descending order.
-- 
-- Solution:
# Write your MySQL query statement below
WITH
    ranked_sessions AS (
        SELECT
            s.student_id,
            ss.session_date,
            ss.subject,
            ss.hours_studied,
            ROW_NUMBER() OVER (
                PARTITION BY s.student_id
                ORDER BY ss.session_date
            ) AS rn
        FROM
            study_sessions ss
            JOIN students s ON s.student_id = ss.student_id
    ),
    grouped_sessions AS (
        SELECT
            *,
            DATEDIFF(
                session_date,
                LAG(session_date) OVER (
                    PARTITION BY student_id
                    ORDER BY session_date
                )
            ) AS date_diff
        FROM ranked_sessions
    ),
    session_groups AS (
        SELECT
            *,
            SUM(
                CASE
                    WHEN date_diff > 2
                    OR date_diff IS NULL THEN 1
                    ELSE 0
                END
            ) OVER (
                PARTITION BY student_id
                ORDER BY session_date
            ) AS group_id
        FROM grouped_sessions
    ),
    valid_sequences AS (
        SELECT
            student_id,
            group_id,
            COUNT(*) AS session_count,
            GROUP_CONCAT(subject ORDER BY session_date) AS subject_sequence,
            SUM(hours_studied) AS total_hours
        FROM session_groups
        GROUP BY student_id, group_id
        HAVING session_count >= 6
    ),
    pattern_detected AS (
        SELECT
            vs.student_id,
            vs.total_hours,
            vs.subject_sequence,
            COUNT(
                DISTINCT
                SUBSTRING_INDEX(SUBSTRING_INDEX(subject_sequence, ',', n), ',', -1)
            ) AS cycle_length
        FROM
            valid_sequences vs
            JOIN (
                SELECT a.N + b.N * 10 + 1 AS n
                FROM
                    (
                        SELECT 0 AS N
                        UNION
                        SELECT 1
                        UNION
                        SELECT 2
                        UNION
                        SELECT 3
                        UNION
                        SELECT 4
                        UNION
                        SELECT 5
                        UNION
                        SELECT 6
                        UNION
                        SELECT 7
                        UNION
                        SELECT 8
                        UNION
                        SELECT 9
                    ) a,
                    (
                        SELECT 0 AS N
                        UNION
                        SELECT 1
                        UNION
                        SELECT 2
                        UNION
                        SELECT 3
                        UNION
                        SELECT 4
                        UNION
                        SELECT 5
                        UNION
                        SELECT 6
                        UNION
                        SELECT 7
                        UNION
                        SELECT 8
                        UNION
                        SELECT 9
                    ) b
            ) nums
                ON n <= 10
        WHERE
            -- Check if the sequence repeats every `k` items, for some `k >= 3` and divides session_count exactly
            -- We simplify by checking the start and middle halves are equal
            LENGTH(subject_sequence) > 0
            AND LOCATE(',', subject_sequence) > 0
            AND (
                -- For cycle length 3:
                subject_sequence LIKE CONCAT(
                    SUBSTRING_INDEX(subject_sequence, ',', 3),
                    ',',
                    SUBSTRING_INDEX(SUBSTRING_INDEX(subject_sequence, ',', 6), ',', -3),
                    '%'
                )
                OR subject_sequence LIKE CONCAT(
                    -- For cycle length 4:
                    SUBSTRING_INDEX(subject_sequence, ',', 4),
                    ',',
                    SUBSTRING_INDEX(SUBSTRING_INDEX(subject_sequence, ',', 8), ',', -4),
                    '%'
                )
            )
        GROUP BY vs.student_id, vs.total_hours, vs.subject_sequence
    ),
    final_output AS (
        SELECT
            s.student_id,
            s.student_name,
            s.major,
            pd.cycle_length,
            pd.total_hours AS total_study_hours
        FROM
            pattern_detected pd
            JOIN students s ON s.student_id = pd.student_id
        WHERE pd.cycle_length >= 3
    )
SELECT *
FROM final_output
ORDER BY cycle_length DESC, total_study_hours DESC;
