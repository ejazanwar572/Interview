-- ============================================================
-- UNION vs UNION ALL
-- ============================================================
-- UNION removes duplicate rows across both result sets.
-- UNION ALL keeps ALL rows including duplicates (faster).
-- Use UNION ALL unless you specifically need deduplication.
-- ============================================================

-- Sample Input: two tables of department IDs
--
-- Table: dept_a                Table: dept_b
-- +--------+                  +--------+
-- | dep_id |                  | dep_id |
-- +--------+                  +--------+
-- |   10   |                  |   10   |
-- |   20   |                  |   20   |
-- |   30   |                  |   40   |
-- +--------+                  +--------+
--
-- UNION Output:               UNION ALL Output:
-- +--------+                  +--------+
-- | dep_id |                  | dep_id |
-- +--------+                  +--------+
-- |   10   |                  |   10   |
-- |   20   |                  |   20   |
-- |   30   |                  |   30   |
-- |   40   |                  |   10   |  <-- duplicate kept
-- +--------+                  |   20   |  <-- duplicate kept
--                             |   40   |
--                             +--------+

-- ============================================================
-- DDL & DML
-- ============================================================

DROP TABLE IF EXISTS dept_a;
DROP TABLE IF EXISTS dept_b;

CREATE TABLE dept_a (dep_id INT);
CREATE TABLE dept_b (dep_id INT);

INSERT INTO dept_a VALUES (10), (20), (30);
INSERT INTO dept_b VALUES (10), (20), (40);

-- ============================================================
-- Hint
-- ============================================================
-- UNION deduplicates; it is equivalent to applying DISTINCT to
-- the combined result set and therefore has additional sorting
-- overhead. Prefer UNION ALL when you know duplicates are
-- impossible or don't matter.

-- ============================================================
-- Solution: UNION (unique rows only)
-- ============================================================

SELECT dep_id FROM dept_a
UNION
SELECT dep_id FROM dept_b
ORDER BY dep_id;

-- ============================================================
-- Solution: UNION ALL (all rows, including duplicates)
-- ============================================================

SELECT dep_id FROM dept_a
UNION ALL
SELECT dep_id FROM dept_b
ORDER BY dep_id;

-- ============================================================
-- Cleanup
-- ============================================================
DROP TABLE IF EXISTS dept_a;
DROP TABLE IF EXISTS dept_b;
