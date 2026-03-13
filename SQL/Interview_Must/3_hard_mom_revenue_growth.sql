/*
### Problem Description
Calculate month-over-month revenue growth percentage.

### Sample Input and Output
**Input: orders**
| order_date | amount |
|---|---|

**Output:**
| month | revenue | prev_month_revenue | mom_growth_pct |
*/

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (order_date DATE, amount DECIMAL);

/*
### Approach
Group by truncated month to get monthly revenue in a CTE. In the main query, use LAG() to get the previous month's revenue and compute percentage growth.
*/

WITH monthly AS (
  SELECT DATE_FORMAT(order_date, '%Y-%m-01') AS month, SUM(amount) AS revenue 
  FROM orders 
  GROUP BY 1
)
SELECT month, revenue,
       LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue,
       ROUND(
         100.0 * (revenue - LAG(revenue) OVER (ORDER BY month)) / LAG(revenue) OVER (ORDER BY month),
       2) AS mom_growth_pct 
FROM monthly;
