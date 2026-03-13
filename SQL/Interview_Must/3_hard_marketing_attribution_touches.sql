/*
### Problem Description
You are building an attribution model. You have a `sessions` table tracking user visits by `channel`, and a `purchases` table. 
For every purchase made, write a query to attribute the revenue entirely to the user's **Last-Touch Channel** (the chronologically last session channel they visited *before* the purchase occurred). Wait, as an added challenge, list the **First-Touch** channel and **Last-Touch** channel in the same row per purchase!

### Sample Input and Output
**Input: sessions**
| session_id | user_id | channel | session_time |
|---|---|---|---|
| 1 | 100 | 'Facebook' | '2024-01-01 09:00:00' |
| 2 | 100 | 'Organic Search' | '2024-01-02 10:00:00' |
| 3 | 100 | 'Email' | '2024-01-03 11:00:00' |

**Input: purchases**
| purchase_id | user_id | purchase_time | revenue |
|---|---|---|---|
| 500 | 100 | '2024-01-03 11:30:00' | 150 |

**Output:**
| purchase_id | user_id | revenue | first_touch_channel | last_touch_channel |
|---|---|---|---|---|
| 500 | 100 | 150 | 'Facebook' | 'Email' |
*/

-- DDL and DML commands
DROP TABLE IF EXISTS sessions;
CREATE TABLE sessions (
    session_id INT,
    user_id INT,
    channel VARCHAR(50),
    session_time TIMESTAMP
);

DROP TABLE IF EXISTS purchases;
CREATE TABLE purchases (
    purchase_id INT,
    user_id INT,
    purchase_time TIMESTAMP,
    revenue INT
);

INSERT INTO sessions (session_id, user_id, channel, session_time) VALUES
(1, 100, 'Facebook', '2024-01-01 09:00:00'),
(2, 100, 'Organic Search', '2024-01-02 10:00:00'),
(3, 100, 'Email', '2024-01-03 11:00:00');

INSERT INTO purchases (purchase_id, user_id, purchase_time, revenue) VALUES
(500, 100, '2024-01-03 11:30:00', 150);


/*
### Approach
1. Join the purchases table to the sessions table where `session_time <= purchase_time`.
2. To find the first and last touches dynamically without subqueries, use window functions like `FIRST_VALUE()` and `LAST_VALUE()`. 
3. Partition by the `purchase_id` and order by `session_time`. 
   - Note: In standard SQL, `LAST_VALUE()` requires defining the window frame explicitly (`ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`) to look ahead to the end of the partition block correctly!
4. Select `DISTINCT` to collapse the joined rows back to one row per purchase.
*/










-- Optimized Solution
WITH AttributedSessions AS (
    SELECT 
        p.purchase_id,
        p.user_id,
        p.revenue,
        s.channel,
        FIRST_VALUE(s.channel) OVER (
            PARTITION BY p.purchase_id 
            ORDER BY s.session_time ASC
        ) AS first_touch_channel,
        LAST_VALUE(s.channel) OVER (
            PARTITION BY p.purchase_id 
            ORDER BY s.session_time ASC 
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS last_touch_channel
    FROM purchases p
    JOIN sessions s 
      ON p.user_id = s.user_id 
      AND s.session_time <= p.purchase_time
)
SELECT DISTINCT 
    purchase_id, 
    user_id, 
    revenue, 
    first_touch_channel, 
    last_touch_channel
FROM AttributedSessions;
