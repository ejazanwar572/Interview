-- ============================================================
-- Swap Column Values Atomically Using CASE WHEN in UPDATE
-- ============================================================
-- Problem: A column contains two values that were entered
-- incorrectly (e.g. 'M' and 'F' are reversed for all rows).
-- Swap them in a single UPDATE so neither intermediate state
-- corrupts the data. Running two separate UPDATEs would cause
-- all rows to end up with the same value.
-- ============================================================

-- Sample Input: customers
-- +----+----------+--------+
-- | id | name     | gender |
-- +----+----------+--------+
-- |  1 | Alice    | M      |  <- wrong, should be F
-- |  2 | Bob      | F      |  <- wrong, should be M
-- |  3 | Carol    | M      |  <- wrong, should be F
-- |  4 | Dave     | F      |  <- wrong, should be M
-- +----+----------+--------+
--
-- Expected Output after swap:
-- +----+----------+--------+
-- | id | name     | gender |
-- +----+----------+--------+
-- |  1 | Alice    | F      |
-- |  2 | Bob      | M      |
-- |  3 | Carol    | F      |
-- |  4 | Dave     | M      |
-- +----+----------+--------+

-- ============================================================
-- DDL & DML
-- ============================================================

DROP TABLE IF EXISTS customers_gender;

CREATE TABLE customers_gender (
    id     INT PRIMARY KEY,
    name   VARCHAR(50),
    gender CHAR(1)
);

INSERT INTO customers_gender VALUES
    (1, 'Alice', 'M'),
    (2, 'Bob',   'F'),
    (3, 'Carol', 'M'),
    (4, 'Dave',  'F');

-- Verify before:
SELECT * FROM customers_gender;

-- ============================================================
-- Hint
-- ============================================================
-- A single UPDATE with CASE WHEN evaluates all rows against
-- the ORIGINAL values in one atomic pass — no row sees an
-- already-updated neighbour. This is the correct pattern
-- whenever you need to swap two values.
-- WRONG approach:
--   UPDATE ... SET gender = 'F' WHERE gender = 'M';  -- all M → F
--   UPDATE ... SET gender = 'M' WHERE gender = 'F';  -- now ALL rows become M!

-- ============================================================
-- Solution
-- ============================================================

UPDATE customers_gender
SET gender = CASE
    WHEN gender = 'M' THEN 'F'
    WHEN gender = 'F' THEN 'M'
END;

-- Verify after:
SELECT * FROM customers_gender;

-- ============================================================
-- Cleanup
-- ============================================================
DROP TABLE IF EXISTS customers_gender;
