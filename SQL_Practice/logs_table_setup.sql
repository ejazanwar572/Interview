-- SQL to create and populate the Logs table
-- This data corresponds to the "Consecutive Numbers" problem.

-- Step 0: Ensure Dataset Exists
CREATE SCHEMA IF NOT EXISTS `interview_practice`;

-- Step 1: Create the Table
DROP TABLE IF EXISTS `interview_practice.Logs`;

CREATE TABLE `interview_practice.Logs` (
    Id INT64,
    Num INT64
);

-- Step 2: Insert the Data
INSERT INTO `interview_practice.Logs` (Id, Num) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 2),
(5, 1),
(6, 2),
(7, 2);

-- Verification
SELECT * FROM `interview_practice.Logs` ORDER BY Id;
