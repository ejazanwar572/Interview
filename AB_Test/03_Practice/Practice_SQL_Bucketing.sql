/*
Problem: SQL Bucketing & A/B Test Metric Aggregation

You have a table of user interactions. Your task is to:
1. Bucket users into 'control' and 'treatment' groups randomly using a hashing function (MD5) or a modulo operation on their numeric user_id. 
   - A modulo of 2 where result is 0 = control, 1 = treatment.
2. Calculate the total unique visitors and the conversion rate for each group.
   - For this exercise, assume any user with a non-null `purchase_amount` > 0 has converted.
*/

/* Sample Input (user_interactions Table)
| user_id | timestamp           | purchase_amount |
|---------|---------------------|-----------------|
| 104     | 2023-11-01 10:00:00 | 0.00            |
| 104     | 2023-11-01 10:05:00 | 45.50           |
| 205     | 2023-11-01 11:30:00 | 0.00            |
| 306     | 2023-11-01 15:45:00 | 12.00           |
| 407     | 2023-11-02 09:15:00 | 0.00            |
*/

/* Sample Output
| variant   | total_users | converted_users | conversion_rate |
|-----------|-------------|-----------------|-----------------|
| control   | 2           | 1               | 0.50            |
| treatment | 2           | 1               | 0.50            |
*/

-- DDL / DML for Testing
CREATE TABLE user_interactions (
    user_id INT,
    timestamp TIMESTAMP,
    purchase_amount DECIMAL(10,2)
);

INSERT INTO user_interactions (user_id, timestamp, purchase_amount) VALUES
(104, '2023-11-01 10:00:00', 0.00),
(104, '2023-11-01 10:05:00', 45.50), -- conversion
(205, '2023-11-01 11:30:00', 0.00),
(306, '2023-11-01 15:45:00', 12.00), -- conversion
(407, '2023-11-02 09:15:00', 0.00);

/*
What you should use:
- CTE (Common Table Expression) to pre-bucket users at the distinct user level to avoid duplicates if a user visits multiple times.
- `user_id % 2` or `MOD(user_id, 2)` to split traffic 50/50.
- `CASE WHEN` to assign the string 'control' or 'treatment'.
- Standard aggregations (`COUNT(DISTINCT user_id)`) to calculate the metrics.
*/

-- ==========================================
-- Optimized Solution
-- ==========================================

WITH UserBuckets AS (
    SELECT 
        user_id,
        CASE 
            WHEN user_id % 2 = 0 THEN 'control'
            ELSE 'treatment'
        END AS variant,
        MAX(CASE WHEN purchase_amount > 0 THEN 1 ELSE 0 END) AS has_converted
    FROM 
        user_interactions
    GROUP BY 
        user_id
)

SELECT 
    variant,
    COUNT(user_id) AS total_users,
    SUM(has_converted) AS converted_users,
    ROUND(SUM(has_converted) * 1.0 / COUNT(user_id), 4) AS conversion_rate
FROM 
    UserBuckets
GROUP BY 
    variant
ORDER BY 
    variant;
