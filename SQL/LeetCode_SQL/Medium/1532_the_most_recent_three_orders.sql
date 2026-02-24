/*
1532. The Most Recent Three Orders
Difficulty: Medium
Table Names: Customers, Orders
Description:
Find the most recent three orders of each user. If a user has less than three orders, return all of their orders.
Return the result table ordered by customer_name (ASC), customer_id (ASC), and order_date (DESC).
Schema:
Table: Customers
| customer_id   | int     |
| name          | varchar |

Table: Orders
| order_id      | int     |
| order_date    | date    |
| customer_id   | int     |
| cost          | int     |
Example Input/Output:
Output:
+---------------+-------------+----------+------------+
| customer_name | customer_id | order_id | order_date |
+---------------+-------------+----------+------------+
| Winston       | 1           | 2        | 2020-08-01 |
| Winston       | 1           | 3        | 2020-07-31 |
| Winston       | 1           | 1        | 2020-07-31 |
+---------------+-------------+----------+------------+
*/

-- Write your MySQL query statement below:













-- Solution:
/*
WITH RankedOrders AS (
    SELECT
        c.name AS customer_name,
        c.customer_id,
        o.order_id,
        o.order_date,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_id 
            ORDER BY o.order_date DESC
        ) AS rn
    FROM
        Customers c
        JOIN Orders o ON c.customer_id = o.customer_id
)
SELECT
    customer_name,
    customer_id,
    order_id,
    order_date
FROM
    RankedOrders
WHERE
    rn <= 3
ORDER BY
    customer_name ASC,
    customer_id ASC,
    order_date DESC;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
    customer_id int PRIMARY KEY,
    name VARCHAR(255)
);


DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
    order_id int,
    order_date date,
    customer_id int,
    cost int
);

SET FOREIGN_KEY_CHECKS = 1;
*/
