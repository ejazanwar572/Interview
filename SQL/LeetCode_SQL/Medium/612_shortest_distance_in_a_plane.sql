/*
612. Shortest Distance in a Plane
Difficulty: Medium
Table Names: Point2D
Table: Point2D
| x           | int  |
| y           | int  |
Write a solution to report the shortest distance between any two points from the Point2D table. Round the distance to two decimal points.
Example:
Input:
Point2D table:
+----+----+
| x  | y  |
+----+----+
| -1 | -1 |
| 0  | 0  |
| -1 | -2 |
+----+----+
Output:
+----------+
| shortest |
+----------+
| 1.00     |
+----------+
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT
    ROUND(
        SQRT(
            MIN(
                POW(p1.x - p2.x, 2) + POW(p1.y - p2.y, 2)
            )
        ), 2
    ) AS shortest
FROM
    Point2D p1
    INNER JOIN Point2D p2 ON (p1.x <> p2.x OR p1.y <> p2.y);
-- Note: The join condition ensures we don't calculate distance to self (0).
-- Optimisation: p1.rowid < p2.rowid or similar if strictly unique rows, but x,y pair is PK?
-- The problem guarantees all points are distinct? "Each point is unique." usually valid for this problem.
-- Actually the problem statement implies points are distinct rows.
-- The join condition `NOT (p1.x = p2.x AND p1.y = p2.y)` is safer.
-- Wait, MIN needs to be outside or inside?
-- SQRT(MIN(...)) is better than MIN(SQRT(...)) for performance (monotonic).

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Point2D;
DROP TABLE IF EXISTS Point2D;
CREATE TABLE Point2D (
    x int,
    y int
);

INSERT INTO Point2D (x, y) VALUES
    (-1, -1),
    (0, 0),
    (-1, -2);

SET FOREIGN_KEY_CHECKS = 1;
*/
