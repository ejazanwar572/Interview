/*
2372. Calculate the Influence of Each Salesperson
Difficulty: Medium
Table Names: Salesperson, Customer, Sales
Description:
    - Database

## Description

Table: Salesperson

| salesperson_id | int     |
| name           | varchar |
salesperson_id contains unique values.
Each row in this table shows the ID of a salesperson.

Table: Customer

| customer_id    | int  |
| salesperson_id | int  |
customer_id contains unique values.
salesperson_id is a foreign key (reference column) from the Salesperson table.
Each row in this table shows the ID of a customer and the ID of the salesperson.

Table: Sales

| sale_id     | int  |
| customer_id | int  |
| price       | int  |
sale_id contains unique values.
customer_id is a foreign key (reference column) from the Customer table.
Each row in this table shows ID of a customer and the price they paid for the sale with sale_id.

Write a solution to report the sum of prices paid by the customers of each salesperson. If a salesperson does not have any customers, the total value should be 0.

Return the result table in any order.

The result format is shown in the following example.

Example 1:

Input:
Salesperson table:
+----------------+-------+
| salesperson_id | name  |
+----------------+-------+
| 1              | Alice |
| 2              | Bob   |
| 3              | Jerry |
+----------------+-------+
Customer table:
+-------------+----------------+
| customer_id | salesperson_id |
+-------------+----------------+
| 1           | 1              |
| 2           | 1              |
| 3           | 2              |
+-------------+----------------+
Sales table:
+---------+-------------+-------+
| sale_id | customer_id | price |
+---------+-------------+-------+
| 1       | 2           | 892   |
| 2       | 1           | 354   |
| 3       | 3           | 988   |
| 4       | 3           | 856   |
+---------+-------------+-------+
Output:
+----------------+-------+-------+
| salesperson_id | name  | total |
+----------------+-------+-------+
| 1              | Alice | 1246  |
| 2              | Bob   | 1844  |
| 3              | Jerry | 0     |
+----------------+-------+-------+
Explanation:
Alice is the salesperson for customers 1 and 2.
  - Customer 1 made one purchase with 354.
  - Customer 2 made one purchase with 892.
The total for Alice is 354 + 892 = 1246.

Bob is the salesperson for customers 3.
  - Customer 1 made one purchase with 988 and 856.
The total for Bob is 988 + 856 = 1844.

Jerry is not the salesperson of any customer.
The total for Jerry is 0.
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT sp.salesperson_id, name, IFNULL(SUM(price), 0) AS total
FROM
    Salesperson AS sp
    LEFT JOIN Customer AS c ON sp.salesperson_id = c.salesperson_id
    LEFT JOIN Sales AS s ON s.customer_id = c.customer_id
GROUP BY 1;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Salesperson;
DROP TABLE IF EXISTS Salesperson;
CREATE TABLE Salesperson (
    salesperson_id int,
    name VARCHAR(255)
);

INSERT INTO Salesperson (salesperson_id, name) VALUES
    (1, 'Alice'),
    (2, 'Bob'),
    (3, 'Jerry');

DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Customer;
CREATE TABLE Customer (
    customer_id int,
    salesperson_id int
);

INSERT INTO Customer (customer_id, salesperson_id) VALUES
    (1, 1),
    (2, 1),
    (3, 2);

DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Sales;
CREATE TABLE Sales (
    sale_id int,
    customer_id int,
    price int
);

INSERT INTO Sales (sale_id, customer_id, price) VALUES
    (1, 2, 892),
    (2, 1, 354),
    (3, 3, 988),
    (4, 3, 856);

SET FOREIGN_KEY_CHECKS = 1;
*/
