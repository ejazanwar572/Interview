/*
2783. Flight Occupancy and Waitlist Analysis
Difficulty: Medium
Table Names: Passengers
Description:
    - Database

## Description


| flight_id   | int  |
| capacity    | int  |
flight_id is the column with unique values for this table.
Each row of this table contains flight id and its capacity.

Table: Passengers

| passenger_id | int  |
| flight_id    | int  |
passenger_id is the column with unique values for this table.
Each row of this table contains passenger id and flight id.

Passengers book tickets for flights in advance. If a passenger books a ticket for a flight and there are still empty seats available on the flight, the passenger ticket will be confirmed. However, the passenger will be on a waitlist if the flight is already at full capacity.

Write a solution to report the number of passengers who successfully booked a flight (got a seat) and the number of passengers who are on the waitlist for each flight.

Return the result table ordered by flight_id in ascending order.

The result format is in the following example.

Example 1:

Input:
Flights table:
+-----------+----------+
| flight_id | capacity |
+-----------+----------+
| 1         | 2        |
| 2         | 2        |
| 3         | 1        |
+-----------+----------+
Passengers table:
+--------------+-----------+
| passenger_id | flight_id |
+--------------+-----------+
| 101          | 1         |
| 102          | 1         |
| 103          | 1         |
| 104          | 2         |
| 105          | 2         |
| 106          | 3         |
| 107          | 3         |
+--------------+-----------+
Output:
+-----------+------------+--------------+
| flight_id | booked_cnt | waitlist_cnt |
+-----------+------------+--------------+
| 1         | 2          | 1            |
| 2         | 2          | 0            |
| 3         | 1          | 1            |
+-----------+------------+--------------+
Explanation:
- Flight 1 has a capacity of 2. As there are 3 passengers who have booked tickets, only 2 passengers can get a seat. Therefore, 2 passengers are successfully booked, and 1 passenger is on the waitlist.
- Flight 2 has a capacity of 2. Since there are exactly 2 passengers who booked tickets, everyone can secure a seat. As a result, 2 passengers successfully booked their seats and there are no passengers on the waitlist.
- Flight 3 has a capacity of 1. As there are 2 passengers who have booked tickets, only 1 passenger can get a seat. Therefore, 1 passenger is successfully booked, and 1 passenger is on the waitlist.
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT
    flight_id,
    LEAST(COUNT(passenger_id), capacity) AS booked_cnt,
    GREATEST(COUNT(passenger_id) - capacity, 0) AS waitlist_cnt
FROM
    Flights
    LEFT JOIN Passengers USING (flight_id)
GROUP BY 1
ORDER BY 1;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Passengers;
DROP TABLE IF EXISTS Passengers;
CREATE TABLE Passengers (
    passenger_id int,
    flight_id int
);

INSERT INTO Passengers (passenger_id, flight_id) VALUES
    (101, 1),
    (102, 1),
    (103, 1),
    (104, 2),
    (105, 2),
    (106, 3),
    (107, 3);

SET FOREIGN_KEY_CHECKS = 1;
*/
