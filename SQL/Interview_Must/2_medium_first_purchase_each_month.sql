/*
Problem Description:
Find the first purchase made by each user in every distinct month they were active.

Sample Input:
user_orders table:
+----------+---------+---------------------+
| order_id | user_id | order_timestamp     |
+----------+---------+---------------------+
| 1        | 1     | 2023-01-05 10:00:00 |
| 2        | 1     | 2023-01-20 15:00:00 |
| 3        | 1     | 2023-02-10 09:00:00 |
| 4        | 2     | 2023-01-15 11:00:00 |
+----------+---------+---------------------+

Sample Output:
+----------+---------+---------------------+
| order_id | user_id | order_timestamp     |
+----------+---------+---------------------+
| 1        | 1     | 2023-01-05 10:00:00 |
| 3        | 1     | 2023-02-10 09:00:00 |
| 4        | 2     | 2023-01-15 11:00:00 |
+----------+---------+---------------------+
*/

-- DDL and DML
DROP TABLE IF EXISTS user_orders;
CREATE TABLE user_orders (
    order_id INT,
    user_id INT,
    order_timestamp DATETIME
);

INSERT INTO user_orders (order_id, user_id, order_timestamp) VALUES
(1, 1, '2023-01-05 10:00:00'),
(2, 1, '2023-01-20 15:00:00'),
(3, 1, '2023-02-10 09:00:00'),
(4, 2, '2023-01-15 11:00:00');

/*
Problem Solving Approach:
1. Use `ROW_NUMBER()` window function.
2. Partition the data by both `user_id`, `YEAR(order_timestamp)`, and `MONTH(order_timestamp)`.
3. Order the partitions by `order_timestamp` ascending to assign 1 to the first chronological purchase in that month.
4. Filter out any rows where the rank is not 1.
*/

-- Optimized Solution
WITH RankedOrdersByMonth AS (
    SELECT 
        order_id,
        user_id,
        order_timestamp,
        ROW_NUMBER() OVER(PARTITION BY user_id, DATE_FORMAT(order_timestamp, '%Y-%m') ORDER BY order_timestamp) as rn
    FROM user_orders
)
SELECT 
    order_id,
    user_id,
    order_timestamp
FROM RankedOrdersByMonth
WHERE rn = 1;
