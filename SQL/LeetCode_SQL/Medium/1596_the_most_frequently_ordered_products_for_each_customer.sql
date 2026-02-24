/*
1596. The Most Frequently Ordered Products for Each Customer
Difficulty: Medium
Table Names: Customers, Orders, Products
Description:
Find the most frequently ordered product(s) for each customer.
Schema:
Table: Customers
| customer_id   | int     |
| name          | varchar |

Table: Orders
| order_id      | int     |
| order_date    | date    |
| customer_id   | int     |
| product_id    | int     |

Table: Products
| product_id    | int     |
| product_name  | varchar |
| price         | int     |
Example Input/Output:
Output:
+-------------+------------+--------------+
| customer_id | product_id | product_name |
+-------------+------------+--------------+
| 1           | 2          | keyboard     |
| 2           | 1          | mouse        |
+-------------+------------+--------------+
*/

-- Write your MySQL query statement below:













-- Solution:
/*
WITH ProductCounts AS (
    SELECT
        customer_id,
        product_id,
        COUNT(*) AS cnt
    FROM
        Orders
    GROUP BY
        customer_id,
        product_id
),
RankedCounts AS (
    SELECT
        customer_id,
        product_id,
        cnt,
        RANK() OVER (
            PARTITION BY customer_id 
            ORDER BY cnt DESC
        ) AS rn
    FROM
        ProductCounts
)
SELECT
    r.customer_id,
    r.product_id,
    p.product_name
FROM
    RankedCounts r
    JOIN Products p ON r.product_id = p.product_id
WHERE
    r.rn = 1;

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
    product_id int
);


DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Products;
CREATE TABLE Products (
    product_id int,
    product_name VARCHAR(255),
    price int
);

SET FOREIGN_KEY_CHECKS = 1;
*/
