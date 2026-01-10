-- SQL to create and populate the Seat table

-- Step 0: Ensure Dataset Exists
CREATE SCHEMA IF NOT EXISTS `interview_practice`;

-- Step 1: Create the Table
DROP TABLE IF EXISTS `interview_practice.Seat`;

CREATE TABLE `interview_practice.Seat` (
    id INT64,
    student STRING
);

-- Step 2: Insert the Data
INSERT INTO `interview_practice.Seat` (id, student) VALUES
(1, 'Abbot'),
(2, 'Doris'),
(3, 'Emerson'),
(4, 'Green'),
(5, 'Jeames');

-- Verification
SELECT * FROM `interview_practice.Seat` ORDER BY id;
