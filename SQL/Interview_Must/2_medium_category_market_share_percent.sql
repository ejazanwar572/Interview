/*
Problem Description:
Calculate the market share percentage of each product category within overall total company sales.

Sample Input:
sales table:
+---------+-------------+--------+
| sale_id | category    | amount |
+---------+-------------+--------+
| 1       | Electronics | 500.0  |
| 2       | Electronics | 300.0  |
| 3       | Clothing    | 100.0  |
| 4       | Clothing    | 50.0   |
| 5       | Books       | 50.0   |
+---------+-------------+--------+

Sample Output:
+-------------+--------------+-------------------+
| category    | category_sum | market_share_pct  |
+-------------+--------------+-------------------+
| Electronics | 800.0        | 80.00             |
| Clothing    | 150.0        | 15.00             |
| Books       | 50.0         | 5.00              |
+-------------+--------------+-------------------+
*/

-- DDL and DML
DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
    sale_id INT,
    category VARCHAR(50),
    amount DECIMAL(10, 2)
);

INSERT INTO sales (sale_id, category, amount) VALUES
(1, 'Electronics', 500.0),
(2, 'Electronics', 300.0),
(3, 'Clothing', 100.0),
(4, 'Clothing', 50.0),
(5, 'Books', 50.0);

/*
Problem Solving Approach:
1. Aggregate the total sales amount per category.
2. Use a window function `SUM() OVER()` without a partition to compute the grand total across all categories.
3. Divide the category total by the grand total, and multiply by 100 to get the percentage.
*/

-- Optimized Solution
WITH CategoryTotals AS (
    SELECT 
        category,
        SUM(amount) as category_sum
    FROM sales
    GROUP BY category
)
SELECT 
    category,
    category_sum,
    ROUND((category_sum / SUM(category_sum) OVER()) * 100, 2) as market_share_pct
FROM CategoryTotals
ORDER BY market_share_pct DESC;
