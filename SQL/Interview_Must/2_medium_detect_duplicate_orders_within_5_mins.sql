/*
Problem Description:
Find duplicate orders where a user makes a purchase for the exact same amount within 5 minutes of a previous purchase.

Sample Input:
orders table:
+----------+---------+--------+---------------------+
| order_id | user_id | amount | order_time          |
+----------+---------+--------+---------------------+
| 1        | 101     | 50.00  | 2023-10-01 10:00:00 |
| 2        | 101     | 50.00  | 2023-10-01 10:03:00 |
| 3        | 101     | 20.00  | 2023-10-01 10:04:00 |
| 4        | 102     | 100.00 | 2023-10-01 11:00:00 |
| 5        | 102     | 100.00 | 2023-10-01 11:10:00 |
+----------+---------+--------+---------------------+

Sample Output:
+----------+---------+--------+---------------------+
| order_id | user_id | amount | order_time          |
+----------+---------+--------+---------------------+
| 2        | 101     | 50.00  | 2023-10-01 10:03:00 |
+----------+---------+--------+---------------------+
*/

-- DDL and DML
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id INT,
    user_id INT,
    amount DECIMAL(10, 2),
    order_time DATETIME
);

INSERT INTO orders (order_id, user_id, amount, order_time) VALUES
(1, 101, 50.00, '2023-10-01 10:00:00'),
(2, 101, 50.00, '2023-10-01 10:03:00'),
(3, 101, 20.00, '2023-10-01 10:04:00'),
(4, 102, 100.00, '2023-10-01 11:00:00'),
(5, 102, 100.00, '2023-10-01 11:10:00');

/*
Problem Solving Approach:
1. Use `LAG()` to get the previous order's time and amount for the same user.
2. Filter for rows where the `amount` equals the `prev_amount`.
3. Calculate the time difference in minutes using `TIMESTAMPDIFF(MINUTE, prev_time, order_time)`.
4. Keep only the rows where the time difference is less than or equal to 5.
*/

-- Optimized Solution
WITH OrderHistory AS (
    SELECT 
        order_id,
        user_id,
        amount,
        order_time,
        LAG(amount) OVER(PARTITION BY user_id ORDER BY order_time) as prev_amount,
        LAG(order_time) OVER(PARTITION BY user_id ORDER BY order_time) as prev_time
    FROM orders
)
SELECT 
    order_id,
    user_id,
    amount,
    order_time
FROM OrderHistory
WHERE amount = prev_amount
AND TIMESTAMPDIFF(MINUTE, prev_time, order_time) <= 5;
