-- 1070. Product Sales Analysis III
-- Difficulty: Medium
-- 
-- Table: Sales
-- +-------------+-------+
-- | Column Name | Type  |
-- +-------------+-------+
-- | sale_id     | int   |
-- | product_id  | int   |
-- | year        | int   |
-- | quantity    | int   |
-- | price       | int   |
-- +-------------+-------+
-- (sale_id, year) is the primary key (combination of columns with unique values) of this table.
-- Each row records a sale of a product in a given year.
-- A product may have multiple sales entries in the same year.
-- 
-- Write a solution to find all sales that occurred in the first year each product was sold.
-- For each product_id, identify the earliest year it appears in the Sales table.
-- Return all sales entries for that product in that year.
-- 
/*
Create table If Not Exists Sales (sale_id int, product_id int, year int, quantity int, price int)\nTruncate table Sales\ninsert into Sales (sale_id, product_id, year, quantity, price) values ('1', '100', '2008', '10', '5000')\ninsert into Sales (sale_id, product_id, year, quantity, price) values ('2', '100', '2009', '12', '5000')\ninsert into Sales (sale_id, product_id, year, quantity, price) values ('7', '200', '2011', '15', '9000')
*/
-- Solution
SELECT product_id, year AS first_year, quantity, price
FROM Sales
WHERE (product_id, year) IN (
    SELECT product_id, MIN(year)
    FROM Sales
    GROUP BY product_id
);
-- Solution:
