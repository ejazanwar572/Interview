/*
3140. Consecutive Available Seats II
Difficulty: Medium
Table Names: Cinema
Description:
    - Database

## Description

Table: Cinema

| seat_id     | int  |
| free        | bool |
seat_id is an auto-increment column for this table.
Each row of this table indicates whether the i<sup>th</sup> seat is free or not. 1 means free while 0 means occupied.

Write a solution to find the length of longest consecutive sequence of available seats in the cinema.

Note:

	- There will always be at most one longest consecutive sequence.
	- If there are multiple consecutive sequences with the same length, include all of them in the output.

Return the result table ordered by first_seat_id in ascending order.

The result format is in the following example.

Example:

Input:

Cinema table:

+---------+------+
| seat_id | free |
+---------+------+
| 1       | 1    |
| 2       | 0    |
| 3       | 1    |
| 4       | 1    |
| 5       | 1    |
+---------+------+

Output:

+-----------------+----------------+-----------------------+
| first_seat_id   | last_seat_id   | consecutive_seats_len |
+-----------------+----------------+-----------------------+
| 3               | 5              | 3                     |
+-----------------+----------------+-----------------------+

Explanation:

	- Longest consecutive sequence of available seats starts from seat 3 and ends at seat 5 with a length of 3.
Output table is ordered by first_seat_id in ascending order.
*/

-- Write your MySQL query statement below:













-- Solution:
/*
WITH
    T AS (
        SELECT
            *,
            seat_id - (RANK() OVER (ORDER BY seat_id)) AS gid
        FROM Cinema
        WHERE free = 1
    ),
    P AS (
        SELECT
            MIN(seat_id) AS first_seat_id,
            MAX(seat_id) AS last_seat_id,
            COUNT(1) AS consecutive_seats_len,
            RANK() OVER (ORDER BY COUNT(1) DESC) AS rk
        FROM T
        GROUP BY gid
    )
SELECT first_seat_id, last_seat_id, consecutive_seats_len
FROM P
WHERE rk = 1
ORDER BY 1;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Cinema;
DROP TABLE IF EXISTS Cinema;
CREATE TABLE Cinema (
    seat_id int,
    free bool
);

INSERT INTO Cinema (seat_id, free) VALUES
    (1, '1'),
    (2, '0'),
    (3, '1'),
    (4, '1'),
    (5, '1');

SET FOREIGN_KEY_CHECKS = 1;
*/
