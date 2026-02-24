/*
2314. The First Day of the Maximum Recorded Degree in Each City
Difficulty: Medium
Table Names: Weather
Description:
    - Database

## Description

Table: Weather

| city_id     | int  |
| day         | date |
| degree      | int  |
Each row in this table contains the degree of the weather of a city on a certain day.
All the degrees are recorded in the year 2022.

Write a solution to report the day that has the maximum recorded degree in each city. If the maximum degree was recorded for the same city multiple times, return the earliest day among them.

Return the result table ordered by city_id in ascending order.

The result format is shown in the following example.

Example 1:

Input:
Weather table:
+---------+------------+--------+
| city_id | day        | degree |
+---------+------------+--------+
| 1       | 2022-01-07 | -12    |
| 1       | 2022-03-07 | 5      |
| 1       | 2022-07-07 | 24     |
| 2       | 2022-08-07 | 37     |
| 2       | 2022-08-17 | 37     |
| 3       | 2022-02-07 | -7     |
| 3       | 2022-12-07 | -6     |
+---------+------------+--------+
Output:
+---------+------------+--------+
| city_id | day        | degree |
+---------+------------+--------+
| 1       | 2022-07-07 | 24     |
| 2       | 2022-08-07 | 37     |
| 3       | 2022-12-07 | -6     |
+---------+------------+--------+
Explanation:
For city 1, the maximum degree was recorded on 2022-07-07 with 24 degrees.
For city 2, the maximum degree was recorded on 2022-08-07 and 2022-08-17 with 37 degrees. We choose the earlier date (2022-08-07).
For city 3, the maximum degree was recorded on 2022-12-07 with -6 degrees.
*/

-- Write your MySQL query statement below:













-- Solution:
/*
WITH
    T AS (
        SELECT
            *,
            RANK() OVER (
                PARTITION BY city_id
                ORDER BY degree DESC, day
            ) AS rk
        FROM Weather
    )
SELECT city_id, day, degree
FROM T
WHERE rk = 1
ORDER BY 1;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Weather;
DROP TABLE IF EXISTS Weather;
CREATE TABLE Weather (
    city_id int,
    day date,
    degree int
);

INSERT INTO Weather (city_id, day, degree) VALUES
    (1, '2022-01-07', -12),
    (1, '2022-03-07', 5),
    (1, '2022-07-07', 24),
    (2, '2022-08-07', 37),
    (2, '2022-08-17', 37),
    (3, '2022-02-07', -7),
    (3, '2022-12-07', -6),
    (1, '2022-07-07', 24),
    (2, '2022-08-07', 37),
    (3, '2022-12-07', -6);

SET FOREIGN_KEY_CHECKS = 1;
*/
