/*
Problem: Measure CTR Over Time and Year-Over-Year Growth
Description: You have an events table tracking ad impressions and clicks. Write a query to measure the daily CTR over time and calculate the YoY growth of that CTR for each specific day compared to the exact same day in the previous year.

Sample Input: `ad_events`
| event_date | user_id | event_type | ad_id |
|------------|---------|------------|-------|
| 2023-01-01 | 1       | impression | 101   |
| 2023-01-01 | 1       | click      | 101   |
| 2023-01-01 | 2       | impression | 102   |
| 2024-01-01 | 3       | impression | 101   |
| 2024-01-01 | 3       | click      | 101   |
| 2024-01-01 | 4       | click      | 102   |

Sample Output:
| event_date | daily_ctr | prev_year_ctr | yoy_growth_pct |
|------------|-----------|---------------|----------------|
| 2023-01-01 | 0.50      | NULL          | NULL           |
| 2024-01-01 | 1.00      | 0.50          | 100.00         |
*/

-- DDL & DML
CREATE TABLE IF NOT EXISTS ad_events (
    event_date DATE,
    user_id INT,
    event_type VARCHAR(50),
    ad_id INT
);
TRUNCATE TABLE ad_events;
INSERT INTO ad_events VALUES 
('2023-01-01', 1, 'impression', 101),
('2023-01-01', 1, 'click', 101),
('2023-01-01', 2, 'impression', 102),
('2024-01-01', 3, 'impression', 101),
('2024-01-01', 3, 'click', 101),
('2024-01-01', 4, 'impression', 102),
('2024-01-01', 4, 'click', 102);

/*
Tips for Problem Solving:
1. First, calculate the daily CTR by aggregating clicks and impressions per day. Remember CTR = total clicks / total impressions. Be careful of division by zero.
2. Next, use a self-join or the LAG() window function to find the CTR for the same day in the previous year. Since it's a daily aggregate, `LAG(..., 365)` might work if data is dense, but doing a DATE_ADD/DATE_SUB join is much safer for missing days.
3. Calculate YoY growth: ((Current - Previous) / Previous) * 100
*/

-- Optimized Solution
WITH daily_metrics AS (
    SELECT 
        event_date,
        SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) AS total_clicks,
        SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END) AS total_impressions,
        -- IFNULL or NULLIF prevents division by zero
        SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) / 
            NULLIF(SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END), 0) AS daily_ctr
    FROM ad_events
    GROUP BY event_date
)
SELECT 
    curr.event_date,
    curr.daily_ctr,
    prev.daily_ctr AS prev_year_ctr,
    ROUND(((curr.daily_ctr - prev.daily_ctr) / NULLIF(prev.daily_ctr, 0)) * 100, 2) AS yoy_growth_pct
FROM daily_metrics curr
LEFT JOIN daily_metrics prev 
    ON curr.event_date = DATE_ADD(prev.event_date, INTERVAL 1 YEAR)
ORDER BY curr.event_date;

DROP TABLE ad_events;


/* ========================================================================= */

/*
Problem: Highest CTR Day of the Week
Description: Identify the day of the week that most often has the highest CTR on average across a given historical period.

Sample Input: `ad_events` (Same format as above, assuming more rows covering multiple weeks)
Sample Output:
| day_of_week | avg_ctr |
|-------------|---------|
| Sunday      | 0.08    |
*/

-- DDL & DML (Skipped for brevity as it reuses the table schema above)

/*
Tips for Problem Solving:
1. Extract the day of the week from the date using DAYNAME() or WEEKDAY().
2. You can either find the daily CTR first and then average those by day of week, OR sum all historical clicks for Mondays, Tuesdays, etc., and divide by historical impressions. The business logic dictates which is better (averaging rates vs global rate). The global rate is generally preferred to avoid weighting low-volume days too heavily.
3. Order by the final CTR descending and LIMIT 1.
*/

-- Optimized Solution
SELECT 
    DAYNAME(event_date) AS day_of_week,
    SUM(CASE WHEN event_type = 'click' THEN 1.0 ELSE 0.0 END) / 
        NULLIF(SUM(CASE WHEN event_type = 'impression' THEN 1.0 ELSE 0.0 END), 0) AS avg_historical_ctr
FROM ad_events
GROUP BY DAYNAME(event_date)
ORDER BY avg_historical_ctr DESC
LIMIT 1;
