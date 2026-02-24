/*
2142. The Number of Passengers in Each Bus I
Difficulty: Medium
Table Names: Buses, Passengers
Description:
    - Database

## Description

Table: Buses

| bus_id       | int  |
| arrival_time | int  |
bus_id is the column with unique values for this table.
Each row of this table contains information about the arrival time of a bus at the LeetCode station.
No two buses will arrive at the same time.

Table: Passengers

| passenger_id | int  |
| arrival_time | int  |
passenger_id is the column with unique values for this table.
Each row of this table contains information about the arrival time of a passenger at the LeetCode station.

Buses and passengers arrive at the LeetCode station. If a bus arrives at the station at time t<sub>bus</sub> and a passenger arrived at time t<sub>passenger</sub> where t<sub>passenger</sub> <= t<sub>bus</sub> and the passenger did not catch any bus, the passenger will use that bus.

Write a solution to report the number of users that used each bus.

Return the result table ordered by bus_id in ascending order.

The result format is in the following example.

Example 1:

Input:
Buses table:
+--------+--------------+
| bus_id | arrival_time |
+--------+--------------+
| 1      | 2            |
| 2      | 4            |
| 3      | 7            |
+--------+--------------+
Passengers table:
+--------------+--------------+
| passenger_id | arrival_time |
+--------------+--------------+
| 11           | 1            |
| 12           | 5            |
| 13           | 6            |
| 14           | 7            |
+--------------+--------------+
Output:
+--------+----------------+
| bus_id | passengers_cnt |
+--------+----------------+
| 1      | 1              |
| 2      | 0              |
| 3      | 3              |
+--------+----------------+
Explanation:
- Passenger 11 arrives at time 1.
- Bus 1 arrives at time 2 and collects passenger 11.

- Bus 2 arrives at time 4 and does not collect any passengers.

- Passenger 12 arrives at time 5.
- Passenger 13 arrives at time 6.
- Passenger 14 arrives at time 7.
- Bus 3 arrives at time 7 and collects passengers 12, 13, and 14.
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT
    bus_id,
    COUNT(passenger_id) - LAG(COUNT(passenger_id), 1, 0) OVER (
        ORDER BY b.arrival_time
    ) AS passengers_cnt
FROM
    Buses AS b
    LEFT JOIN Passengers AS p ON p.arrival_time <= b.arrival_time
GROUP BY 1
ORDER BY 1;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Buses;
DROP TABLE IF EXISTS Buses;
CREATE TABLE Buses (
    bus_id int,
    arrival_time int
);

INSERT INTO Buses (bus_id, arrival_time) VALUES
    (1, 2),
    (2, 4),
    (3, 7);

DROP TABLE IF EXISTS Passengers;
DROP TABLE IF EXISTS Passengers;
CREATE TABLE Passengers (
    passenger_id int,
    arrival_time int
);

INSERT INTO Passengers (passenger_id, arrival_time) VALUES
    (11, 1),
    (12, 5),
    (13, 6),
    (14, 7);

SET FOREIGN_KEY_CHECKS = 1;
*/
