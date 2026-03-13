/*
### Problem Description
You are given an `orders` table. Find customers who bought items from at least two different product categories and paid using different payment methods for each category.

### Sample Input and Output
**Input: orders**
| order_id | customer_id | product_category | payment_method |
|---|---|---|---|
| 1 | 100 | 'Electronics' | 'Credit Card' |
| 2 | 100 | 'Clothing' | 'Cash' |
| 3 | 101 | 'Electronics' | 'Credit Card' |
| 4 | 101 | 'Clothing' | 'Credit Card' |
| 5 | 102 | 'Groceries' | 'Cash' |

**Output:**
| customer_id |
|---|
| 100 |
*/

-- DDL and DML commands
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id INT,
    customer_id INT,
    product_category VARCHAR(50),
    payment_method VARCHAR(50)
);

INSERT INTO orders (order_id, customer_id, product_category, payment_method) VALUES
(1, 100, 'Electronics', 'Credit Card'),
(2, 100, 'Clothing', 'Cash'),
(3, 101, 'Electronics', 'Credit Card'),
(4, 101, 'Clothing', 'Credit Card'),
(5, 102, 'Groceries', 'Cash');


/*
### Approach
We need to group by `customer_id` and ensure two conditions are met:
1. They bought from more than 1 distinct product category.
2. They used more than 1 distinct payment method.

We can achieve this elegantly using the `HAVING` clause paired with `COUNT(DISTINCT ...)`.
*/










-- Optimized Solution
SELECT customer_id
FROM orders
GROUP BY customer_id
HAVING COUNT(DISTINCT product_category) > 1
   AND COUNT(DISTINCT payment_method) > 1;
