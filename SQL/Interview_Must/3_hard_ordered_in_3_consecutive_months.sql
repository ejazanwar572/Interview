/*
Problem Description:
Find users who have placed an order in at least 3 consecutive months.

Sample Input:
orders table:
+----------+---------+------------+
| order_id | user_id | order_date |
+----------+---------+------------+
| 1        | 101     | 2023-01-15 |
| 2        | 101     | 2023-02-10 |
| 3        | 101     | 2023-03-05 |
| 4        | 102     | 2023-01-20 |
| 5        | 102     | 2023-03-15 |
+----------+---------+------------+

Sample Output:
+---------+
| user_id |
+---------+
| 101     |
+---------+
*/

-- DDL and DML
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id INT,
    user_id INT,
    order_date DATE
);

INSERT INTO orders (order_id, user_id, order_date) VALUES
(1, 101, '2023-01-15'),
(2, 101, '2023-02-10'),
(3, 101, '2023-03-05'),
(4, 102, '2023-01-20'),
(5, 102, '2023-03-15');

/*
Problem Solving Approach:
1. Extract the distinct year and month combinations for each user's orders using `DATE_FORMAT(order_date, '%Y-%m-01')`.
2. Generate a continuous month rank `EXTRACT(YEAR_MONTH FROM order_date)` or utilize `PERIOD_DIFF`.
3. An alternative approach is using `LEAD()` to get the next two distinct ordering months for each user.
4. Calculate the difference in months exactly between the current month and the month from two rows later (`LEAD(..., 2)`).
5. If the `PERIOD_DIFF()` or `TIMESTAMPDIFF(MONTH)` between them is exactly 2, the user has 3 consecutive ordered months.
*/

-- Optimized Solution
WITH DistinctUserMonths AS (
    SELECT DISTINCT 
        user_id, 
        DATE_FORMAT(order_date, '%Y-%m-01') as order_month
    FROM orders
),
NextMonths AS (
    SELECT 
        user_id,
        order_month,
        LEAD(order_month, 2) OVER(PARTITION BY user_id ORDER BY order_month) as third_month
    FROM DistinctUserMonths
)
SELECT DISTINCT user_id
FROM NextMonths
WHERE third_month IS NOT NULL 
AND TIMESTAMPDIFF(MONTH, order_month, third_month) = 2;
