/*
1308. Running Total for Different Genders
Difficulty: Medium
Table Names: Scores
Table: Scores
| player_name   | varchar |
| gender        | varchar |
| day           | date    |
| score_points  | int     |
A competition is held between females and males.
The table gives the score of each player on each day.
The gender 'F' is for female and 'M' is for male.
Write an SQL query to find the total score for each gender on each day.
Order the result table by gender and day.
Example:
Input:
Scores table:
+-------------+--------+------------+--------------+
| player_name | gender | day        | score_points |
+-------------+--------+------------+--------------+
| Aron        | F      | 2020-01-01 | 17           |
| Alice       | F      | 2020-01-07 | 23           |
| Bajrang     | M      | 2020-01-07 | 7            |
| Khali       | M      | 2019-12-25 | 11           |
| Slaman      | M      | 2019-12-30 | 13           |
| Joe         | M      | 2019-12-31 | 3            |
| Jose        | M      | 2019-12-18 | 2            |
| Priya       | F      | 2019-12-31 | 23           |
| Priyanka    | F      | 2019-12-30 | 17           |
+-------------+--------+------------+--------------+
Output:
+--------+------------+-------+
| gender | day        | total |
+--------+------------+-------+
| F      | 2019-12-30 | 17    |
| F      | 2019-12-31 | 40    |
| F      | 2020-01-01 | 57    |
| F      | 2020-01-07 | 80    |
| M      | 2019-12-18 | 2     |
| M      | 2019-12-25 | 13    |
| M      | 2019-12-30 | 26    |
| M      | 2019-12-31 | 29    |
| M      | 2020-01-07 | 36    |
+--------+------------+-------+
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT
    gender,
    day,
    SUM(score_points) OVER (
        PARTITION BY gender 
        ORDER BY day
    ) AS total
FROM
    Scores
ORDER BY
    gender,
    day;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Scores;
DROP TABLE IF EXISTS Scores;
CREATE TABLE Scores (
    player_name VARCHAR(255),
    gender VARCHAR(255),
    day date,
    score_points int
);

INSERT INTO Scores (player_name, gender, day, score_points) VALUES
    ('Aron', 'F', '2020-01-01', 17),
    ('Alice', 'F', '2020-01-07', 23),
    ('Bajrang', 'M', '2020-01-07', 7),
    ('Khali', 'M', '2019-12-25', 11),
    ('Slaman', 'M', '2019-12-30', 13),
    ('Joe', 'M', '2019-12-31', 3),
    ('Jose', 'M', '2019-12-18', 2),
    ('Priya', 'F', '2019-12-31', 23),
    ('Priyanka', 'F', '2019-12-30', 17);

SET FOREIGN_KEY_CHECKS = 1;
*/
