-- 1988. Find Cutoff Score for Each School
-- Difficulty: Medium
-- Description:
-- Write an SQL query to report the minimum score requirement for each school. If there are multiple score values satisfying the condition, choose the smallest one. If the input data is not enough to determine the score, report -1.
-- The minimum score requirement is the minimum score that a student needs to achieve to be admitted to the school. The school will accept the student if the student's score is greater than or equal to the minimum score requirement and the school has enough capacity for all students with that score.
-- The condition is: capacity >= student_count_for_score.
-- Schema:
-- Table: Schools
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | school_id   | int  |
-- | capacity    | int  |
-- +-------------+------+
-- school_id is the primary key for this table.
-- 
-- Table: Exam
-- +---------------+------+
-- | Column Name   | Type |
-- +---------------+------+
-- | score         | int  |
-- | student_count | int  |
-- +---------------+------+
-- score is the primary key for this table.
-- Example Input/Output:
-- Output:
-- +-----------+-------+
-- | school_id | score |
-- +-----------+-------+
-- | 11        | 966   |
-- | 5         | -1    |
-- +-----------+-------+
-- Solution:
SELECT
    s.school_id,
    IFNULL(MIN(e.score), -1) AS score
FROM
    Schools s
    LEFT JOIN Exam e ON s.capacity >= e.student_count
GROUP BY
    s.school_id;
