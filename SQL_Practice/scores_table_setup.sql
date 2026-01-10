-- SQL to create and populate the Scores table

-- Step 0: Ensure Dataset Exists
CREATE SCHEMA IF NOT EXISTS `interview_practice`;

-- Step 1: Create the Table
DROP TABLE IF EXISTS `interview_practice.Scores`;

CREATE TABLE `interview_practice.Scores` (
    student_id INT64,
    subject STRING,
    score INT64,
    exam_date DATE
);

-- Step 2: Insert the Data
INSERT INTO `interview_practice.Scores` (student_id, subject, score, exam_date) VALUES
(101, 'Math', 70, DATE '2023-01-15'),
(101, 'Math', 85, DATE '2023-02-15'),
(101, 'Physics', 65, DATE '2023-01-15'),
(101, 'Physics', 60, DATE '2023-02-15'),
(102, 'Math', 80, DATE '2023-01-15'),
(102, 'Math', 85, DATE '2023-02-15'),
(103, 'Math', 90, DATE '2023-01-15'),
(104, 'Physics', 75, DATE '2023-01-15'),
(104, 'Physics', 85, DATE '2023-02-15');

-- Verification
SELECT * FROM `interview_practice.Scores` ORDER BY student_id, subject, exam_date;
