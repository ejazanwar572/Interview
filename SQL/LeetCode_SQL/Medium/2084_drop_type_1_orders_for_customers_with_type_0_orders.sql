/*
2084. Drop Type 1 Orders for Customers With Type 0 Orders
Difficulty: Medium
Table Names: Orders
Description:
    - Database

## Description

Table: Orders

| order_id    | int  |
| customer_id | int  |
| order_type  | int  |
order_id is the column with unique values for this table.
Each row of this table indicates the ID of an order, the ID of the customer who ordered it, and the order type.
The orders could be of type 0 or type 1.

Write a solution to report all the orders based on the following criteria:

- If a customer has at least one order of type 0, do not report any order of type 1 from that customer.
- Otherwise, report all the orders of the customer.

Return the result table in any order.

The result format is in the following example.

Example 1:

Input:
Orders table:
+----------+-------------+------------+
| order_id | customer_id | order_type |
+----------+-------------+------------+
| 1        | 1           | 0          |
| 2        | 1           | 0          |
| 11       | 2           | 0          |
| 12       | 2           | 1          |
| 21       | 3           | 1          |
| 22       | 3           | 0          |
| 31       | 4           | 1          |
| 32       | 4           | 1          |
+----------+-------------+------------+
Output:
+----------+-------------+------------+
| order_id | customer_id | order_type |
+----------+-------------+------------+
| 31       | 4           | 1          |
| 32       | 4           | 1          |
| 1        | 1           | 0          |
| 2        | 1           | 0          |
| 11       | 2           | 0          |
| 22       | 3           | 0          |
+----------+-------------+------------+
Explanation:
Customer 1 has two orders of type 0. We return both of them.
Customer 2 has one order of type 0 and one order of type 1. We only return the order of type 0.
Customer 3 has one order of type 0 and one order of type 1. We only return the order of type 0.
Customer 4 has two orders of type 1. We return both of them.
*/

-- Write your MySQL query statement below:













-- Solution:
/*

h

WITH
    T AS (
        SELECT DISTINCT customer_id
        FROM Orders
        WHERE order_type = 0
    )
SELECT *
FROM Orders AS o
WHERE order_type = 0 OR NOT EXISTS (SELECT 1 FROM T AS t WHERE t.customer_id = o.customer_id);

-- Logic: If a customer has type 0, min_type will be 0. We keep rows where order_type=0 OR min_type=1 (meaning they only have type 1).
SELECT order_id, customer_id, order_type
FROM (
    SELECT *, MIN(order_type) OVER(PARTITION BY customer_id) as min_type
    FROM Orders
) t
WHERE order_type = 0 OR min_type = 1;


-- Keep if type is 0. If type is 1, keep only if customer NOT IN the set of customers with type 0 orders.

SELECT *
FROM Orders
WHERE order_type = 0 
   OR customer_id NOT IN (SELECT customer_id FROM Orders WHERE order_type = 0);


*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
    order_id int,
    customer_id int,
    order_type int
);

INSERT INTO Orders (order_id, customer_id, order_type) VALUES
    (1, 1, 0),
    (2, 1, 0),
    (11, 2, 0),
    (12, 2, 1),
    (21, 3, 1),
    (22, 3, 0),
    (31, 4, 1),
    (32, 4, 1),
    (31, 4, 1),
    (32, 4, 1),
    (1, 1, 0),
    (2, 1, 0),
    (11, 2, 0),
    (22, 3, 0);

SET FOREIGN_KEY_CHECKS = 1;
*/
