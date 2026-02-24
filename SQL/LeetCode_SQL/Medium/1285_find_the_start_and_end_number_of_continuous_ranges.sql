/*
1285. Find the Start and End Number of Continuous Ranges
Difficulty: Medium
Table Names: Logs
Table: Logs
| log_id        | int     |
Each row of this table contains the ID in a log Table.
Write an SQL query to find the start and end number of continuous ranges in the table Logs.
Order result by start_id.
Example:
Input:
Logs table:
+------------+
| log_id     |
+------------+
| 1          |
| 2          |
| 3          |
| 7          |
| 8          |
| 10         |
+------------+
Output:
+------------+--------------+
| start_id   | end_id       |
+------------+--------------+
| 1          | 3            |
| 7          | 8            |
| 10         | 10           |
+------------+--------------+
*/

-- Write your MySQL query statement below:













-- Solution:
/*
WITH RankedLogs AS (
    SELECT
        log_id,
        ROW_NUMBER() OVER (ORDER BY log_id) AS rn
    FROM
        Logs
),
Groups AS (
    SELECT
        log_id,
        (log_id - rn) AS group_id
    FROM
        RankedLogs
)
SELECT
    MIN(log_id) AS start_id,
    MAX(log_id) AS end_id
FROM
    Groups
GROUP BY
    group_id
ORDER BY
    start_id;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Logs;
DROP TABLE IF EXISTS Logs;
CREATE TABLE Logs (
    log_id int
);

INSERT INTO Logs (log_id) VALUES
    (1),
    (2),
    (3),
    (7),
    (8),
    (10);

SET FOREIGN_KEY_CHECKS = 1;
*/
