/*
2308. Arrange Table by Gender
Difficulty: Medium
Table Names: Genders
Description:
    - Database

## Description

Table: Genders

| user_id     | int     |
| gender      | varchar |
gender is ENUM (category) of type 'female', 'male', or 'other'.
Each row in this table contains the ID of a user and their gender.
The table has an equal number of 'female', 'male', and 'other'.

Write a solution to rearrange the Genders table such that the rows alternate between 'female', 'other', and 'male' in order. The table should be rearranged such that the IDs of each gender are sorted in ascending order.

Return the result table in the mentioned order.

The result format is shown in the following example.

Example 1:

Input:
Genders table:
+---------+--------+
| user_id | gender |
+---------+--------+
| 4       | male   |
| 7       | female |
| 2       | other  |
| 5       | male   |
| 3       | female |
| 8       | male   |
| 6       | other  |
| 1       | other  |
| 9       | female |
+---------+--------+
Output:
+---------+--------+
| user_id | gender |
+---------+--------+
| 3       | female |
| 1       | other  |
| 4       | male   |
| 7       | female |
| 2       | other  |
| 5       | male   |
| 9       | female |
| 6       | other  |
| 8       | male   |
+---------+--------+
Explanation:
Female gender: IDs 3, 7, and 9.
Other gender: IDs 1, 2, and 6.
Male gender: IDs 4, 5, and 8.
We arrange the table alternating between 'female', 'other', and 'male'.
Note that the IDs of each gender are sorted in ascending order.
*/

-- Write your MySQL query statement below:













-- Solution:
/*
WITH
    t AS (
        SELECT
            *,
            RANK() OVER (
                PARTITION BY gender
                ORDER BY user_id
            ) AS rk1,
            CASE
                WHEN gender = 'female' THEN 0
                WHEN gender = 'other' THEN 1
                ELSE 2
            END AS rk2
        FROM Genders
    )
SELECT user_id, gender
FROM t
ORDER BY rk1, rk2;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Genders;
DROP TABLE IF EXISTS Genders;
CREATE TABLE Genders (
    user_id int,
    gender VARCHAR(255)
);

INSERT INTO Genders (user_id, gender) VALUES
    (4, 'male'),
    (7, 'female'),
    (2, 'other'),
    (5, 'male'),
    (3, 'female'),
    (8, 'male'),
    (6, 'other'),
    (1, 'other'),
    (9, 'female'),
    (3, 'female'),
    (1, 'other'),
    (4, 'male'),
    (7, 'female'),
    (2, 'other'),
    (5, 'male'),
    (9, 'female'),
    (6, 'other'),
    (8, 'male');

SET FOREIGN_KEY_CHECKS = 1;
*/
