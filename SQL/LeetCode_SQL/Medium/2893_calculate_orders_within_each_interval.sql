/*
2893. Calculate Orders Within Each Interval
Difficulty: Medium
Table Names: Orders
Description:
    - Database

## Description


| minute      | int  |
| order_count | int  |
Each row of this table contains the minute and number of orders received during that specific minute. The total number of rows will be a multiple of 6.

Write a query to calculate total orders<b> </b>within each interval. Each interval is defined as a combination of 6 minutes.

	- Minutes 1 to 6 fall within interval 1, while minutes 7 to 12 belong to interval 2, and so forth.

Return the result table ordered by interval_no in ascending order.

The result format is in the following example.

Example 1:

Input:
Orders table:
+--------+-------------+
| minute | order_count |
+--------+-------------+
| 1      | 0           |
| 2      | 2           |
| 3      | 4           |
| 4      | 6           |
| 5      | 1           |
| 6      | 4           |
| 7      | 1           |
| 8      | 2           |
| 9      | 4           |
| 10     | 1           |
| 11     | 4           |
| 12     | 6           |
+--------+-------------+
Output:
+-------------+--------------+
| interval_no | total_orders |
+-------------+--------------+
| 1           | 17           |
| 2           | 18           |
+-------------+--------------+
Explanation:
- Interval number 1 comprises minutes from 1 to 6. The total orders in these six minutes are (0 + 2 + 4 + 6 + 1 + 4) = 17.
- Interval number 2 comprises minutes from 7 to 12. The total orders in these six minutes are (1 + 2 + 4 + 1 + 4 + 6) = 18.
Returning table orderd by interval_no in ascending order.
*/

-- Write your MySQL query statement below:













-- Solution:
/*
WITH
    T AS (
        SELECT
            minute,
            SUM(order_count) OVER (
                ORDER BY minute
                ROWS 5 PRECEDING
            ) AS total_orders
        FROM Orders
    )
SELECT minute / 6 AS interval_no, total_orders
FROM T
WHERE minute % 6 = 0;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Orders;

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
    minute int PRIMARY KEY,
    order_count int
);

INSERT INTO
    Orders (minute, order_count)
VALUES (1, 0),
    (2, 2),
    (3, 4),
    (4, 6),
    (5, 1),
    (6, 4),
    (7, 1),
    (8, 2),
    (9, 4),
    (10, 1),
    (11, 4),
    (12, 6);

SET FOREIGN_KEY_CHECKS = 1;
*/
