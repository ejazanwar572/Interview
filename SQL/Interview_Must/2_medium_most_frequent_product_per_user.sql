/*
Problem Description:
Find the most frequently purchased product for each user. If there is a tie, return the product that was most recently purchased among the tied products.

Sample Input:
purchases table:
+-------------+---------+------------+---------------------+
| purchase_id | user_id | product_id | purchase_date       |
+-------------+---------+------------+---------------------+
| 1           | 1       | 101        | 2023-10-01 10:00:00 |
| 2           | 1       | 101        | 2023-10-05 10:00:00 |
| 3           | 1       | 102        | 2023-10-02 10:00:00 |
| 4           | 1       | 102        | 2023-10-06 10:00:00 |
| 5           | 2       | 103        | 2023-10-01 10:00:00 |
+-------------+---------+------------+---------------------+

Sample Output:
+---------+------------+----------------+
| user_id | product_id | purchase_count |
+---------+------------+----------------+
| 1       | 102        | 2              |
| 2       | 103        | 1              |
+---------+------------+----------------+
*/

-- DDL and DML
DROP TABLE IF EXISTS purchases;
CREATE TABLE purchases (
    purchase_id INT,
    user_id INT,
    product_id INT,
    purchase_date DATETIME
);

INSERT INTO purchases (purchase_id, user_id, product_id, purchase_date) VALUES
(1, 1, 101, '2023-10-01 10:00:00'),
(2, 1, 101, '2023-10-05 10:00:00'),
(3, 1, 102, '2023-10-02 10:00:00'),
(4, 1, 102, '2023-10-06 10:00:00'),
(5, 2, 103, '2023-10-01 10:00:00');

/*
Problem Solving Approach:
1. Aggregate the `purchases` table to count the number of purchases per user and product (`COUNT(*)`).
2. Also retrieve the `MAX(purchase_date)` for that specific product and user tie-breaking.
3. Use the `ROW_NUMBER()` window function partitioned by `user_id` and ordered by the `purchase_count DESC` and then the `last_purchased_date DESC`.
4. Filter out rank = 1 to get the top product according to this criteria.
*/

-- Optimized Solution
WITH ProductFreq AS (
    SELECT 
        user_id,
        product_id,
        COUNT(*) as purchase_count,
        MAX(purchase_date) as last_purchased
    FROM purchases
    GROUP BY user_id, product_id
),
RankedProducts AS (
    SELECT 
        user_id,
        product_id,
        purchase_count,
        ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY purchase_count DESC, last_purchased DESC) as rnk
    FROM ProductFreq
)
SELECT 
    user_id,
    product_id,
    purchase_count
FROM RankedProducts
WHERE rnk = 1;
