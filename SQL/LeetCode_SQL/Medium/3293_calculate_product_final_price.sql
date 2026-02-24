/*
3293. Calculate Product Final Price
Difficulty: Medium
Table Names: Products, Discounts
Description:
    - Database

## Description


| product_id | int     |
| category   | varchar |
| price      | decimal |
Each row includes the product's ID, its category, and its price.


| category   | varchar |
| discount   | int     |
Each row contains a product category and the percentage discount applied to that category (values range from 0 to 100).

Write a solution to find the final price of each product after applying the category discount. If a product's category has no associated discount, its price remains unchanged.

Return the result table ordered by product_id in ascending order.

The result format is in the following example.

Example:

Input:

Products table:

+------------+-------------+-------+
| product_id | category    | price |
+------------+-------------+-------+
| 1          | Electronics | 1000  |
| 2          | Clothing    | 50    |
| 3          | Electronics | 1200  |
| 4          | Home        | 500   |
+------------+-------------+-------+

Discounts table:

+------------+----------+
| category   | discount |
+------------+----------+
| Electronics| 10       |
| Clothing   | 20       |
+------------+----------+

Output:

+------------+------------+-------------+
| product_id | final_price| category    |
+------------+------------+-------------+
| 1          | 900        | Electronics |
| 2          | 40         | Clothing    |
| 3          | 1080       | Electronics |
| 4          | 500        | Home        |
+------------+------------+-------------+

Explanation:

	- For product 1, it belongs to the Electronics category which has a 10% discount, so the final price is 1000 - (10% of 1000) = 900.
	- For product 2, it belongs to the Clothing category which has a 20% discount, so the final price is 50 - (20% of 50) = 40.
	- For product 3, it belongs to the Electronics category and receives a 10% discount, so the final price is 1200 - (10% of 1200) = 1080.
	- For product 4, no discount is available for the Home category, so the final price remains 500.
Result table is ordered by product_id in ascending order.
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT
    product_id,
    price * (100 - IFNULL(discount, 0)) / 100 final_price,
    category
FROM
    Products
    LEFT JOIN Discounts USING (category)
ORDER BY 1;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Products;

DROP TABLE IF EXISTS Products;
CREATE TABLE Products (
    product_id int,
    category VARCHAR(255),
    price decimal(10, 2)
);

INSERT INTO
    Products (product_id, category, price)
VALUES (1, 'Electronics', 1000),
    (2, 'Clothing', 50),
    (3, 'Electronics', 1200),
    (4, 'Home', 500);

DROP TABLE IF EXISTS Discounts;

DROP TABLE IF EXISTS Discounts;
CREATE TABLE Discounts (
    category VARCHAR(255),
    discount int
);

INSERT INTO
    Discounts (category, discount)
VALUES ('Electronics', 10),
    ('Clothing', 20);

SET FOREIGN_KEY_CHECKS = 1;
*/
