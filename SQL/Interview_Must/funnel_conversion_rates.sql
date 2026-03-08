/*
================================================================================
Problem: E-commerce Funnel Conversion Rates
================================================================================
Difficulty: Hard
Pattern: State Transition, LEAD(), Time-bounded sequences

Description:
You are given an `events` table tracking user actions on an e-commerce site.
The events are: 'Page_View', 'Add_to_Cart', and 'Purchase'.
A valid funnel sequence is defined as a user performing 'Page_View', followed by 
'Add_to_Cart', followed by 'Purchase', in that exact strict order. 
Each subsequent step must happen within 24 hours of the previous step.

Calculate the overall conversion rate from 'Page_View' to 'Add_to_Cart' 
and from 'Add_to_Cart' to 'Purchase' across the entire table.

Return two columns: `view_to_cart_rate` and `cart_to_purchase_rate`, rounded to 2 decimal places.

================================================================================
Input constraints / Data examples:
================================================================================
Table: events
+---------+--------------+---------------------+
| user_id | event_name   | event_timestamp     |
+---------+--------------+---------------------+
| 1       | Page_View    | 2026-03-01 10:00:00 |
| 1       | Add_to_Cart  | 2026-03-01 10:30:00 | -- Valid (within 24h of Page_View)
| 1       | Purchase     | 2026-03-01 11:00:00 | -- Valid (within 24h of Add_to_Cart)
| 2       | Page_View    | 2026-03-02 08:00:00 |
| 2       | Add_to_Cart  | 2026-03-04 09:00:00 | -- Invalid (> 24h from Page_View)
| 3       | Page_View    | 2026-03-05 12:00:00 |
+---------+--------------+---------------------+

Expected Output:
+-------------------+-----------------------+
| view_to_cart_rate | cart_to_purchase_rate |
+-------------------+-----------------------+
| 33.33             | 100.00                | -- 1 out of 3 views went to cart. 1 out of 1 valid cart went to purchase.
+-------------------+-----------------------+
*/

================================================================================
DDL & DML (For Testing)
================================================================================

CREATE TABLE events_funnel (
    user_id INT,
    event_name VARCHAR(50),
    event_timestamp DATETIME
);

INSERT INTO events_funnel (user_id, event_name, event_timestamp) VALUES
(1, 'Page_View', '2026-03-01 10:00:00'),
(1, 'Add_to_Cart', '2026-03-01 10:30:00'),
(1, 'Purchase', '2026-03-01 11:00:00'),
(2, 'Page_View', '2026-03-02 08:00:00'),
(2, 'Add_to_Cart', '2026-03-04 09:00:00'),
(3, 'Page_View', '2026-03-05 12:00:00'),
(3, 'Add_to_Cart', '2026-03-05 12:15:00'),
(4, 'Page_View', '2026-03-06 09:00:00'),
(4, 'Add_to_Cart', '2026-03-06 10:00:00'),
(4, 'Purchase', '2026-03-06 10:30:00'),
(5, 'Page_View', '2026-03-07 14:00:00'),
(6, 'Page_View', '2026-03-08 16:00:00'),
(6, 'Add_to_Cart', '2026-03-08 16:05:00'),
(6, 'Page_View', '2026-03-09 10:00:00'),
(6, 'Purchase', '2026-03-09 10:10:00');

-- ==========================================
-- Your Solution Here
-- ==========================================





-- ==========================================
-- Provided Solution
-- ==========================================
/*
WITH sequenced_events AS (
    SELECT 
        user_id,
        event_name,
        event_timestamp,
        LEAD(event_name) OVER (PARTITION BY user_id ORDER BY event_timestamp) AS next_event,
        LEAD(event_timestamp) OVER (PARTITION BY user_id ORDER BY event_timestamp) AS next_timestamp
    FROM events
),
funnel_counts AS (
    SELECT 
        SUM(CASE WHEN event_name = 'Page_View' THEN 1 ELSE 0 END) AS total_views,
        SUM(CASE WHEN event_name = 'Page_View' 
                  AND next_event = 'Add_to_Cart' 
                  AND TIMESTAMPDIFF(HOUR, event_timestamp, next_timestamp) <= 24 
              THEN 1 ELSE 0 END) AS valid_carts,
        SUM(CASE WHEN event_name = 'Add_to_Cart' 
                  AND next_event = 'Purchase' 
                  AND TIMESTAMPDIFF(HOUR, event_timestamp, next_timestamp) <= 24 
              THEN 1 ELSE 0 END) AS valid_purchases
    FROM sequenced_events
)
SELECT 
    ROUND(100.0 * valid_carts / NULLIF(total_views, 0), 2) AS view_to_cart_rate,
    ROUND(100.0 * valid_purchases / NULLIF(valid_carts, 0), 2) AS cart_to_purchase_rate
FROM funnel_counts;
*/
