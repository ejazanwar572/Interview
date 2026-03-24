/*
Problem Description:
Find the average time between consecutive orders for each user in days.

Sample Input:
user_orders table:
+----------+---------+---------------------+
| order_id | user_id | order_date          |
+----------+---------+---------------------+
| 1        | 101     | 2023-01-01 10:00:00 |
| 2        | 101     | 2023-01-05 15:00:00 |
| 3        | 101     | 2023-01-15 09:00:00 |
| 4        | 102     | 2023-01-10 11:00:00 |
| 5        | 102     | 2023-01-12 11:00:00 |
+----------+---------+---------------------+

Sample Output:
+---------+---------------------------+
| user_id | avg_days_between_orders   |
+---------+---------------------------+
| 101     | 7.0000                    |
| 102     | 2.0000                    |
+---------+---------------------------+
*/

-- DDL and DML
DROP TABLE IF EXISTS user_orders;
CREATE TABLE user_orders (
    order_id INT,
    user_id INT,
    order_date DATETIME
);

INSERT INTO user_orders (order_id, user_id, order_date) VALUES
(1, 101, '2023-01-01 10:00:00'),
(2, 101, '2023-01-05 15:00:00'),
(3, 101, '2023-01-15 09:00:00'),
(4, 102, '2023-01-10 11:00:00'),
(5, 102, '2023-01-12 11:00:00');

/*
Problem Solving Approach:
1. Use the `LAG()` window function to retrieve the previous order date for the same user.
2. Calculate the difference in days using `DATEDIFF(order_date, prev_order_date)`.
3. Wrap this logic in a CTE, then aggregate by `user_id` calculating the `AVG()` of the differences.
*/

-- Optimized Solution
WITH LaggedOrders AS (
    SELECT 
        user_id,
        order_date,
        LAG(order_date) OVER(PARTITION BY user_id ORDER BY order_date) as prev_order_date
    FROM user_orders
)
SELECT 
    user_id,
    AVG(DATEDIFF(order_date, prev_order_date)) as avg_days_between_orders
FROM LaggedOrders
WHERE prev_order_date IS NOT NULL
GROUP BY user_id;
