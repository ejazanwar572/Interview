/*
### Problem Description
Write an RFM (Recency, Frequency, Monetary) segmentation query. Calculate the R, F, and M scores for each user (based on their quartile/quintile rank for each metric) using current date as '2024-12-31'. Provide the final RFM score concatenated as a string (e.g., '444').

Use Quartiles (4 scoring brackets, where 4 is the top percentile/best score).

### Sample Input and Output
**Input: SalesOrders**
| user_id | order_date | spend |
|---|---|---|
| 1 | '2024-12-30' | 5000 | 
| 2 | '2024-01-15' | 100 |  
| 3 | '2024-10-10' | 2000 |
| 4 | '2024-12-01' | 2500 |

**Output:**
| user_id | rfm_score |
|---|---|
| 1 | '414' |
| 4 | '313' |
| 3 | '212' |
| 2 | '111' |

*(Note: Exact output ranks will depend on table size, this is illustrative of the concatenation.)*
*/

-- DDL and DML commands
DROP TABLE IF EXISTS SalesOrders;
CREATE TABLE SalesOrders (
    user_id INT,
    order_date DATE,
    spend DECIMAL(10, 2)
);

INSERT INTO SalesOrders (user_id, order_date, spend) VALUES
(1, '2024-12-30', 5000), 
(2, '2024-01-15', 100),  
(3, '2024-10-10', 2000),
(4, '2024-12-01', 2500);


/*
### Approach
RFM relies heavily on `NTILE()`, a window function that splits ordered data into equal buckets.
1. Determine raw RFM values per user:
   - Recency: Days since last order (`DATEDIFF`)
   - Frequency: Total count of orders (`COUNT`)
   - Monetary: Total spend (`SUM`)
2. Score each raw metric into quartiles using `NTILE(4)`. Pay attention to `ORDER BY` directions (Less days since last order = better recency score = `ASC` order for scoring).
3. Combine the 3 percentile numbers into a single score.
*/










-- Optimized Solution
WITH RawRFM AS (
    SELECT 
        user_id,
        MIN(DATEDIFF('2024-12-31', order_date)) AS recency_days,
        COUNT(order_date) AS frequency_count,
        SUM(spend) AS monetary_value
    FROM SalesOrders
    GROUP BY user_id
),
RFMScores AS (
    SELECT
        user_id,
        -- Less gap in days is better, so NTILE over DESC order 
        -- (meaning lowest days gets put in Bucket 4)
        NTILE(4) OVER (ORDER BY recency_days DESC) AS R_Score,
        
        -- More orders is better
        NTILE(4) OVER (ORDER BY frequency_count ASC) AS F_Score,
        
        -- Higher spend is better
        NTILE(4) OVER (ORDER BY monetary_value ASC) AS M_Score
    FROM RawRFM
)
SELECT 
    user_id,
    CONCAT(R_Score, F_Score, M_Score) AS rfm_score
FROM RFMScores;
