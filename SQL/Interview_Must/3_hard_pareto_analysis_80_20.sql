/*
### Problem Description
Write a query to identify the customers who contribute to the top 80% of total revenue.
Return their `customer_id` and their total `spend`.

### Sample Input and Output
**Input: SalesOrders**
| customer_id | spend |
|---|---|
| 1 | 5000 | 
| 2 | 3000 |  
| 3 | 1000 |
| 4 | 1000 |

**Output:**
| customer_id | spend |
|---|---|
| 1 | 5000 |
| 2 | 3000 |

*Explanation:* 
Total revenue across all customers is 10,000. 80% of total revenue is 8,000.
Customer 1 brings in 5,000. Cumulative = 5,000 (<= 8000, keep)
Customer 2 brings in 3,000. Cumulative = 8,000 (<= 8000, keep)
Customer 3 brings in 1,000. Cumulative = 9,000 (> 8000, ignore)
*/

-- DDL and DML commands
DROP TABLE IF EXISTS SalesOrders;
CREATE TABLE SalesOrders (
    customer_id INT,
    spend DECIMAL(10, 2)
);

INSERT INTO SalesOrders (customer_id, spend) VALUES
(1, 5000.00), 
(2, 3000.00),  
(3, 1000.00),
(4, 1000.00);


/*
### Approach
This requires calculating a running total (cumulative sum) of revenue, ordered by the highest spending customers first.
1. Determine total spend per customer.
2. Determine the Absolute Total Spend (`SUM(spend) OVER()`).
3. Determine the Cumulative Spend ordered top-down (`SUM(spend) OVER(ORDER BY spend DESC)`).
4. Filter for customers where their cumulative spend is `<= 0.80 * Absolute Total Spend`.
*/










-- Optimized Solution
WITH CustomerSpend AS (
    SELECT 
        customer_id,
        SUM(spend) as total_customer_spend
    FROM SalesOrders
    GROUP BY customer_id
),
ParetoWindow AS (
    SELECT 
        customer_id,
        total_customer_spend,
        SUM(total_customer_spend) OVER (ORDER BY total_customer_spend DESC) AS cumulative_spend,
        SUM(total_customer_spend) OVER () AS total_overall_revenue
    FROM CustomerSpend
)
SELECT 
    customer_id, 
    total_customer_spend AS spend
FROM ParetoWindow
WHERE cumulative_spend <= 0.80 * total_overall_revenue;
