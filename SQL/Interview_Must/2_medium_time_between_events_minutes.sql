/*
Problem Description:
Find the minimum time in minutes between any two events for each user.

Sample Input:
user_events table:
+----------+---------+---------------------+
| event_id | user_id | event_time          |
+----------+---------+---------------------+
| 1        | 101     | 2023-10-01 10:00:00 |
| 2        | 101     | 2023-10-01 10:15:00 |
| 3        | 101     | 2023-10-01 11:00:00 |
| 4        | 102     | 2023-10-01 09:00:00 |
| 5        | 102     | 2023-10-01 09:05:00 |
+----------+---------+---------------------+

Sample Output:
+---------+--------------------+
| user_id | min_minutes_diff   |
+---------+--------------------+
| 102     | 5                  |
| 101     | 15                 |
+---------+--------------------+
*/

-- DDL and DML
DROP TABLE IF EXISTS user_events;
CREATE TABLE user_events (
    event_id INT,
    user_id INT,
    event_time DATETIME
);

INSERT INTO user_events (event_id, user_id, event_time) VALUES
(1, 101, '2023-10-01 10:00:00'),
(2, 101, '2023-10-01 10:15:00'),
(3, 101, '2023-10-01 11:00:00'),
(4, 102, '2023-10-01 09:00:00'),
(5, 102, '2023-10-01 09:05:00');

/*
Problem Solving Approach:
1. Use `LAG()` to pull the previous `event_time` belonging to the same `user_id`, ordered chronologically.
2. Compute the exact difference using `TIMESTAMPDIFF(MINUTE, prev_event_time, event_time)`.
3. Aggregate the result per user taking `MIN(time_diff)`.
*/

-- Optimized Solution
WITH LaggedEvents AS (
    SELECT 
        user_id,
        event_time,
        LAG(event_time) OVER(PARTITION BY user_id ORDER BY event_time) as prev_event_time
    FROM user_events
)
SELECT 
    user_id,
    MIN(TIMESTAMPDIFF(MINUTE, prev_event_time, event_time)) as min_minutes_diff
FROM LaggedEvents
WHERE prev_event_time IS NOT NULL
GROUP BY user_id
ORDER BY min_minutes_diff ASC;
