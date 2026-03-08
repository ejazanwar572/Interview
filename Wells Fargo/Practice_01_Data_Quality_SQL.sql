-- ==============================================================================
-- Problem 1: Root Cause Analysis on Data Quality (Anomaly Detection)
-- ==============================================================================
-- Problem Description:
-- As a Lead Analyst at Wells Fargo, you are tasked with identifying data quality 
-- issues in transaction records. Specifically, you need to find customers who 
-- have multiple fragmented records on the same day with the exact same transaction 
-- amount but differing metadata (potential duplication bug in the pipeline). 
-- Write an optimized query to identify the CUSTOMER_ID, TRANSACTION_DATE, and 
-- the duplicated TRANSACTION_AMOUNT, ensuring you only flag cases where the 
-- duplication count is higher than typical expected retries (e.g., > 2 times).

-- ==============================================================================
-- Sample Input Table (`transactions`):
-- | TXN_ID | CUSTOMER_ID | TXN_DATE   | TXN_AMOUNT | STATUS    |
-- |--------|-------------|------------|------------|-----------|
-- | 101    | C-1         | 2024-03-01 | 500.00     | SUCCESS   |
-- | 102    | C-1         | 2024-03-01 | 500.00     | FAILED    |
-- | 103    | C-1         | 2024-03-01 | 500.00     | PENDING   |
-- | 104    | C-2         | 2024-03-01 | 1500.00    | SUCCESS   |
-- | 105    | C-2         | 2024-03-02 | 1500.00    | SUCCESS   |

-- Sample Output Table:
-- | CUSTOMER_ID | TXN_DATE   | TXN_AMOUNT | DUPLICATE_COUNT |
-- |-------------|------------|------------|-----------------|
-- | C-1         | 2024-03-01 | 500.00     | 3               |

-- ==============================================================================
-- DDL & DML Commands:

CREATE TABLE transactions (
    txn_id INT PRIMARY KEY,
    customer_id VARCHAR(50),
    txn_date DATE,
    txn_amount DECIMAL(10,2),
    status VARCHAR(20)
);

INSERT INTO transactions (txn_id, customer_id, txn_date, txn_amount, status) VALUES
(101, 'C-1', '2024-03-01', 500.00, 'SUCCESS'),
(102, 'C-1', '2024-03-01', 500.00, 'FAILED'),
(103, 'C-1', '2024-03-01', 500.00, 'PENDING'),
(104, 'C-2', '2024-03-01', 1500.00, 'SUCCESS'),
(105, 'C-2', '2024-03-02', 1500.00, 'SUCCESS');

-- ==============================================================================
-- Approach / Hints:
-- 1. Aggregation is necessary. Group by the dimensions that define a "duplicate" 
--    (customer_id, txn_date, txn_amount).
-- 2. Use the HAVING clause to filter out groups that do not meet the "greater than 2" 
--    threshold anomaly rule.
-- 3. Optimization note: Make sure the query relies strictly on covering indices if 
--    this were a multi-billion row table in BigQuery.

-- ==============================================================================







-- Optimized Solution:

SELECT 
    customer_id, 
    txn_date, 
    txn_amount, 
    COUNT(*) as duplicate_count
FROM 
    transactions
GROUP BY 
    customer_id, 
    txn_date, 
    txn_amount
HAVING 
    COUNT(*) > 2
ORDER BY 
    duplicate_count DESC, 
    txn_date DESC;
