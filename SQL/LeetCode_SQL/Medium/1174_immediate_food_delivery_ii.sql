/*
1174. Immediate Food Delivery II
Difficulty: Medium
Table Names: Delivery

Table: Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date). If the preferred delivery date is the same as the order date, it's called immediate. Write a query to find the percentage of immediate orders in the first orders of all customers.

Solution
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT 
    ROUND(AVG(order_date = customer_pref_delivery_date) * 100, 2) AS immediate_percentage
FROM Delivery
WHERE (customer_id, order_date) IN (
    SELECT customer_id, MIN(order_date)
    FROM Delivery
    GROUP BY customer_id
);

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Delivery;
CREATE TABLE Delivery (delivery_id int, customer_id int, order_date date, customer_pref_delivery_date date);

SET FOREIGN_KEY_CHECKS = 1;
*/
