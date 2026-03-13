-- ============================================================
-- Case-Insensitive String Matching
-- ============================================================
-- MySQL's default collation (utf8mb4_0900_ai_ci) is already
-- case-insensitive, so plain = or LIKE work without wrapping.
-- However, many production databases use binary collations
-- (case-sensitive). The safe, portable pattern is to normalise
-- both sides to the same case before comparing.
-- ============================================================

-- Sample Input: transactions
-- +----+---------------+--------+
-- | id | customer_name | amount |
-- +----+---------------+--------+
-- |  1 | Shilpa        |   500  |
-- |  2 | SHILPA        |   700  |
-- |  3 | shilpa        |   300  |
-- |  4 | Rahul         |   200  |
-- |  5 | RAHUL         |   150  |
-- +----+---------------+--------+
--
-- Goal: fetch all transactions for "shilpa" regardless of casing.
--
-- Expected Output:
-- +----+---------------+--------+
-- | id | customer_name | amount |
-- +----+---------------+--------+
-- |  1 | Shilpa        |   500  |
-- |  2 | SHILPA        |   700  |
-- |  3 | shilpa        |   300  |
-- +----+---------------+--------+

-- ============================================================
-- DDL & DML
-- ============================================================

DROP TABLE IF EXISTS transactions_ci;

CREATE TABLE transactions_ci (
    id            INT PRIMARY KEY,
    customer_name VARCHAR(100),
    amount        INT
);

INSERT INTO transactions_ci VALUES
    (1, 'Shilpa', 500),
    (2, 'SHILPA', 700),
    (3, 'shilpa', 300),
    (4, 'Rahul',  200),
    (5, 'RAHUL',  150);

-- ============================================================
-- Hint
-- ============================================================
-- Wrap the column in UPPER() and compare to UPPER(search_term).
-- This works on any collation. Avoid storing a manual UPPER()
-- result on the search side only — the column side must be
-- normalised too, otherwise casing mismatches slip through.

-- ============================================================
-- Solution 1: UPPER() on both sides (safest, portable)
-- ============================================================

SELECT id, customer_name, amount
FROM   transactions_ci
WHERE  UPPER(customer_name) = UPPER('shilpa');

-- ============================================================
-- Solution 2: LOWER() pattern (same concept)
-- ============================================================

SELECT id, customer_name, amount
FROM   transactions_ci
WHERE  LOWER(customer_name) = 'shilpa';

-- ============================================================
-- Solution 3: LIKE with wildcard (partial match)
-- ============================================================
-- Use LIKE when you want substring matching (e.g. first name only).

SELECT id, customer_name, amount
FROM   transactions_ci
WHERE  UPPER(customer_name) LIKE UPPER('%shilpa%');

-- ============================================================
-- Cleanup
-- ============================================================
DROP TABLE IF EXISTS transactions_ci;
