# Advanced SQL Interview Questions for Senior Data Roles

For mid-to-senior data roles (Data Engineers, Senior Analysts, Data Scientists), interviewers move past basic `JOIN`/`GROUP BY` mechanics. They test your ability to handle complex temporal data (time-series), optimize performance, model data correctly, and solve intricate analytical logic with readable code.

---

## 1. Window Functions & Analytics
*Window functions are the absolute core of any advanced SQL interview. You must know them perfectly.*

*   **Diffs & Trends:** "Given a table of daily stock prices, write a query to calculate the continuous percentage change in price from the previous trading day, explicitly skipping weekends and holidays." *(Tests: `LAG()` with partitioning and date logic).*
*   **Running Totals:** "How would you calculate a running total of gross sales for each product category, but have the total explicitly reset at the beginning of each calendar month?" *(Tests: `SUM() OVER (PARTITION BY ... ORDER BY ...)`).*
*   **Rolling Averages:** "Calculate a 7-day rolling average of user sign-ups to smooth out daily volatility." *(Tests: Window frames using `ROWS BETWEEN 6 PRECEDING AND CURRENT ROW`).*
*   **Top N per Group:** "Write a query to find the top 3 highest-paid employees in each department. Explain the exact differences between `ROW_NUMBER()`, `RANK()`, and `DENSE_RANK()` in your solution."
*   **Logical Execution:** "Can a window function be used directly in a `WHERE` clause? Why or why not? How would you filter results based on a window function's output?" *(Tests: Knowledge of SQL order of execution; requires CTEs/Subqueries).*

---

## 2. Gaps and Islands Problems
*This is a classic "Senior" weed-out pattern. It tests your ability to identify consecutive sequences or periods of inactivity.*

*   **Consecutive Streaks:** "Given a `user_login` table with `user_id` and `login_timestamp`, write a query to identify all users who have logged in for 5 or more consecutive days. Provide the start and end date of that streak." *(Tests: Grouping by subtracting `ROW_NUMBER()` from the actual date).*
*   **Defining Sessions:** "How would you compute the total number of unique search sessions for users based on their activity timestamps, where a 'new session' is defined by a gap of more than 30 minutes between consecutive events?" *(Tests: `LAG()`, running sums, and complex state changes).*
*   **Stock Out Periods:** "An inventory table records `product_id`, `date`, and `quantity_on_hand`. Identify all time periods (start and end dates) where a product had exactly zero inventory for 3 or more consecutive days."

---

## 3. Query Performance & Optimization
*Seniors are expected to write code that scales across billions of rows without breaking the Data Warehouse.*

*   **Debugging Slow Logic:** "You are handed a notoriously slow query written by a junior analyst that currently takes 45 minutes to run. Walk me through exactly how you would diagnose and optimize it." *(Tests: `EXPLAIN` plans, removing `SELECT *`, assessing join types, checking for functional indexing issues).*
*   **Join Optimization:** "Explain the difference between a Hash Join, a Merge Join, and a Nested Loop Join. Under what circumstances would the database query optimizer choose one over the others?"
*   **Handling Skew:** "You are joining a massive fact table on a `customer_id` key, but one specific 'default' customer_id generates 40% of the traffic. How do you handle this data skew in a distributed environment like Spark SQL or Snowflake?" *(Tests: Salting, broadcast joins).*

---

## 4. Advanced Data Manipulation & Edge Cases
*Testing how you handle complex realities of messy data.*

*   **Recursive Logic:** "Given an `Employees` table with `employee_id` and `manager_id`, write a query to output the full management hierarchy for a specific employee all the way up to the CEO." *(Tests: Recursive CTEs and hierarchical data).*
*   **Pivoting/Unpivoting:** "You receive a dataset where monthly revenue is stored in columns (e.g., `jan_rev`, `feb_rev`). Write a query to unpivot this data into a long format with rows for `month` and `revenue`." *(Tests: `UNPIVOT` or `UNION ALL` patterns).*
*   **Merge Operations:** "Explain the `MERGE` (or `UPSERT`) statement. How do you handle inserting new records and updating existing records conditionally in a single pass without using complex temp tables?"
*   **NULL Handling:** "What is the difference between `COALESCE` and `ISNULL`? What logic error happens if you try to compare a value directly to `NULL` using `=` instead of `IS NULL`?"
