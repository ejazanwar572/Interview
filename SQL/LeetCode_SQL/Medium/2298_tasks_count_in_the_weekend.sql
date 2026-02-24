/*
2298. Tasks Count in the Weekend
Difficulty: Medium
Table Names: Tasks
Description:
    - Database

## Description

Table: Tasks

| task_id     | int  |
| assignee_id | int  |
| submit_date | date |
Each row in this table contains the ID of a task, the id of the assignee, and the submission date.

Write a solution to report:

	- the number of tasks that were submitted during the weekend (Saturday, Sunday) as weekend_cnt, and
	- the number of tasks that were submitted during the working days as working_cnt.

Return the result table in any order.

The result format is shown in the following example.

Example 1:

Input:
Tasks table:
+---------+-------------+-------------+
| task_id | assignee_id | submit_date |
+---------+-------------+-------------+
| 1       | 1           | 2022-06-13  |
| 2       | 6           | 2022-06-14  |
| 3       | 6           | 2022-06-15  |
| 4       | 3           | 2022-06-18  |
| 5       | 5           | 2022-06-19  |
| 6       | 7           | 2022-06-19  |
+---------+-------------+-------------+
Output:
+-------------+-------------+
| weekend_cnt | working_cnt |
+-------------+-------------+
| 3           | 3           |
+-------------+-------------+
Explanation:
Task 1 was submitted on Monday.
Task 2 was submitted on Tuesday.
Task 3 was submitted on Wednesday.
Task 4 was submitted on Saturday.
Task 5 was submitted on Sunday.
Task 6 was submitted on Sunday.
3 tasks were submitted during the weekend.
3 tasks were submitted during the working days.
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT
    SUM(WEEKDAY(submit_date) IN (5, 6)) AS weekend_cnt,
    SUM(WEEKDAY(submit_date) NOT IN (5, 6)) AS working_cnt
FROM Tasks;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Tasks;
DROP TABLE IF EXISTS Tasks;
CREATE TABLE Tasks (
    task_id int,
    assignee_id int,
    submit_date date
);

INSERT INTO Tasks (task_id, assignee_id, submit_date) VALUES
    (1, 1, '2022-06-13'),
    (2, 6, '2022-06-14'),
    (3, 6, '2022-06-15'),
    (4, 3, '2022-06-18'),
    (5, 5, '2022-06-19'),
    (6, 7, '2022-06-19');

SET FOREIGN_KEY_CHECKS = 1;
*/
