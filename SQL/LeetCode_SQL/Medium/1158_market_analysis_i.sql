-- 1158. Market Analysis I
-- Difficulty: Medium
-- 
-- Table: Users (user_id, join_date, favorite_brand). Table: Orders (order_id, order_date, item_id, buyer_id, seller_id). Table: Items (item_id, item_brand). Write an SQL query to find for each user, the join date and the number of orders they made as a buyer in 2019.
-- 
/*
Create table If Not Exists Users (user_id int, join_date date, favorite_brand varchar(10)); Create table If Not Exists Orders (order_id int, order_date date, item_id int, buyer_id int, seller_id int); Create table If Not Exists Items (item_id int, item_brand varchar(10));
*/
-- Solution
SELECT 
    u.user_id AS buyer_id,
    u.join_date,
    COUNT(o.order_id) AS orders_in_2019
FROM Users u
LEFT JOIN Orders o ON u.user_id = o.buyer_id AND YEAR(o.order_date) = 2019
GROUP BY u.user_id, u.join_date;
-- Solution:
