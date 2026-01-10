# SQL Interview Solutions (BigQuery Edition)

## A. Window Functions — Hard Level

### 1. Find the longest streak of consecutive days a user logged in.
**Problem:** Identify the maximum number of consecutive days a user has been active.
**Approach:** Use the "Row Number Difference" method. If dates are consecutive, the difference between the date and its rank (in days) will be constant.

```sql
-- Method 1: Row Number Difference
WITH DailyLogins AS (
    SELECT DISTINCT user_id, login_date
    FROM user_logins
),
GroupedDates AS (
    SELECT 
        user_id,
        login_date,
        -- BigQuery: DATE_SUB to subtract days
        DATE_SUB(login_date, INTERVAL ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY login_date) DAY) AS grp
    FROM DailyLogins
)
SELECT 
    user_id,
    COUNT(*) AS streak_length
FROM GroupedDates
GROUP BY user_id, grp
ORDER BY streak_length DESC;
```

### 2. Detect sessionization: assign session IDs to events where gaps > 30 minutes.
**Problem:** Group events into sessions. A new session starts if the time since the previous event is > 30 mins.
**Approach:** Mark the start of a new session with a flag (1 or 0), then do a cumulative sum to generate Session IDs.

```sql
WITH LaggedEvents AS (
    SELECT 
        user_id,
        event_timestamp,
        LAG(event_timestamp) OVER (PARTITION BY user_id ORDER BY event_timestamp) AS prev_ts
    FROM events
),
NewSessionFlag AS (
    SELECT 
        user_id,
        event_timestamp,
        CASE 
            -- BigQuery: TIMESTAMP_DIFF(end, start, PART)
            WHEN prev_ts IS NULL OR TIMESTAMP_DIFF(event_timestamp, prev_ts, MINUTE) > 30 THEN 1 
            ELSE 0 
        END AS is_new_session
    FROM LaggedEvents
)
SELECT 
    user_id,
    event_timestamp,
    -- Generate Session ID by summing flags cumulatively
    SUM(is_new_session) OVER (PARTITION BY user_id ORDER BY event_timestamp) AS session_id
FROM NewSessionFlag;
```

### 3. Compute rolling 7-day retention per user.
**Problem:** For each day, calculate how many users were active in the previous 7 days.

```sql
-- Calculating Rolling 7-Day Active Users count per day
SELECT 
    date,
    COUNT(DISTINCT user_id) AS daily_active_users,
    -- BigQuery supports RANGE BETWEEN with INTERVAL
    COUNT(DISTINCT user_id) OVER (
        ORDER BY UNIX_DATE(date) 
        RANGE BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS rolling_7d_active_users 
    -- Note: BigQuery Windowing on DISTINCT is sometimes limited. 
    -- If error "DISTINCT is not supported in window functions", use Self-Join below.
FROM daily_stats;

-- Alternative: Self-Join (Robust for BigQuery)
SELECT 
    a.date,
    COUNT(DISTINCT b.user_id) AS rolling_7d_users
FROM dates a
JOIN activity b ON b.activity_date BETWEEN DATE_SUB(a.date, INTERVAL 6 DAY) AND a.date
GROUP BY a.date;
```

### 4. Find top-N products per category, but ensure ties are handled correctly.
**Problem:** Get top 3 products by sales, handling ties.

```sql
WITH RankedProducts AS (
    SELECT 
        category_id,
        product_id,
        total_sales,
        DENSE_RANK() OVER (PARTITION BY category_id ORDER BY total_sales DESC) AS rnk
    FROM product_sales
)
SELECT * 
FROM RankedProducts
WHERE rnk <= 3;
```

### 5. Calculate running totals reset each month, but only for active users.
**Problem:** Cumulative sum of spending, resetting at the start of each month.

```sql
SELECT 
    user_id,
    transaction_date,
    amount,
    SUM(amount) OVER (
        PARTITION BY user_id, DATE_TRUNC(transaction_date, MONTH) 
        ORDER BY transaction_date
    ) AS monthly_running_total
FROM transactions
WHERE status = 'active';
```

### 6. Detect price anomalies where a price is greater than 2× the 7-day moving average.
**Problem:** Flag rows where price > 2 * (Avg price of previous 7 days).

```sql
WITH MovingAvg AS (
    SELECT 
        product_id,
        date,
        price,
        AVG(price) OVER (
            PARTITION BY product_id 
            ORDER BY date 
            ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING
        ) AS avg_prev_7_days
    FROM product_prices
)
SELECT * 
FROM MovingAvg
WHERE price > 2 * avg_prev_7_days;
```

### 7. Find second highest salary per department, even when duplicates exist.
**Problem:** If two people have the highest salary, the next distinct salary is the 2nd highest.

```sql
WITH RankedSalaries AS (
    SELECT 
        dept_id,
        emp_name,
        salary,
        DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rnk
    FROM employees
)
SELECT * 
FROM RankedSalaries
WHERE rnk = 2;
```

### 8. Remove duplicates using QUALIFY/ROW_NUMBER, but keep the most recent row.
**Problem:** Deduplicate based on ID, keeping the latest timestamp.

```sql
-- BigQuery supports QUALIFY natively
SELECT *
FROM events
QUALIFY ROW_NUMBER() OVER (PARTITION BY event_id ORDER BY event_timestamp DESC) = 1;
```

### 9. Find users whose spending this month is 20% higher than their 3-month trailing average.
**Problem:** Compare current month sum to avg of prev 3 months.

```sql
WITH MonthlyStats AS (
    SELECT 
        user_id,
        DATE_TRUNC(txn_date, MONTH) AS mth,
        SUM(amount) AS monthly_spend
    FROM transactions
    GROUP BY 1, 2
),
Comparison AS (
    SELECT 
        user_id,
        mth,
        monthly_spend,
        AVG(monthly_spend) OVER (
            PARTITION BY user_id 
            ORDER BY mth 
            ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING
        ) AS trailing_3m_avg
    FROM MonthlyStats
)
SELECT * 
FROM Comparison
WHERE monthly_spend > 1.2 * trailing_3m_avg;
```

## B. Complex Joins & Multi-Step Problems

### 1. Find customers who bought a product, returned it, and then bought again within 30 days.
**Problem:** Identify "boomerang" customers for a specific product flow.

```sql
SELECT DISTINCT p1.user_id, p1.product_id
FROM purchases p1
JOIN returns r ON p1.user_id = r.user_id AND p1.product_id = r.product_id
    AND r.return_date > p1.purchase_date
JOIN purchases p2 ON p1.user_id = p2.user_id AND p1.product_id = p2.product_id
    AND p2.purchase_date > r.return_date
    AND p2.purchase_date <= DATE_ADD(r.return_date, INTERVAL 30 DAY);
```

### 2. Identify products frequently co-purchased with Product X (market basket).
**Problem:** Find products that appear in the same order as Product X.

```sql
SELECT 
    b.product_id,
    COUNT(*) AS co_occurrence_count
FROM order_items a
JOIN order_items b ON a.order_id = b.order_id
WHERE a.product_id = 'Product_X' 
  AND b.product_id != 'Product_X'
GROUP BY b.product_id
ORDER BY co_occurrence_count DESC;
```

### 3. Detect “cross-device” user IDs using fuzzy email/phone match logic.
**Problem:** Find different user_ids that likely belong to the same person.

```sql
SELECT 
    u1.user_id AS user_a,
    u2.user_id AS user_b,
    u1.email,
    u1.phone
FROM users u1
JOIN users u2 ON u1.user_id < u2.user_id 
    AND (
        LOWER(TRIM(u1.email)) = LOWER(TRIM(u2.email)) OR 
        REPLACE(u1.phone, '-', '') = REPLACE(u2.phone, '-', '')
    );
```

### 4. Find invoices where the payment doesn’t match itemized totals.
**Problem:** Data integrity check.

```sql
WITH InvoiceTotals AS (
    SELECT 
        invoice_id,
        SUM(quantity * unit_price) AS calculated_total
    FROM invoice_items
    GROUP BY invoice_id
)
SELECT 
    i.invoice_id,
    i.total_amount AS header_total,
    it.calculated_total
FROM invoices i
JOIN InvoiceTotals it ON i.invoice_id = it.invoice_id
WHERE i.total_amount != it.calculated_total;
```

### 5. Compute net active subscriptions including prorating partial months.
**Problem:** Calculate revenue recognizing partial months for subscriptions.

```sql
-- BigQuery: DATE_DIFF for days
SELECT 
    user_id,
    subscription_id,
    amount,
    GREATEST(0, 
        DATE_DIFF(LEAST(end_date, DATE '2023-11-30'), GREATEST(start_date, DATE '2023-11-01'), DAY) + 1
    ) AS active_days,
    (amount / 30.0) * GREATEST(0, 
        DATE_DIFF(LEAST(end_date, DATE '2023-11-30'), GREATEST(start_date, DATE '2023-11-01'), DAY) + 1
    ) AS prorated_revenue
FROM subscriptions
WHERE start_date <= '2023-11-30' AND end_date >= '2023-11-01';
```

### 6. Compute customer lifetime even if subscription pauses/resumes.
**Problem:** Sum of all active durations.

```sql
SELECT 
    user_id,
    SUM(DATE_DIFF(COALESCE(end_date, CURRENT_DATE()), start_date, DAY)) AS total_lifetime_days
FROM subscriptions
GROUP BY user_id;
```

### 7. Find employees who report indirectly to a particular manager (recursive CTE).
**Problem:** Find all subordinates of Manager X (direct and indirect).

```sql
WITH RECURSIVE OrgChart AS (
    -- Anchor: Direct reports
    SELECT emp_id, manager_id, emp_name, 1 as level
    FROM employees
    WHERE manager_id = 'Manager_X_ID'
    
    UNION ALL
    
    -- Recursive: Reports of reports
    SELECT e.emp_id, e.manager_id, e.emp_name, o.level + 1
    FROM employees e
    JOIN OrgChart o ON e.manager_id = o.emp_id
)
SELECT * FROM OrgChart;
```

### 8. Determine percentage of users who converted within 7 days of signup using event logs.
**Problem:** Conversion rate with a time window constraint.

```sql
WITH Signups AS (
    SELECT user_id, event_timestamp AS signup_ts
    FROM events WHERE event_name = 'signup'
),
Conversions AS (
    SELECT user_id, event_timestamp AS conversion_ts
    FROM events WHERE event_name = 'purchase'
)
SELECT 
    COUNT(DISTINCT c.user_id) * 100.0 / COUNT(DISTINCT s.user_id) AS conversion_rate_7d
FROM Signups s
LEFT JOIN Conversions c ON s.user_id = c.user_id 
    AND c.conversion_ts BETWEEN s.signup_ts AND TIMESTAMP_ADD(s.signup_ts, INTERVAL 7 DAY);
```

## C. E-commerce / Fintech / Product Analytics

### 1. Compute daily active users (DAU), WAU, MAU using window functions.
**Problem:** Calculate active users for different time windows.

```sql
-- Simple Group By for DAU
SELECT date, COUNT(DISTINCT user_id) AS dau FROM activity GROUP BY date;

-- Rolling MAU (30 days)
SELECT 
    date,
    COUNT(DISTINCT user_id) OVER (
        ORDER BY UNIX_DATE(date)
        RANGE BETWEEN 29 PRECEDING AND CURRENT ROW
    ) AS rolling_mau
FROM daily_activity_summary;
```

### 2. Calculate add-to-cart → checkout → purchase funnel with drop-off rates.
**Problem:** Funnel analysis.

```sql
WITH FunnelSteps AS (
    SELECT 
        user_id,
        MAX(CASE WHEN event_name = 'add_to_cart' THEN 1 ELSE 0 END) AS has_cart,
        MAX(CASE WHEN event_name = 'checkout_start' THEN 1 ELSE 0 END) AS has_checkout,
        MAX(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END) AS has_purchase
    FROM events
    GROUP BY user_id
)
SELECT 
    SUM(has_cart) AS cart_users,
    SUM(has_checkout) AS checkout_users,
    SUM(has_purchase) AS purchase_users,
    1.0 - (IEEE_DIVIDE(SUM(has_checkout), SUM(has_cart))) AS cart_dropoff,
    1.0 - (IEEE_DIVIDE(SUM(has_purchase), SUM(has_checkout))) AS checkout_dropoff
FROM FunnelSteps;
```

### 3. Build RFM segmentation using SQL alone.
**Problem:** Recency, Frequency, Monetary value per user.

```sql
WITH RFM_Raw AS (
    SELECT 
        user_id,
        MAX(purchase_date) AS last_purchase,
        COUNT(*) AS frequency,
        SUM(amount) AS monetary
    FROM purchases
    GROUP BY user_id
),
RFM_Scores AS (
    SELECT 
        user_id,
        NTILE(5) OVER (ORDER BY last_purchase) AS r_score,
        NTILE(5) OVER (ORDER BY frequency) AS f_score,
        NTILE(5) OVER (ORDER BY monetary) AS m_score
    FROM RFM_Raw
)
SELECT *, 
    CONCAT(r_score, f_score, m_score) AS rfm_segment 
FROM RFM_Scores;
```

### 4. Identify high-value users who contribute 80% of revenue (Pareto 80/20).
**Problem:** Find the top X% users generating 80% revenue.

```sql
WITH UserRevenue AS (
    SELECT user_id, SUM(amount) AS total_rev
    FROM purchases
    GROUP BY user_id
),
Cumulative AS (
    SELECT 
        user_id,
        total_rev,
        SUM(total_rev) OVER (ORDER BY total_rev DESC) AS running_rev,
        SUM(total_rev) OVER () AS global_rev
    FROM UserRevenue
)
SELECT * 
FROM Cumulative
WHERE running_rev <= 0.8 * global_rev;
```

### 5. Compute retention cohorts with month-1, month-2, month-3 retention.
**Problem:** Classic cohort analysis.

```sql
WITH UserCohorts AS (
    SELECT user_id, DATE_TRUNC(MIN(signup_date), MONTH) AS cohort_month
    FROM users
    GROUP BY user_id
),
UserActivities AS (
    SELECT DISTINCT user_id, DATE_TRUNC(activity_date, MONTH) AS activity_month
    FROM activity
)
SELECT 
    c.cohort_month,
    a.activity_month,
    DATE_DIFF(a.activity_month, c.cohort_month, MONTH) AS month_number,
    COUNT(DISTINCT c.user_id) AS retained_users
FROM UserCohorts c
JOIN UserActivities a ON c.user_id = a.user_id
GROUP BY 1, 2, 3
ORDER BY 1, 3;
```

### 6. Find first product purchased and most recent product purchased by each user.
**Problem:** Get first and last value.

```sql
SELECT DISTINCT 
    user_id,
    FIRST_VALUE(product_id) OVER (PARTITION BY user_id ORDER BY purchase_date ASC) AS first_product,
    FIRST_VALUE(product_id) OVER (PARTITION BY user_id ORDER BY purchase_date DESC) AS last_product
FROM purchases;
```

### 7. Detect revenue leakage due to coupons or refund mismatches.
**Problem:** Verify net revenue calculation.

```sql
SELECT 
    order_id,
    gross_amount,
    discount_amount,
    refund_amount,
    net_paid,
    (gross_amount - discount_amount - refund_amount) AS calculated_net
FROM orders
WHERE ABS(net_paid - (gross_amount - discount_amount - refund_amount)) > 0.01;
```

### 8. Determine conversion impact of a new feature using pre/post windows.
**Problem:** Compare metrics before and after a date.

```sql
SELECT 
    CASE 
        WHEN event_date < '2023-06-01' THEN 'Pre-Launch'
        ELSE 'Post-Launch'
    END AS period,
    COUNT(DISTINCT CASE WHEN event_name = 'conversion' THEN user_id END) * 1.0 / COUNT(DISTINCT user_id) AS conversion_rate
FROM events
WHERE event_date BETWEEN '2023-05-01' AND '2023-07-01'
GROUP BY 1;
```

### 9. Compute search-to-enrollment funnel conversion for experiments.
**Problem:** Funnel for A/B test groups.

```sql
SELECT 
    experiment_group,
    COUNT(DISTINCT user_id) AS total_users,
    COUNT(DISTINCT CASE WHEN has_search = 1 THEN user_id END) AS searchers,
    COUNT(DISTINCT CASE WHEN has_enrollment = 1 THEN user_id END) AS enrollees,
    IEEE_DIVIDE(COUNT(DISTINCT CASE WHEN has_enrollment = 1 THEN user_id END), COUNT(DISTINCT CASE WHEN has_search = 1 THEN user_id END)) AS conversion
FROM experiment_data
GROUP BY experiment_group;
```

## D. Temporal & Event-Sequencing Logic

### 1. For each user, find the time between sign-up and first purchase.
**Problem:** Duration calculation.

```sql
SELECT 
    u.user_id,
    DATE_DIFF(MIN(p.purchase_date), u.signup_date, DAY) AS days_to_first_purchase
FROM users u
JOIN purchases p ON u.user_id = p.user_id
GROUP BY u.user_id, u.signup_date;
```

### 2. Detect churn: last activity > 45 days ago, but only for paid users.
**Problem:** Identify inactive paid users.

```sql
SELECT user_id
FROM users
WHERE status = 'paid'
GROUP BY user_id
HAVING MAX(last_active_date) < DATE_SUB(CURRENT_DATE(), INTERVAL 45 DAY);
```

### 3. Compute overlapping time intervals, e.g., two subscriptions overlapping.
**Problem:** Find overlaps.

```sql
SELECT 
    a.subscription_id AS sub1,
    b.subscription_id AS sub2
FROM subscriptions a
JOIN subscriptions b ON a.user_id = b.user_id AND a.subscription_id < b.subscription_id
WHERE a.start_date < b.end_date AND b.start_date < a.end_date;
```

### 4. Find peak concurrency (max number of active users at a minute-level).
**Problem:** Max concurrent sessions.

```sql
WITH Events AS (
    SELECT start_time AS ts, 1 AS type FROM sessions
    UNION ALL
    SELECT end_time AS ts, -1 AS type FROM sessions
),
Cumulative AS (
    SELECT 
        ts,
        SUM(type) OVER (ORDER BY ts, type DESC) AS concurrent_users
    FROM Events
)
SELECT MAX(concurrent_users) FROM Cumulative;
```

### 5. Calculate inventory changes using cumulative sums over transactions.
**Problem:** Running inventory balance.

```sql
SELECT 
    product_id,
    transaction_date,
    quantity_change,
    SUM(quantity_change) OVER (PARTITION BY product_id ORDER BY transaction_date) AS current_inventory
FROM inventory_log;
```

### 6. Identify users who changed state (e.g., Free → Paid → Cancelled → Reactivated).
**Problem:** Track state transitions.

```sql
WITH StateChanges AS (
    SELECT 
        user_id,
        change_date,
        new_state,
        LAG(new_state) OVER (PARTITION BY user_id ORDER BY change_date) AS prev_state
    FROM user_states
)
SELECT * 
FROM StateChanges
WHERE new_state != prev_state OR prev_state IS NULL;
```

### 7. Determine running balance in a ledger model (credits/debits).
**Problem:** Ledger balance.

```sql
SELECT 
    account_id,
    transaction_date,
    amount, -- positive for credit, negative for debit
    SUM(amount) OVER (PARTITION BY account_id ORDER BY transaction_date) AS balance
FROM ledger;
```

## E. Text, Arrays, JSON

### 1. Extract values from nested JSON fields in events tables.
**Problem:** JSON extraction.

```sql
-- BigQuery
SELECT 
    event_id,
    JSON_VALUE(event_data, '$.user_id') AS user_id,
    JSON_VALUE(event_data, '$.details.action') AS action
FROM events;
```

### 2. Find users whose search queries contain multiple keywords, case-insensitive.
**Problem:** Multi-keyword search.

```sql
SELECT user_id, query_text
FROM search_logs
WHERE LOWER(query_text) LIKE '%keyword1%' 
  AND LOWER(query_text) LIKE '%keyword2%';
```

### 3. Unnest arrays to analyze multi-select fields (BigQuery/Snowflake).
**Problem:** Flatten arrays.

```sql
-- BigQuery
SELECT 
    user_id,
    flat_tag
FROM users,
UNNEST(tags) AS flat_tag;
```

### 4. Identify distinct count of attributes inside JSON arrays per session.
**Problem:** Count unique items in JSON array.

```sql
-- BigQuery
SELECT 
    session_id,
    COUNT(DISTINCT json_value) AS unique_attributes
FROM sessions,
UNNEST(JSON_EXTRACT_ARRAY(attributes_json)) AS json_value
GROUP BY session_id;
```

## F. Performance / Query Optimization

### 1. Rewrite a self-join query using window functions for better performance.
**Problem:** Avoid expensive self-joins for "previous row" logic.
**Solution:** Use `LAG()` or `LEAD()` instead of `JOIN table t1 ON t1.id = t2.id - 1`.

### 2. Optimize slow queries: detect missing indexes, excessive sorts, scans.
**Checklist:**
- **Partitioning/Clustering:** In BigQuery, ensure queries filter on Partition columns (e.g., `date`) and Cluster columns (e.g., `user_id`).
- **Scans:** Avoid `SELECT *`. Select only needed columns.
- **SARGable:** Use `date BETWEEN ...` instead of `EXTRACT(YEAR FROM date) = 2023`.

### 3. Identify N+1 JOIN patterns and fix them.
**Problem:** Fetching related data in a loop (application side) or correlated subqueries in SQL.
**Fix:** Use `JOIN` to fetch all data in a single query or `ARRAY_AGG` to pre-fetch related items.

### 4. Explain the difference between HASH JOIN, MERGE JOIN, NESTED LOOP in a plan.
- **Nested Loop:** Good for small datasets. Loops through outer table and finds matches in inner table.
- **Hash Join:** Good for large unsorted datasets. Builds hash table of smaller table, then probes with larger table. Common in BigQuery.
- **Merge Join:** Good for sorted datasets. Zips two sorted inputs together.

### 5. Partition a large table properly and demonstrate pruning via SQL.
**Concept:** Split table by date or key.
**Pruning:** `SELECT * FROM logs WHERE date = '2023-01-01'` only scans the Jan 1st partition, skipping others.

### 6. Rewrite a query to avoid DISTINCT + JOIN, using window/QUALIFY instead.
**Problem:** `SELECT DISTINCT ... JOIN ...` can be expensive due to sorting/hashing after join.
**Fix:** Deduplicate *before* joining or use `GROUP BY`.
```sql
-- Bad
SELECT DISTINCT u.id, u.name FROM users u JOIN events e ON u.id = e.user_id;

-- Better
SELECT u.id, u.name FROM users u WHERE EXISTS (SELECT 1 FROM events e WHERE e.user_id = u.id);
```

## G. OLAP / Aggregation Puzzles

### 1. Pivot dynamic columns without using PIVOT.
**Problem:** Turn rows into columns.
**Approach:** Use `CASE WHEN` aggregation.

```sql
SELECT 
    date,
    SUM(CASE WHEN category = 'Electronics' THEN sales ELSE 0 END) AS electronics_sales,
    SUM(CASE WHEN category = 'Clothing' THEN sales ELSE 0 END) AS clothing_sales
FROM sales
GROUP BY date;
```

### 2. Find users who bought in 3 consecutive months.
**Problem:** Consecutive activity.

```sql
WITH MonthlyActivity AS (
    SELECT DISTINCT user_id, DATE_TRUNC(purchase_date, MONTH) AS mth
    FROM purchases
),
Lagged AS (
    SELECT 
        user_id,
        mth,
        LAG(mth, 1) OVER (PARTITION BY user_id ORDER BY mth) AS prev_mth,
        LAG(mth, 2) OVER (PARTITION BY user_id ORDER BY mth) AS prev_mth_2
    FROM MonthlyActivity
)
SELECT DISTINCT user_id
FROM Lagged
WHERE mth = DATE_ADD(prev_mth, INTERVAL 1 MONTH)
  AND prev_mth = DATE_ADD(prev_mth_2, INTERVAL 1 MONTH);
```

### 3. Compute median, percentiles, top/bottom contributors using window functions.
**Problem:** Statistical aggregation.

```sql
SELECT 
    category_id,
    PERCENTILE_CONT(price, 0.5) OVER (PARTITION BY category_id) AS median_price,
    PERCENTILE_CONT(price, 0.9) OVER (PARTITION BY category_id) AS p90_price
FROM products
LIMIT 100; -- Percentiles in BQ are window functions or aggregate functions
```

