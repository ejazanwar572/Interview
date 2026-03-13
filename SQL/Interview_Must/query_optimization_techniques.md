# SQL Query Optimization Techniques

This document outlines common strategies, pitfalls, and best practices for optimizing slow-running SQL queries. These techniques are universally applicable whether you are querying massive data warehouses (BigQuery, Snowflake) or transactional databases (MySQL, PostgreSQL).

---

## 1. Avoid `SELECT *`

- **The Pitfall:** Selecting all columns (`*`) consumes unnecessary memory, CPU, and network bandwidth between the database server and the application. This is especially true if the table has `TEXT` or `JSON` blobs.
- **The Optimization:** Only explicitly select the specific columns you actually need for your analysis or application. This dramatically reduces I/O.

## 2. Write "Sargable" Queries (Index-Friendly Filtering)

- **What is "SARGable"?:** Search ARGument ABLE. It means writing your `WHERE` clause in a way that allows the database engine to utilize its indexes effectively.
- **The Pitfall:** Wrapping an indexed column inside a SQL function (e.g., `YEAR(sale_date) = 2023`) completely blinds the database optimizer. Because the column values are altered, the engine is forced into a **Full Table Scan** instead of an **Index Seek**.
- **The Optimization:** Keep the column isolation naked on one side of the operator.
  - ❌ _Bad (Functions on the column void the index):_ `WHERE YEAR(sale_date) = 2023`
  - ✅ _Good (Maintains the index):_ `WHERE sale_date >= '2023-01-01' AND sale_date < '2024-01-01'`

## 3. Replace Comma Joins with Explicit `JOIN`s

- **The Pitfall:** Using the old ANSI-89 comma join syntax (`FROM sales, customers WHERE sales.cust_id = customers.id`) is prone to errors. If a developer accidentally misses a `WHERE` condition, it will silently result in a catastrophic **Cartesian Product (CROSS JOIN)**.
- **The Optimization:** Use explicit `INNER JOIN` or `LEFT JOIN` syntax (ANSI-92). This strictly separates the join logic (the `ON` clause) from the filtering logic (the `WHERE` clause), making execution planning more reliable.

## 4. Evaluate Subqueries vs. CTEs vs. Temporary Tables

- **The Pitfall:** Using correlated subqueries in the `SELECT` or `WHERE` clause can cause the subquery to evaluate individually for _every single row_ returned by the outer query—scaling at an abysmal `O(N^2)` complexity.
- **The Optimization:** Materialize the required subquery result first. Use a Common Table Expression (CTE) or explicitly create a Temporary Table to calculate the aggregate or subset exactly _once_. Then, simply join that resulting subset to your main query.

## 5. Prune Data Early (Filter Before You Join)

- **The Pitfall:** Joining massive tables together and then filtering them at the very end forces the database to construct and hold a gargantuan intermediate dataset in memory, which often results in spilling out to slow disk storage.
- **The Optimization:** Apply filters (`WHERE`, `HAVING`) on the individual tables or within a CTE _before_ joining them to other large tables. This reduces the number of rows passing through the expensive `JOIN` operator.

## 6. Analyze Execution Plans (`EXPLAIN`)

- **The Ultimate Tool:** If a query is inexplicably slow, guessing won't help. Prepend the word `EXPLAIN` (or `EXPLAIN ANALYZE` in PostgreSQL to execute and benchmark) to the front of your query.
- **What to look for:** Look for operators like "Seq Scan" or "Table Scan" on massive tables, or nested loop joins on unindexed columns. The planner map tells you exactly where the majority of the cost/time is being spent so you can add appropriate physical indices.

---

### Example: Before and After Optimization

**Input Query (Slow and Poorly Written):**

```sql
SELECT *
FROM sales s, customers c
WHERE s.customer_id = c.id
  AND YEAR(s.sale_date) = 2023
  AND s.amount > (SELECT AVG(amount) FROM sales);
```

**Optimized Query:**

```sql
-- 1. Use a CTE to calculate the expensive overall average exactly ONCE
WITH AvgSales AS (
    SELECT AVG(amount) AS overall_avg
    FROM sales
)
SELECT
    -- 2. Explicitly define only the columns needed (no SELECT *)
    c.name,
    s.sale_date,
    s.amount
FROM sales s
-- 3. Use explicit INNER JOIN syntax
INNER JOIN customers c ON s.customer_id = c.id
-- 4. Cross join the materialized single-row CTE to access the average
CROSS JOIN AvgSales a
-- 5. Use Sargable filtering conditions to properly utilize any dates indexes
WHERE s.sale_date >= '2023-01-01'
  AND s.sale_date < '2024-01-01'
  AND s.amount > a.overall_avg;
```
