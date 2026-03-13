/*
### Problem Description
Find customers who have placed more than 3 orders in the last 30 days.

### Sample Input and Output
**Input: orders**
| customer_id | order_date |
|---|---|
| 1 | CURRENT_DATE - 5 |
...

**Output:**
| customer_id | order_count |
|---|---|
*/

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (customer_id INT, order_date DATE);
-- Mock inserts omitted for brevity

/*
### Approach
Filter by date first in the WHERE clause (more efficient), then GROUP BY customer_id and use HAVING COUNT(*) > 3.
*/

SELECT customer_id, COUNT(*) AS order_count 
FROM orders 
WHERE order_date >= CURRENT_DATE - INTERVAL '30 days' 
GROUP BY customer_id 
HAVING COUNT(*) > 3;
