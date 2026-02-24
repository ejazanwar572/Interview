/*
1355. Activity Participants
Difficulty: Medium
Table Names: Friends, Activities

Table Names: Friends, Activities

Description:
Write an SQL query to find the names of all the activities with neither maximum nor minimum number of participants.
Return the result table in any order.
Each activity in the table Activities is performed by any person in the table Friends.

Example Input/Output:
Friends table:
+------+--------------+---------------+
| id   | name         | activity      |
+------+--------------+---------------+
| 1    | Jonathan     | Eating        |
| 2    | Jade         | Eating        |
| 3    | Victor       | Eating        |
| 4    | Elvis        | Eating        |
| 5    | Daniel       | Dog Walking   |
| 6    | Bob          | Horse Riding  |
+------+--------------+---------------+

Activities table:
+------+--------------+
| id   | name         |
+------+--------------+
| 1    | Eating       |
| 2    | Singing      |
| 3    | Horse Riding |
| 4    | Jazz Dancing |
| 5    | Reading      |
| 6    | Dog Walking  |
+------+--------------+

Result table:
+--------------+
| activity     |
+--------------+
| Horse Riding |
| Dog Walking  |
+--------------+

Write your query below:
*/

-- Write your MySQL query statement below:













-- Solution:
/*
/*
WITH ActivityCounts AS (
SELECT
activity,
COUNT(*) AS cnt
FROM
Friends
GROUP BY
activity
)
SELECT
activity
FROM
ActivityCounts
WHERE
cnt != (SELECT MAX(cnt) FROM ActivityCounts)
AND cnt != (SELECT MIN(cnt) FROM ActivityCounts);
*/
*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Friends;

CREATE TABLE Friends (
    id int PRIMARY KEY,
    name VARCHAR(255),
    activity VARCHAR(255)
);

INSERT INTO
    Friends (id, name, activity)
VALUES (1, 'Jonathan', 'Eating'),
    (2, 'Jade', 'Eating'),
    (3, 'Victor', 'Eating'),
    (4, 'Elvis', 'Eating'),
    (5, 'Daniel', 'Dog Walking'),
    (6, 'Bob', 'Horse Riding');

DROP TABLE IF EXISTS Activities;

CREATE TABLE Activities (
    id int PRIMARY KEY,
    name VARCHAR(255)
);

INSERT INTO
    Activities (id, name)
VALUES (1, 'Eating'),
    (2, 'Singing'),
    (3, 'Horse Riding'),
    (4, 'Jazz Dancing'),
    (5, 'Reading'),
    (6, 'Dog Walking');

SET FOREIGN_KEY_CHECKS = 1;
*/
