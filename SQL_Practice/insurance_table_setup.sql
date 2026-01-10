-- SQL to create and populate the Insurance table

-- Step 0: Ensure Dataset Exists
CREATE SCHEMA IF NOT EXISTS `interview_practice`;

-- Step 1: Create the Table
DROP TABLE IF EXISTS `interview_practice.Insurance`;

CREATE TABLE `interview_practice.Insurance` (
    pid INT64,
    tiv_2015 FLOAT64,
    tiv_2016 FLOAT64,
    lat FLOAT64,
    lon FLOAT64
);

-- Step 2: Insert the Data
INSERT INTO `interview_practice.Insurance` (pid, tiv_2015, tiv_2016, lat, lon) VALUES
(1, 10, 5, 10, 10),
(2, 20, 20, 20, 20),
(3, 10, 30, 20, 20),
(4, 10, 40, 40, 40);

-- Verification
SELECT * FROM `interview_practice.Insurance` ORDER BY pid;
