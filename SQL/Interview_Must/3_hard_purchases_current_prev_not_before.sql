/*
### Problem Description
Write a SQL query to find customers who made purchases in both the current year (e.g., 2024) and the previous year (2023), but NOT in the year before that (2022).

### Sample Input and Output
**Input: purchases**
| customer_id | purchase_date | amount |
|---|---|---|
| 1 | '2024-05-10' | 100 |
| 1 | '2023-06-15' | 150 |
| 2 | '2024-01-20' | 200 |
| 3 | '2024-08-11' | 300 |
| 3 | '2023-09-01' | 100 |
| 3 | '2022-12-10' | 400 |

**Output:**
| customer_id |
|---|
| 1 |
*/

-- DDL and DML commands
DROP TABLE IF EXISTS purchases;
CREATE TABLE purchases (
    customer_id INT,
    purchase_date DATE,
    amount DECIMAL(10, 2)
);

INSERT INTO purchases (customer_id, purchase_date, amount) VALUES
(1, '2024-05-10', 100.00),
(1, '2023-06-15', 150.00), -- Valid: Purchased in 2024 and 2023 only.

(2, '2024-01-20', 200.00), -- Invalid: Missing 2023 purchase.

(3, '2024-08-11', 300.00),
(3, '2023-09-01', 100.00),
(3, '2022-12-10', 400.00); -- Invalid: Purchased in 2022.


/*
### Approach
To determine this dynamically, we must evaluate the yearly conditions per customer.
We can utilize `GROUP BY customer_id` and apply aggregate conditional filtering using `HAVING`.
We sum occurrences using `CASE WHEN` to test if they had any orders in a specific year.
  - condition 1: They had at least 1 purchase in Current Year [YEAR(purchase_date) = YEAR(CURRENT_DATE)]
  - condition 2: They had at least 1 purchase in Previous Year [YEAR(purchase_date) = YEAR(CURRENT_DATE) - 1]
  - condition 3: They had EXACTLY 0 purchases in the Two Years Ago period [YEAR(purchase_date) = YEAR(CURRENT_DATE) - 2]
*/

SELECT customer_id
FROM purchases
GROUP BY customer_id
HAVING 
    SUM(CASE WHEN EXTRACT(YEAR FROM purchase_date) = EXTRACT(YEAR FROM CURRENT_DATE) THEN 1 ELSE 0 END) > 0
    AND 
    SUM(CASE WHEN EXTRACT(YEAR FROM purchase_date) = EXTRACT(YEAR FROM CURRENT_DATE) - 1 THEN 1 ELSE 0 END) > 0
    AND 
    SUM(CASE WHEN EXTRACT(YEAR FROM purchase_date) = EXTRACT(YEAR FROM CURRENT_DATE) - 2 THEN 1 ELSE 0 END) = 0;
