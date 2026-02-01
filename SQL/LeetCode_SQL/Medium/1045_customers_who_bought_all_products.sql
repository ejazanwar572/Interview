-- 1045. Customers Who Bought All Products
-- Difficulty: Medium
-- 
-- Table: Customer
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | customer_id | int     |
-- | product_key | int     |
-- +-------------+---------+
-- This table may contain duplicates rows.
-- customer_id is not NULL.
-- product_key is a foreign key (reference column) to Product table.
-- 
-- Table: Product
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | product_key | int     |
-- +-------------+---------+
-- product_key is the primary key (column with unique values) for this table.
-- 
-- Write a solution to report the customer ids from the Customer table that bought all the products in the Product table.
-- Return the result table in any order.
-- 
/*
Create table If Not Exists Customer (customer_id int, product_key int)\nCreate table Product (product_key int)\nTruncate table Customer\ninsert into Customer (customer_id, product_key) values ('1', '5')\ninsert into Customer (customer_id, product_key) values ('2', '6')\ninsert into Customer (customer_id, product_key) values ('3', '5')\ninsert into Customer (customer_id, product_key) values ('3', '6')\ninsert into Customer (customer_id, product_key) values ('1', '6')\nTruncate table Product\ninsert into Product (product_key) values ('5')\ninsert into Product (product_key) values ('6')
*/
-- Solution
SELECT customer_id
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(*) FROM Product);
-- Solution:
