-- ============================================================
-- JOIN Types — Duplicate Keys and NULL Key Edge Cases
-- ============================================================
-- Interviewers frequently present two tables and ask:
-- "How many rows will each join type return?"
-- This file covers the three key scenarios:
--   Scenario A: All keys match (no NULLs, no mismatches)
--   Scenario B: Non-matching keys exist on both sides
--   Scenario C: Duplicate keys (cartesian product) + NULL keys
-- ============================================================
-- Key Rules to Remember:
--   1. Matching rows: count = |left matches| × |right matches|
--      (Cartesian product within each key group)
--   2. NULL is NOT equal to NULL — NULLs never join.
--   3. LEFT JOIN  = INNER result + unmatched LEFT rows (with NULLs on right)
--   4. RIGHT JOIN = INNER result + unmatched RIGHT rows (with NULLs on left)
--   5. FULL OUTER = INNER + unmatched LEFT + unmatched RIGHT
--   6. If all keys match on both sides → all four joins return identical rows.
-- ============================================================

-- ============================================================
-- SCENARIO A: All matching, no duplicates
-- ============================================================
-- t1: (1,1)   t2: (1,1,1)
-- All 2 rows in t1 match all 3 rows in t2 on key=1.
-- INNER / LEFT / RIGHT / FULL OUTER → all return 2 × 3 = 6 rows.

DROP TABLE IF EXISTS t1_a, t2_a;
CREATE TABLE t1_a (k INT);
CREATE TABLE t2_a (k INT);
INSERT INTO t1_a VALUES (1), (1);
INSERT INTO t2_a VALUES (1), (1), (1);

-- All four joins produce 6 rows:
SELECT 'INNER' AS join_type, COUNT(*) AS row_count
FROM t1_a a INNER JOIN t2_a b ON a.k = b.k
UNION ALL
SELECT 'LEFT',  COUNT(*) FROM t1_a a LEFT  JOIN t2_a b ON a.k = b.k
UNION ALL
SELECT 'RIGHT', COUNT(*) FROM t1_a a RIGHT JOIN t2_a b ON a.k = b.k;
-- Expected: all three → 6

-- ============================================================
-- SCENARIO B: Non-matching rows exist on both sides
-- ============================================================
-- t1: (1,1,2)   t2: (1,1,1,3)
-- key=1 matches: 2 × 3 = 6
-- key=2 in t1 is unmatched → adds 1 row in LEFT and FULL
-- key=3 in t2 is unmatched → adds 1 row in RIGHT and FULL

DROP TABLE IF EXISTS t1_b, t2_b;
CREATE TABLE t1_b (k INT);
CREATE TABLE t2_b (k INT);
INSERT INTO t1_b VALUES (1), (1), (2);
INSERT INTO t2_b VALUES (1), (1), (1), (3);

SELECT 'INNER' AS join_type, COUNT(*) AS row_count
FROM t1_b a INNER JOIN t2_b b ON a.k = b.k   -- 6
UNION ALL
SELECT 'LEFT',  COUNT(*) FROM t1_b a LEFT  JOIN t2_b b ON a.k = b.k  -- 7  (6 + 1 unmatched from left)
UNION ALL
SELECT 'RIGHT', COUNT(*) FROM t1_b a RIGHT JOIN t2_b b ON a.k = b.k; -- 7  (6 + 1 unmatched from right)
-- FULL OUTER would be 8 (6 + 1 + 1) — MySQL does not support FULL OUTER JOIN natively;
-- emulate it with: LEFT JOIN UNION ALL RIGHT JOIN WHERE left_key IS NULL

-- FULL OUTER emulation in MySQL:
SELECT a.k AS left_k, b.k AS right_k
FROM t1_b a LEFT  JOIN t2_b b ON a.k = b.k
UNION ALL
SELECT a.k, b.k
FROM t1_b a RIGHT JOIN t2_b b ON a.k = b.k
WHERE a.k IS NULL;   -- only the unmatched right rows
-- Total rows: 8

-- ============================================================
-- SCENARIO C: NULL keys — NULLs never join
-- ============================================================
-- t1: (1,1,NULL)   t2: (1,1,1,NULL)
-- NULL keys in either table do NOT match each other.
-- key=1: 2 × 3 = 6 matched rows
-- NULL in t1 is unmatched → adds 1 row in LEFT and FULL
-- NULL in t2 is unmatched → adds 1 row in RIGHT and FULL

DROP TABLE IF EXISTS t1_c, t2_c;
CREATE TABLE t1_c (k INT);
CREATE TABLE t2_c (k INT);
INSERT INTO t1_c VALUES (1), (1), (NULL);
INSERT INTO t2_c VALUES (1), (1), (1), (NULL);

SELECT 'INNER' AS join_type, COUNT(*) AS row_count
FROM t1_c a INNER JOIN t2_c b ON a.k = b.k   -- 6
UNION ALL
SELECT 'LEFT',  COUNT(*) FROM t1_c a LEFT  JOIN t2_c b ON a.k = b.k  -- 7  (6 + 1 NULL from left)
UNION ALL
SELECT 'RIGHT', COUNT(*) FROM t1_c a RIGHT JOIN t2_c b ON a.k = b.k; -- 7  (6 + 1 NULL from right)
-- FULL OUTER (emulated) would be 8

-- ============================================================
-- Summary Table (commit this to memory):
-- +-----------+------+-------+-------+------------+
-- | Scenario  | INNER| LEFT  | RIGHT | FULL OUTER |
-- +-----------+------+-------+-------+------------+
-- | A (all match, 2×3 keys)           | 6 | 6 | 6 |  6 |
-- | B (non-match both sides; 6+1+1)   | 6 | 7 | 7 |  8 |
-- | C (same as B but key=\"NULL\")    | 6 | 7 | 7 |  8 |
-- +-----------+------+-------+-------+------------+
-- ============================================================

-- ============================================================
-- Cleanup
-- ============================================================
DROP TABLE IF EXISTS t1_a, t2_a;
DROP TABLE IF EXISTS t1_b, t2_b;
DROP TABLE IF EXISTS t1_c, t2_c;
