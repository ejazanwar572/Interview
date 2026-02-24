/*
1549. The Most Recent Orders for Each Product
Difficulty: Medium
Table Names: Customers, Products, Orders
Description:
Find the most recent orders for each product.
Return the result table ordered by product_name (ASC), product_id (ASC), and order_id (ASC).
Schema:
Table: Customers
| customer_id   | int     |
| name          | varchar |

Table: Products
| product_id    | int     |
| name          | varchar |
| price         | int     |

Table: Orders
| order_id      | int     |
| order_date    | date    |
| customer_id   | int     |
| product_id    | int     |
Example Input/Output:
Output:
+--------------+------------+----------+------------+
| product_name | product_id | order_id | order_date |
+--------------+------------+----------+------------+
| keyboard     | 1          | 2        | 2020-06-16 |
| mouse        | 2          | 3        | 2020-06-10 |
+--------------+------------+----------+------------+
*/

-- Write your MySQL query statement below:













-- Solution:
/*
WITH RankedProductOrders AS (
    SELECT
        p.name AS product_name,
        p.product_id,
        o.order_id,
        o.order_date,
        RANK() OVER (
            PARTITION BY p.product_id 
            ORDER BY o.order_date DESC
        ) AS rn
    FROM
        Products p
        JOIN Orders o ON p.product_id = o.product_id
)
SELECT
    product_name,
    product_id,
    order_id,
    order_date
FROM
    RankedProductOrders
WHERE
    rn = 1
ORDER BY
    product_name ASC,
    product_id ASC,
    order_id ASC;

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


DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Products;
CREATE TABLE Products (
    product_id int,
    name VARCHAR(255),
    price int
);


DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
    order_id int,
    order_date date,
    customer_id int,
    product_id int
);

SET FOREIGN_KEY_CHECKS = 1;
*/
