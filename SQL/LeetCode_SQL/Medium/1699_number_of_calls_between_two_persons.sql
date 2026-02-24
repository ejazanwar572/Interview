/*
1699. Number of Calls Between Two Persons
Difficulty: Medium
Table Names: Calls
Description:
Write an SQL query to report the number of calls and the total call duration between each pair of distinct persons (person1, person2) where person1 < person2.
Schema:
Table: Calls
| from_id       | int     |
| to_id         | int     |
| duration      | int     |
No primary key.
Example Input/Output:
Output:
+---------+---------+------------+----------------+
| person1 | person2 | call_count | total_duration |
+---------+---------+------------+----------------+
| 1       | 2       | 2          | 70             |
| 1       | 3       | 1          | 20             |
| 3       | 4       | 2          | 300            |
+---------+---------+------------+----------------+
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT
    CASE
        WHEN from_id < to_id THEN from_id
        ELSE to_id
    END AS person1,
    CASE
        WHEN from_id < to_id THEN to_id
        ELSE from_id
    END AS person2,
    COUNT(*) AS call_count,
    SUM(duration) AS total_duration
FROM
    Calls
GROUP BY
    person1,
    person2
ORDER BY
    person1,
    person2;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Calls;
DROP TABLE IF EXISTS Calls;
CREATE TABLE Calls (
    from_id int,
    to_id int,
    duration int
);

SET FOREIGN_KEY_CHECKS = 1;
*/
