/*
### Problem Description
Given an `orders` table containing the `order_id` and `product_id`, find the most frequently bought pair of products. A pair is defined as two different products purchased in the exact same `order_id`. Return the `product_1`, `product_2`, and the `frequency`. Order by frequency descending.

### Sample Input and Output
**Input: orders**
| order_id | product_id |
|---|---|
| 1 | 10 |
| 1 | 20 |
| 1 | 30 |
| 2 | 10 |
| 2 | 20 |
| 3 | 20 |
| 3 | 30 |

**Output:**
| p1 | p2 | frequency |
|---|---|---|
| 10 | 20 | 2 |
| 20 | 30 | 2 |
| 10 | 30 | 1 |

*Note: You should not output mirrored pairs like (20, 10). Always ensure p1 < p2.*
*/

-- DDL and DML commands
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id INT,
    product_id INT
);

INSERT INTO orders (order_id, product_id) VALUES
(1, 10),
(1, 20),
(1, 30),
(2, 10),
(2, 20),
(3, 20),
(3, 30);


/*
### Approach
This is classic "Market Basket Analysis".
1. We need to pair every product in an order with every other product in the *same* order. We do this by `SELF JOIN`ing the `orders` table on `order_id`.
2. To avoid pairing a product with itself (e.g., 10 and 10), and to avoid duplicate mirrored pairs (e.g., (10, 20) and (20, 10)), we strictly join where `o1.product_id < o2.product_id`.
3. Then, simply `GROUP BY` the two products and `COUNT` the occurrences.
*/










-- Optimized Solution
SELECT 
    o1.product_id AS p1,
    o2.product_id AS p2,
    COUNT(o1.order_id) AS frequency
FROM orders o1
JOIN orders o2
  ON o1.order_id = o2.order_id 
  AND o1.product_id < o2.product_id
GROUP BY 
    o1.product_id, 
    o2.product_id
ORDER BY 
    frequency DESC;
