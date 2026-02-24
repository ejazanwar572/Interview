USE practice_sql_db;

-- =============================================
-- SECTION 4: Data Quality & Optimization
-- =============================================
/*
OBJECTIVE:
Identify data issues (duplicates, types) and write optimized queries.

PROBLEMS:
1. Duplicate Removal:
- The 'contacts' table is dirty. It has duplicate emails.
- Write a query to DELETE duplicate records, keeping only the one with the lowest ID.
- (For practice, just SELECT the rows to keep vs rows to delete if you prefer not to actually delete).

2. Data Type Precision (Float vs Decimal):
- The 'transactions' table uses FLOAT for amounts.
- Find records where 'amount_float' does not equal 'amount_decimal'.
- Notice the floating point errors involved in money math.

3. NULL Handling (Anti-Join):
- Find customers who have NEVER placed an order.
- Use 'LEFT JOIN ... WHERE NULL' (Efficient) vs 'NOT IN' (Risky with NULLs).
*/

-- ---------------------------------------------
-- Write your queries below:
-- ---------------------------------------------

-- 1. Identify/Delete Duplicates

-- 2. Float vs Decimal Precision Check

-- 3. Customers who never ordered (Safe Handling)

-- =============================================
-- DDL: RESTORE TABLES (Run this block first)
-- =============================================
DROP TABLE IF EXISTS contacts;

DROP TABLE IF EXISTS transactions;

DROP TABLE IF EXISTS customers_dq;

DROP TABLE IF EXISTS orders_dq;

-- 1. Contacts (Dirty Data)
CREATE TABLE contacts (id INT, email VARCHAR(100));

INSERT INTO
    contacts
VALUES (1, 'a@test.com'),
    (2, 'b@test.com'),
    (3, 'a@test.com'), -- Duplicate of 1
    (4, 'c@test.com'),
    (5, 'b@test.com');
-- Duplicate of 2

-- 2. Transactions (Float vs Decimal)
CREATE TABLE transactions (
    txn_id INT,
    amount_float FLOAT,
    amount_decimal DECIMAL(10, 2)
);

INSERT INTO transactions VALUES (1, 10.1, 10.1), (2, 0.1 + 0.2, 0.3);
-- Classic float error case: 0.1 + 0.2 != 0.3 exactly in float

-- 3. Customers & Orders (For NULL handling)
CREATE TABLE customers_dq (cust_id INT, name VARCHAR(50));

CREATE TABLE orders_dq (order_id INT, cust_id INT);

INSERT INTO
    customers_dq
VALUES (1, 'Alice'),
    (2, 'Bob'),
    (3, 'Charlie');

INSERT INTO orders_dq VALUES (101, 1);
-- Alice ordered
-- Bob and Charlie have no orders