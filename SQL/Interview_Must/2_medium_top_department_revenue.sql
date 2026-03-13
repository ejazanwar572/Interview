/*
### Problem Description
Given a `Sales` table containing daily transaction records, find the top department based on total revenue. Revenue is calculated as `Qty * Unit_Price`. You must use a SQL window function to solve this.

### Sample Input and Output
**Input: Sales**
| Date | dept | product | store | Qty | Unit_Price |
|---|---|---|---|---|---|
| 10/03/2026 | Apprale | P1 | S1 | 5 | 50 |
| 11/03/2026 | Footweat | P2 | S2 | 7 | 63 |
| 10/03/2026 | Accesories | P3 | S3 | 9 | 67 |
| 11/03/2026 | Apprale | P4 | S1 | 10 | 74 |
| 10/03/2026 | Footweat | P2 | S1 | 6 | 93 |
| 10/03/2026 | Accesories | P3 | S3 | 8 | 90 |

**Output:**
| dept | total_revenue |
|---|---|
| Accesories | 1323 |
*/

-- DDL and DML commands
DROP TABLE IF EXISTS Sales;
CREATE TABLE Sales (
    Date DATE,
    dept VARCHAR(50),
    product VARCHAR(10),
    store VARCHAR(10),
    Qty INT,
    Unit_Price DECIMAL(10, 2)
);

INSERT INTO Sales (Date, dept, product, store, Qty, Unit_Price) VALUES
('2026-03-10', 'Apprale', 'P1', 'S1', 5, 50.00),
('2026-03-11', 'Footweat', 'P2', 'S2', 7, 63.00),
('2026-03-10', 'Accesories', 'P3', 'S3', 9, 67.00),
('2026-03-11', 'Apprale', 'P4', 'S1', 10, 74.00),
('2026-03-10', 'Footweat', 'P2', 'S1', 6, 93.00),
('2026-03-10', 'Accesories', 'P3', 'S3', 8, 90.00);





/*
### Approach
Yes, you can absolutely do the calculation `Qty * Unit_Price` directly inside the window function!

To answer the question using **only** window functions (without using `GROUP BY`), we can use `SUM(Qty * Unit_Price) OVER(PARTITION BY dept)`.
This calculates the total revenue per department and appends it to every row.
Because this repeats the total for every transaction in that department, we use `SELECT DISTINCT` to get just one row per department.
Then, we rank those distinct department totals.
*/

WITH DeptRevenue AS (
    -- 1. Calculate the total revenue per department inside the window function itself
    SELECT DISTINCT
        dept,
        SUM(Qty * Unit_Price) OVER (PARTITION BY dept) as total_revenue
    FROM Sales
),
RankedDepartments AS (
    -- 2. Rank the departments based on their total revenue
    SELECT 
        dept,
        total_revenue,
        RANK() OVER (ORDER BY total_revenue DESC) as revenue_rank
    FROM DeptRevenue
)
-- 3. Filter for the top ranked department
SELECT dept, total_revenue 
FROM RankedDepartments 
WHERE revenue_rank = 1;

/*
### Alternative Solutions

1. `GROUP BY` + `ORDER BY` + `LIMIT 1`
Provides the absolute best performance but does not safely handle ties.

SELECT 
    dept, 
    SUM(Qty * Unit_Price) AS total_revenue
FROM Sales
GROUP BY dept
ORDER BY total_revenue DESC
LIMIT 1;

2. `GROUP BY` + Window Function `RANK()`
Usually faster than pure window function as it reduces rows before ranking, handles ties.

WITH DeptRevenue AS (
    SELECT 
        dept,
        SUM(Qty * Unit_Price) AS total_revenue
    FROM Sales
    GROUP BY dept
),
RankedDepartments AS (
    SELECT 
        dept,
        total_revenue,
        RANK() OVER (ORDER BY total_revenue DESC) as revenue_rank
    FROM DeptRevenue
)
SELECT dept, total_revenue 
FROM RankedDepartments 
WHERE revenue_rank = 1;

3. `GROUP BY` + Subquery with `MAX()`
Very safe explicitly matching against the absolute MAX derived logically.

WITH DeptRevenue AS (
    SELECT 
        dept,
        SUM(Qty * Unit_Price) AS total_revenue
    FROM Sales
    GROUP BY dept
)
SELECT dept, total_revenue
FROM DeptRevenue
WHERE total_revenue = (SELECT MAX(total_revenue) FROM DeptRevenue);
*/