### 4. Do hierarchical rollups with GROUPING SETS / CUBE / ROLLUP.
**Problem:** Multi-level aggregation.

```sql
SELECT 
    region,
    country,
    SUM(sales)
FROM sales
GROUP BY ROLLUP(region, country);
-- Returns totals for (region, country), (region), and () (grand total)
```

### 5. Detect outliers using MAD, Z-score, or IQR purely in SQL.
**Problem:** Find anomalous values.

```sql
WITH Stats AS (
    SELECT AVG(val) AS mean_val, STDDEV(val) AS std_val FROM data
)
SELECT d.*
FROM data d, Stats s
WHERE ABS(d.val - s.mean_val) > 3 * s.std_val; -- Z-score > 3
```

### 6. Compute product price elasticity (requires correlation in SQL).
**Problem:** Correlation between price and quantity.

```sql
SELECT 
    product_id,
    CORR(price, quantity) AS price_elasticity
FROM sales_history
GROUP BY product_id;
```

## H. Real Interview-Grade Scenarios

### 1. Deduplicate a 100M-row fact table without downtime.
**Approach:**
1. Create a new table `fact_new` with the same schema.
2. Insert deduplicated data: `INSERT INTO fact_new SELECT DISTINCT * FROM fact_old`.
3. Create indexes on `fact_new`.
4. Swap tables: `ALTER TABLE fact_old RENAME TO fact_backup; ALTER TABLE fact_new RENAME TO fact_old;`.

### 2. Merge incremental loads using MERGE with SCD-2 logic.
**Problem:** Update history with new data.

```sql
MERGE INTO target t
USING source s ON t.id = s.id
WHEN MATCHED AND t.hash != s.hash THEN
  UPDATE SET t.is_current = false, t.end_date = CURRENT_DATE()
WHEN NOT MATCHED THEN
  INSERT (id, data, is_current, start_date) VALUES (s.id, s.data, true, CURRENT_DATE());
-- Note: SCD-2 usually requires a second INSERT for the new version of updated rows.
```

### 3. Build a SQL A/B test: compute lift, standard error, p-value from raw events.
**Problem:** Statistical significance in SQL.

```sql
SELECT 
    variant,
    AVG(converted) AS conversion_rate,
    STDDEV(converted) / SQRT(COUNT(*)) AS standard_error
FROM ab_test_data
GROUP BY variant;
```

### 4. Write SQL to detect bot traffic (aggressive page views, zero conversions).
**Problem:** Anomaly detection.

```sql
SELECT ip_address
FROM logs
GROUP BY ip_address
HAVING COUNT(*) > 1000 -- High volume
   AND SUM(CASE WHEN event = 'purchase' THEN 1 ELSE 0 END) = 0; -- Zero conversion
```

### 5. Calculate customer profitability including returns, refunds, fees.
**Problem:** Net profit per customer.

```sql
SELECT 
    user_id,
    SUM(sales_amount) - SUM(cost_of_goods) - SUM(returns_amount) - SUM(shipping_cost) AS net_profit
FROM financial_ledger
GROUP BY user_id;
```

### 6. Process time-series spikes using window smoothing.
**Problem:** Smooth out noise.

```sql
SELECT 
    date,
    val,
    AVG(val) OVER (ORDER BY date ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS smoothed_val
FROM metrics;
```

### 7. Implement feature-store-like transformations using SQL only.
**Problem:** Pre-compute features for ML.

```sql
CREATE TABLE user_features AS
SELECT 
    user_id,
    COUNT(*) AS total_orders,
    AVG(order_value) AS avg_order_value,
    MAX(order_date) AS last_order_date
FROM orders
GROUP BY user_id;
```

### 8. Build search ranking features using CTR and position bias correction.
**Problem:** Compute CTR per query-doc pair.

```sql
SELECT 
    query,
    doc_id,
    IEEE_DIVIDE(SUM(clicks), SUM(impressions)) AS ctr,
    AVG(position) AS avg_position
FROM search_logs
GROUP BY query, doc_id;
```
