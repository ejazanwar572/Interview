/*
1398. Customers Who Bought Products A and B but Not C
Difficulty: Medium
Table Names: Customers, Orders
Description:
Write an SQL query to report the customer_id and customer_name of customers who bought products "A" and "B" but did not buy the product "C".
Return the result table ordered by customer_id.
Schema:
Table: Customers
| customer_id   | int     |
| customer_name | varchar |

Table: Orders
| order_id      | int     |
| customer_id   | int     |
| product_name  | varchar |
Example Input/Output:
Customers table:
+-------------+---------------+
| customer_id | customer_name |
+-------------+---------------+
| 1           | Daniel        |
| 2           | Diana         |
| 3           | Elizabeth     |
| 4           | Jhon          |
+-------------+---------------+
Orders table:
+------------+--------------+--------------+
| order_id   | customer_id  | product_name |
+------------+--------------+--------------+
| 10         | 1            | A            |
| 20         | 1            | B            |
| 30         | 1            | D            |
| 40         | 1            | C            |
| 50         | 2            | A            |
| 60         | 3            | A            |
| 70         | 3            | B            |
| 80         | 3            | D            |
| 90         | 4            | C            |
+------------+--------------+--------------+
Result table:
+-------------+---------------+
| customer_id | customer_name |
+-------------+---------------+
| 3           | Elizabeth     |
+-------------+---------------+
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT
    c.customer_id,
    c.customer_name
FROM
    Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
HAVING
    SUM(CASE WHEN o.product_name = 'A' THEN 1 ELSE 0 END) > 0
    AND SUM(CASE WHEN o.product_name = 'B' THEN 1 ELSE 0 END) > 0
    AND SUM(CASE WHEN o.product_name = 'C' THEN 1 ELSE 0 END) = 0
ORDER BY
    c.customer_id;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
    customer_id int PRIMARY KEY,
    customer_name VARCHAR(255)
);

INSERT INTO Customers (customer_id, customer_name) VALUES
    (1, 'Daniel'),
    (2, 'Diana'),
    (3, 'Elizabeth'),
    (4, 'Jhon');

DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
    order_id int,
    customer_id int,
    product_name VARCHAR(255)
);

INSERT INTO Orders (order_id, customer_id, product_name) VALUES
    (10, 1, 'A'),
    (20, 1, 'B'),
    (30, 1, 'D'),
    (40, 1, 'C'),
    (50, 2, 'A'),
    (60, 3, 'A'),
    (70, 3, 'B'),
    (80, 3, 'D'),
    (90, 4, 'C');

SET FOREIGN_KEY_CHECKS = 1;
*/
