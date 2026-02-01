-- 626. Exchange Seats
-- Difficulty: Medium
-- 
-- Table: Seat
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | id          | int     |
-- | student     | varchar |
-- +-------------+---------+
-- id is the primary key (unique value) column for this table.
-- Each row of this table indicates the name and the ID of a student.
-- The ID sequence always starts from 1 and increments continuously.
-- 
-- Write a solution to swap the seat id of every two consecutive students. If the number of students is odd, the id of the last student is not swapped.
-- Return the result table ordered by id in ascending order.
-- 
/*
Create table If Not Exists Seat (id int, student varchar(255))\nTruncate table Seat\ninsert into Seat (id, student) values ('1', 'Abbot')\ninsert into Seat (id, student) values ('2', 'Doris')\ninsert into Seat (id, student) values ('3', 'Emerson')\ninsert into Seat (id, student) values ('4', 'Green')\ninsert into Seat (id, student) values ('5', 'Jeames')
*/
-- Solution
SELECT 
    CASE 
        WHEN id % 2 = 1 AND id = (SELECT MAX(id) FROM Seat) THEN id
        WHEN id % 2 = 1 THEN id + 1
        ELSE id - 1
    END AS id,
    student
FROM Seat
ORDER BY id;
-- Solution:
