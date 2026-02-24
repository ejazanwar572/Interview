/*
1715. Count Apples and Oranges
Difficulty: Medium
Table Names: Boxes, Chests
Description:
Write an SQL query to count the total number of apples and oranges in all the boxes. If a box contains a chest, you should also count the apples and oranges in that chest.
Schema:
Table: Boxes
| box_id        | int     |
| chest_id      | int     |
| apple_count   | int     |
| orange_count  | int     |
chest_id is a foreign key to Chests table.

Table: Chests
| chest_id      | int     |
| apple_count   | int     |
| orange_count  | int     |
Example Input/Output:
Output:
+-------------+--------------+
| apple_count | orange_count |
+-------------+--------------+
| 151         | 123          |
+-------------+--------------+
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT
    SUM(b.apple_count + IFNULL(c.apple_count, 0)) AS apple_count,
    SUM(b.orange_count + IFNULL(c.orange_count, 0)) AS orange_count
FROM
    Boxes b
    LEFT JOIN Chests c ON b.chest_id = c.chest_id;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Boxes;
DROP TABLE IF EXISTS Boxes;
CREATE TABLE Boxes (
    box_id int,
    chest_id int,
    apple_count int,
    orange_count int
);

INSERT INTO Boxes (apple_count, orange_count) VALUES
    (151, 123);

DROP TABLE IF EXISTS Chests;
DROP TABLE IF EXISTS Chests;
CREATE TABLE Chests (
    chest_id int,
    apple_count int,
    orange_count int
);

SET FOREIGN_KEY_CHECKS = 1;
*/
