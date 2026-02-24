/*
1459. Rectangles Area
Difficulty: Medium
Table Names: Points
Description:
Write a solution to report all possible axis-aligned rectangles with a non-zero area that can be formed by any two points from the Points table.
Each row in the result should contain three columns (p1, p2, area) where p1 and p2 are the ids of the two points that determine the opposite corners of a rectangle.
area is the area of the rectangle and must be non-zero.
Return the result table ordered by area in descending order. If there is a tie, order them by p1 in ascending order. If there is still a tie, order them by p2 in ascending order.
Schema:
Table: Points
| id            | int     |
| x_value       | int     |
| y_value       | int     |
Example Input/Output:
Points table:
+----------+-------------+-------------+
| id       | x_value     | y_value     |
+----------+-------------+-------------+
| 1        | 2           | 7           |
| 2        | 4           | 8           |
| 3        | 2           | 10          |
+----------+-------------+-------------+
Output:
+----------+----------+----------+
| p1       | p2       | area     |
+----------+----------+----------+
| 2        | 3        | 4        |
| 1        | 2        | 2        |
+----------+----------+----------+
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT
    p1.id AS p1,
    p2.id AS p2,
    ABS(p1.x_value - p2.x_value) * ABS(p1.y_value - p2.y_value) AS area
FROM
    Points p1
    JOIN Points p2 ON p1.id < p2.id
WHERE
    p1.x_value != p2.x_value
    AND p1.y_value != p2.y_value
ORDER BY
    area DESC,
    p1 ASC,
    p2 ASC;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Points;
DROP TABLE IF EXISTS Points;
CREATE TABLE Points (
    id int,
    x_value int,
    y_value int
);

INSERT INTO Points (id, x_value, y_value) VALUES
    (1, 2, 7),
    (2, 4, 8),
    (3, 2, 10);

SET FOREIGN_KEY_CHECKS = 1;
*/
