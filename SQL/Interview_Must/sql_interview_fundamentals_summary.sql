/*
================================================================================
SQL Interview Fundamentals: Synthesis of Core Concepts
================================================================================
This document summarizes core SQL concepts frequently tested in interviews,
synthesized from recent industry insights and carefully fact-checked for accuracy.
*/

/*
--------------------------------------------------------------------------------
1. AGGREGATIONS & PERFORMANCE: COUNT(*) vs. COUNT(column)
--------------------------------------------------------------------------------
- Behavioral Difference: COUNT(*) counts all rows in the dataset, regardless of
  their content. COUNT(column) counts only rows where the specified column is
  NOT NULL.
- Performance Impact: COUNT(*) is almost universally faster. Database engines
  treat it as a special optimized command.
- Overhead of COUNT(column): Utilizing COUNT(column) forces the database engine
  to check rows individually for NULL compliance, adding CPU overhead, requiring
  index/column data scanning, and generating higher I/O if the column blocks
  must be fetched from disk.
*/

-- EXAMPLE:
SELECT 
    COUNT(*) AS total_users,           -- Very fast, gets total row count in 'users'
    COUNT(email_address) AS users_with_email -- Slower, checks each row to see if email_address IS NOT NULL
FROM users;

/*
--------------------------------------------------------------------------------
2. FILTERING: WHERE vs. HAVING
--------------------------------------------------------------------------------
- Order of Execution: The WHERE clause filters rows BEFORE any grouping or
  aggregation takes place. The HAVING clause filters AFTER the GROUP BY
  aggregation has occurred.
- Interview Application: Trying to use aggregate functions (like SUM() or
  COUNT()) inside a WHERE clause is a fatal error in interviews. Knowing when
  to apply which filter demonstrates a fundamental understanding of SQL's
  logical execution order.
*/

-- CORRECT APPLICATION:
SELECT department_id, COUNT(*) AS employee_count 
FROM employees
WHERE status = 'Active'               -- 1. Filters base rows first
GROUP BY department_id                -- 2. Groups the remaining rows
HAVING COUNT(*) > 10;                 -- 3. Filters the aggregated groups

-- FATAL INTERVIEW ERROR: 
-- SELECT department_id FROM employees WHERE COUNT(*) > 10 GROUP BY department_id;


/*
--------------------------------------------------------------------------------
3. DEALING WITH UNKNOWNS: HANDLING NULL
--------------------------------------------------------------------------------
- The Three-Valued Logic: Many candidates claim that 'NULL = NULL' results in
  FALSE. *This is factually incorrect.* Evaluating 'NULL = NULL' returns UNKNOWN.
  While UNKNOWN acts like FALSE in a simple WHERE clause (filtering the row out),
  it behaves differently under negation (NOT (UNKNOWN) is still UNKNOWN).
- Best Practice: Never use equality operators with NULL. Always explicitly use
  'IS NULL' or 'IS NOT NULL'.
*/

-- EXAMPLE:
SELECT employee_id, name, bonus_amount
FROM employee_bonuses
WHERE bonus_amount IS NULL;           -- CORRECT: Safely identifies employees without a bonus

-- INCORRECT:
SELECT employee_id FROM employee_bonuses WHERE bonus_amount = NULL; -- This evaluates to UNKNOWN and returns 0 rows.




/*
--------------------------------------------------------------------------------
5. STRUCTURING RESULTS: GROUP BY vs. WINDOW FUNCTIONS
--------------------------------------------------------------------------------
- GROUP BY: Collapses rows into summary metrics, inherently reducing the
  granularity (row count) of your query. Selecting unaggregated columns not
  included in the GROUP BY clause is a classic query failure.
- Window Functions: Functions like ROW_NUMBER(), RANK(), and SUM() OVER() allow
  you to calculate aggregate or sequence metrics without reducing the result
  set—they append the calculation at the original row level.
*/

-- GROUP BY EXAMPLE: Rows are reduced to distinct departments
SELECT department, SUM(salary) AS total_dept_salary
FROM employees
GROUP BY department;

-- WINDOW FUNCTION EXAMPLE: Rows are preserved, containing all individual employee details
SELECT 
    employee_id, 
    department, 
    salary,
    SUM(salary) OVER (PARTITION BY department) AS total_dept_salary -- Attached to each original row
FROM employees;


/*
--------------------------------------------------------------------------------
6. QUERY READABILITY AND ARCHITECTURE
--------------------------------------------------------------------------------
- CTEs vs. Subqueries: Common Table Expressions (CTEs) are overwhelmingly
  preferred over nested subqueries in interview environments. CTEs break down
  logic chronologically, making the code vastly more readable and easier for
  both you and the interviewer to debug.
- Misplaced Operations: Using ORDER BY inside a subquery or CTE is generally an
  anti-pattern (and banned in some RDBMS). The external query determines order.
- The DISTINCT Band-Aid: Relying on DISTINCT to resolve duplicate rows is often
  viewed as masking a symptom. Duplicate rows usually indicate a flawed join
  condition or bad grain logic. Fix the root cause, don't just hide it.
*/

-- EXAMPLE: Utilizing CTEs for modular, readable query design rather than wrapping subqueries
WITH active_customers AS (
    SELECT customer_id, name
    FROM customers
    WHERE status = 'Active'
),
recent_orders AS (
    SELECT order_id, customer_id, order_total
    FROM orders
    WHERE order_date >= '2026-01-01'
)
SELECT 
    a.name, 
    COUNT(r.order_id) AS order_count,
    SUM(r.order_total) AS total_spent
FROM active_customers a
LEFT JOIN recent_orders r 
    ON a.customer_id = r.customer_id
GROUP BY a.name
ORDER BY total_spent DESC;            -- Let the final query handle the sorting


