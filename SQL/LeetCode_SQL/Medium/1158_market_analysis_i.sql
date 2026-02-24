/*
1158. Market Analysis I
Difficulty: Medium
Table Names: Users, Orders, Items

Table: Users (user_id, join_date, favorite_brand). Table: Orders (order_id, order_date, item_id, buyer_id, seller_id). Table: Items (item_id, item_brand). Write an SQL query to find for each user, the join date and the number of orders they made as a buyer in 2019.

Solution
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT 
    u.user_id AS buyer_id,
    u.join_date,
    COUNT(o.order_id) AS orders_in_2019
FROM Users u
LEFT JOIN Orders o ON u.user_id = o.buyer_id AND YEAR(o.order_date) = 2019
GROUP BY u.user_id, u.join_date;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Users;
CREATE TABLE Users (user_id int, join_date date, favorite_brand varchar(10)); DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (order_id int, order_date date, item_id int, buyer_id int, seller_id int); DROP TABLE IF EXISTS Items;
CREATE TABLE Items (item_id int, item_brand varchar(10));

SET FOREIGN_KEY_CHECKS = 1;
*/
