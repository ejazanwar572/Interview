/*
1164. Product Price at a Given Date
Difficulty: Medium
Table Names: Products

Table: Products (product_id, new_price, change_date). Write an SQL query to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.

Solution
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT product_id, 10 AS price
FROM Products
GROUP BY product_id
HAVING MIN(change_date) > '2019-08-16'
UNION ALL
SELECT product_id, new_price AS price
FROM Products
WHERE (product_id, change_date) IN (
    SELECT product_id, MAX(change_date)
    FROM Products
    WHERE change_date <= '2019-08-16'
    GROUP BY product_id
);

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Products;
CREATE TABLE Products (product_id int, new_price int, change_date date);

SET FOREIGN_KEY_CHECKS = 1;
*/
