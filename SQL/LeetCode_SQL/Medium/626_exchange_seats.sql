/*
626. Exchange Seats
Difficulty: Medium
Table Names: Seat

Table: Seat
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| student     | varchar |
+-------------+---------+
id is the primary key (unique value) column for this table.
Each row of this table indicates the name and the ID of a student.
The ID sequence always starts from 1 and increments continuously.

Write a solution to swap the seat id of every two consecutive students. If the number of students is odd, the id of the last student is not swapped.
Return the result table ordered by id in ascending order.

Example 1:

Input:                                          Output:
Seat table:                                     +----+---------+
+----+---------+                                | id | student |
| id | student |                                +----+---------+
+----+---------+                                | 1  | Doris   |
| 1  | Abbot   |                                | 2  | Abbot   |
| 2  | Doris   |                                | 3  | Green   |
| 3  | Emerson |                                | 4  | Emerson |
| 4  | Green   |                                | 5  | Jeames  |
| 5  | Jeames  |                                +----+---------+
+----+---------+

Explanation: 
Note that if the number of students is odd, there is no need to change the last one's seat.
*/

-- Write your MySQL query statement below:

-- Solution:
/*
SELECT 
CASE 
WHEN id % 2 = 1 AND id = (SELECT MAX(id) FROM Seat) THEN id
WHEN id % 2 = 1 THEN id + 1
ELSE id - 1
END AS id,
student
FROM Seat
ORDER BY id;
*/

-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Seat;
CREATE TABLE Seat (id int, student varchar(255));
Truncate table Seat;
insert into Seat (id, student) values ('1', 'Abbot');
insert into Seat (id, student) values ('2', 'Doris');
insert into Seat (id, student) values ('3', 'Emerson');
insert into Seat (id, student) values ('4', 'Green');
insert into Seat (id, student) values ('5', 'Jeames');

SET FOREIGN_KEY_CHECKS = 1;
*/