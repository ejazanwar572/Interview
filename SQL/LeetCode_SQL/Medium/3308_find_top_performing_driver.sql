/*
3308. Find Top Performing Driver
Difficulty: Medium
Table Names: Drivers, Vehicles, Trips
Description:
    - Database

## Description


| driver_id    | int     |
| name         | varchar |
| age          | int     |
| experience   | int     |
| accidents    | int     |
Each row includes a driver's ID, their name, age, years of driving experience, and the number of accidents they&rsquo;ve had.


| vehicle_id   | int     |
| driver_id    | int     |
| model        | varchar |
| fuel_type    | varchar |
| mileage      | int     |
Each row includes the vehicle's ID, the driver who operates it, the model, fuel type, and mileage.


| trip_id      | int     |
| vehicle_id   | int     |
| distance     | int     |
| duration     | int     |
| rating       | int     |
Each row includes a trip's ID, the vehicle used, the distance covered (in miles), the trip duration (in minutes), and the passenger's rating (1-5).

Uber is analyzing drivers based on their trips. Write a solution to find the top-performing driver for each fuel type based on the following criteria:

<ol>
	- A driver's performance is calculated as the average rating across all their trips. Average rating should be rounded to 2 decimal places.
	- If two drivers have the same average rating, the driver with the longer total distance traveled should be ranked higher.
	- If there is still a tie, choose the driver with the fewest accidents.
</ol>

Return the result table ordered by fuel_type in ascending order.

The result format is in the following example.

Example:

Input:

Drivers table:

+-----------+----------+-----+------------+-----------+
| driver_id | name     | age | experience | accidents |
+-----------+----------+-----+------------+-----------+
| 1         | Alice    | 34  | 10         | 1         |
| 2         | Bob      | 45  | 20         | 3         |
| 3         | Charlie  | 28  | 5          | 0         |
+-----------+----------+-----+------------+-----------+

Vehicles table:

+------------+-----------+---------+-----------+---------+
| vehicle_id | driver_id | model   | fuel_type | mileage |
+------------+-----------+---------+-----------+---------+
| 100        | 1         | Sedan   | Gasoline  | 20000   |
| 101        | 2         | SUV     | Electric  | 30000   |
| 102        | 3         | Coupe   | Gasoline  | 15000   |
+------------+-----------+---------+-----------+---------+

Trips table:

+---------+------------+----------+----------+--------+
| trip_id | vehicle_id | distance | duration | rating |
+---------+------------+----------+----------+--------+
| 201     | 100        | 50       | 30       | 5      |
| 202     | 100        | 30       | 20       | 4      |
| 203     | 101        | 100      | 60       | 4      |
| 204     | 101        | 80       | 50       | 5      |
| 205     | 102        | 40       | 30       | 5      |
| 206     | 102        | 60       | 40       | 5      |
+---------+------------+----------+----------+--------+

Output:

+-----------+-----------+--------+----------+
| fuel_type | driver_id | rating | distance |
+-----------+-----------+--------+----------+
| Electric  | 2         | 4.50   | 180      |
| Gasoline  | 3         | 5.00   | 100      |
+-----------+-----------+--------+----------+

Explanation:

	- For fuel type Gasoline, both Alice (Driver 1) and Charlie (Driver 3) have trips. Charlie has an average rating of 5.0, while Alice has 4.5. Therefore, Charlie is selected.
	- For fuel type Electric, Bob (Driver 2) is the only driver with an average rating of 4.5, so he is selected.

The output table is ordered by fuel_type in ascending order.
*/

-- Write your MySQL query statement below:













-- Solution:
/*
WITH
    T AS (
        SELECT
            fuel_type,
            driver_id,
            ROUND(AVG(rating), 2) rating,
            SUM(distance) distance,
            SUM(accidents) accidents
        FROM
            Drivers
            JOIN Vehicles USING (driver_id)
            JOIN Trips USING (vehicle_id)
        GROUP BY fuel_type, driver_id
    ),
    P AS (
        SELECT
            *,
            RANK() OVER (
                PARTITION BY fuel_type
                ORDER BY rating DESC, distance DESC, accidents
            ) rk
        FROM T
    )
SELECT fuel_type, driver_id, rating, distance
FROM P
WHERE rk = 1
ORDER BY 1;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Drivers;

DROP TABLE IF EXISTS Drivers;
CREATE TABLE Drivers (
    driver_id int,
    name VARCHAR(255),
    age int,
    experience int,
    accidents int
);

INSERT INTO
    Drivers (
        driver_id,
        name,
        age,
        experience,
        accidents
    )
VALUES (1, 'Alice', 34, 10, 1),
    (2, 'Bob', 45, 20, 3),
    (3, 'Charlie', 28, 5, 0);

DROP TABLE IF EXISTS Vehicles;

DROP TABLE IF EXISTS Vehicles;
CREATE TABLE Vehicles (
    vehicle_id int,
    driver_id int,
    model VARCHAR(255),
    fuel_type VARCHAR(255),
    mileage int
);

INSERT INTO
    Vehicles (
        vehicle_id,
        driver_id,
        model,
        fuel_type,
        mileage
    )
VALUES (
        100,
        1,
        'Sedan',
        'Gasoline',
        20000
    ),
    (
        101,
        2,
        'SUV',
        'Electric',
        30000
    ),
    (
        102,
        3,
        'Coupe',
        'Gasoline',
        15000
    );

DROP TABLE IF EXISTS Trips;

DROP TABLE IF EXISTS Trips;
CREATE TABLE Trips (
    trip_id int,
    vehicle_id int,
    distance int,
    duration int,
    rating int
);

INSERT INTO
    Trips (
        trip_id,
        vehicle_id,
        distance,
        duration,
        rating
    )
VALUES (201, 100, 50, 30, 5),
    (202, 100, 30, 20, 4),
    (203, 101, 100, 60, 4),
    (204, 101, 80, 50, 5),
    (205, 102, 40, 30, 5),
    (206, 102, 60, 40, 5);

SET FOREIGN_KEY_CHECKS = 1;
*/
