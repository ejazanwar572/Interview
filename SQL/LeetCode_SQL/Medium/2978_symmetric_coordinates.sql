/*
2978. Symmetric Coordinates
Difficulty: Medium
Table Names: Coordinates
Description:
    - Database

## Description


| X           | int  |
| Y           | int  |
Each row includes X and Y, where both are integers. Table may contain duplicate values.

Two coordindates (X1, Y1) and (X2, Y2) are said to be symmetric coordintes if X1 == Y2 and X2 == Y1.

Write a solution that outputs, among all these symmetric coordintes, only those unique coordinates that satisfy the condition X1 <= Y1.

Return the result table ordered by X and  Y (respectively) in ascending order.

The result format is in the following example.

Example 1:

Input:
Coordinates table:
+----+----+
| X  | Y  |
+----+----+
| 20 | 20 |
| 20 | 20 |
| 20 | 21 |
| 23 | 22 |
| 22 | 23 |
| 21 | 20 |
+----+----+
Output:
+----+----+
| x  | y  |
+----+----+
| 20 | 20 |
| 20 | 21 |
| 22 | 23 |
+----+----+
Explanation:
- (20, 20) and (20, 20) are symmetric coordinates because, X1 == Y2 and X2 == Y1. This results in displaying (20, 20) as a distinctive coordinates.
- (20, 21) and (21, 20) are symmetric coordinates because, X1 == Y2 and X2 == Y1. However, only (20, 21) will be displayed because X1 <= Y1.
- (23, 22) and (22, 23) are symmetric coordinates because, X1 == Y2 and X2 == Y1. However, only (22, 23) will be displayed because X1 <= Y1.
The output table is sorted by X and Y in ascending order.
*/

-- Write your MySQL query statement below:













-- Solution:
/*
WITH
    P AS (
        SELECT
            ROW_NUMBER() OVER () AS id,
            x,
            y
        FROM Coordinates
    )
SELECT DISTINCT
    p1.x,
    p1.y
FROM
    P AS p1
    JOIN P AS p2 ON p1.x = p2.y AND p1.y = p2.x AND p1.x <= p1.y AND p1.id != p2.id
ORDER BY 1, 2;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Coordinates;

DROP TABLE IF EXISTS Coordinates;
CREATE TABLE Coordinates (X int, Y int);

INSERT INTO
    Coordinates (X, Y)
VALUES (20, 20),
    (20, 20),
    (20, 21),
    (23, 22),
    (22, 23),
    (21, 20);

SET FOREIGN_KEY_CHECKS = 1;
*/
