-- 1412. Find the Quiet Students in All Exams
-- Difficulty: Hard
-- Description:
-- A "quiet" student is one who took at least one exam and did not score either the high score or the low score.
-- Write an SQL query to report the students (student_id, student_name) being "quiet" in ALL exams they took.
-- Do not return students who have never taken any exam.
-- Return the result table ordered by student_id.
-- Schema:
-- Table: Student
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | student_id  | int     |
-- | student_name| varchar |
-- +-------------+---------+
-- student_id is the primary key for this table.
-- 
-- Table: Exam
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | exam_id     | int     |
-- | student_id  | int     |
-- | score       | int     |
-- +-------------+---------+
-- (exam_id, student_id) is the primary key for this table.
-- Example Input/Output:
-- Student table:
-- +-------------+---------------+
-- | student_id  | student_name  |
-- +-------------+---------------+
-- | 1           | Daniel        |
-- | 2           | Jade          |
-- | 3           | Stella        |
-- | 4           | Jonathan      |
-- | 5           | Will          |
-- +-------------+---------------+
-- Exam table:
-- +------------+--------------+-----------+
-- | exam_id    | student_id   | score     |
-- +------------+--------------+-----------+
-- | 10         | 1            | 70        |
-- | 10         | 2            | 80        |
-- | 10         | 3            | 90        |
-- | 20         | 1            | 80        |
-- | 30         | 1            | 70        |
-- | 30         | 3            | 80        |
-- | 30         | 4            | 90        |
-- | 40         | 1            | 60        |
-- | 40         | 2            | 70        |
-- | 40         | 4            | 80        |
-- +------------+--------------+-----------+
-- Result table:
-- +-------------+---------------+
-- | student_id  | student_name  |
-- +-------------+---------------+
-- | 2           | Jade          |
-- +-------------+---------------+
-- Solution:
WITH ExamStats AS (
    SELECT
        exam_id,
        MIN(score) as min_score,
        MAX(score) as max_score
    FROM
        Exam
    GROUP BY
        exam_id
),
LoudStudents AS (
    SELECT DISTINCT
        e.student_id
    FROM
        Exam e
        JOIN ExamStats es ON e.exam_id = es.exam_id
    WHERE
        e.score = es.min_score
        OR e.score = es.max_score
)
SELECT
    s.student_id,
    s.student_name
FROM
    Student s
WHERE
    s.student_id IN (SELECT DISTINCT student_id FROM Exam)
    AND s.student_id NOT IN (SELECT student_id FROM LoudStudents)
ORDER BY
    s.student_id;
