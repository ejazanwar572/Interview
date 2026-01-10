-- SQL to create and populate the RequestAccepted table

-- Step 0: Ensure Dataset Exists
CREATE SCHEMA IF NOT EXISTS `interview_practice`;

-- Step 1: Create the Table
DROP TABLE IF EXISTS `interview_practice.RequestAccepted`;

CREATE TABLE `interview_practice.RequestAccepted` (
    requester_id INT64,
    accepter_id INT64,
    accept_date DATE
);

-- Step 2: Insert the Data
INSERT INTO `interview_practice.RequestAccepted` (requester_id, accepter_id, accept_date) VALUES
(1, 2, DATE '2016-06-03'),
(1, 3, DATE '2016-06-08'),
(2, 3, DATE '2016-06-08'),
(3, 4, DATE '2016-06-09');

-- Verification
SELECT * FROM `interview_practice.RequestAccepted` ORDER BY accept_date;
