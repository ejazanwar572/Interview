/*
1867. Orders With Maximum Quantity Above Average
Difficulty: Medium
Table Names: OrdersDetails
Description:
An imbalanced order is one whose maximum quantity is strictly greater than the average quantity of every order (including itself).
Write an SQL query to find the order_id of all imbalanced orders.
Schema:
Table: OrdersDetails
| order_id    | int  |
| product_id  | int  |
| quantity    | int  |
Example Input/Output:
Output:
+----------+
| order_id |
+----------+
| 1        |
| 3        |
+----------+
*/

-- Write your MySQL query statement below:













-- Solution:
/*
WITH OrderStats AS (
    SELECT
        order_id,
        MAX(quantity) AS max_quantity,
        AVG(quantity) AS avg_quantity
    FROM
        OrdersDetails
    GROUP BY
        order_id
),
MaxAvg AS (
    SELECT
        MAX(avg_quantity) AS global_max_avg
    FROM
        OrderStats
)
SELECT
    order_id
FROM
    OrderStats,
    MaxAvg
WHERE
    max_quantity > global_max_avg;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS OrdersDetails;
DROP TABLE IF EXISTS OrdersDetails;
CREATE TABLE OrdersDetails (
    order_id int,
    product_id int,
    quantity int
);

INSERT INTO OrdersDetails (order_id) VALUES
    (1),
    (3);

SET FOREIGN_KEY_CHECKS = 1;
*/
