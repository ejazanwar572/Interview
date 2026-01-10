-- SQL to create and populate the Queue table

-- Step 0: Ensure Dataset Exists
CREATE SCHEMA IF NOT EXISTS `interview_practice`;

-- Step 1: Create the Table
DROP TABLE IF EXISTS `interview_practice.Queue`;

CREATE TABLE `interview_practice.Queue` (
    person_id INT64,
    person_name STRING,
    weight INT64,
    turn INT64
);

-- Step 2: Insert the Data
INSERT INTO `interview_practice.Queue` (person_id, person_name, weight, turn) VALUES
(5, 'Alice', 250, 1),
(4, 'Bob', 175, 5),
(3, 'Alex', 350, 2),
(6, 'John Cena', 400, 3),
(1, 'Winston', 500, 6),
(2, 'Marie', 200, 4);

-- Verification
SELECT * FROM `interview_practice.Queue` ORDER BY turn;
