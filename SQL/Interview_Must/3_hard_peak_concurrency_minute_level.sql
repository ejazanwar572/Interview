/*
### Problem Description
You are given a table of user `Sessions` containing a `user_id`, a timestamp of when they logged in (`login_time`), and a timestamp of when they logged out (`logout_time`). Provide a query that determines the specific minute at which the system saw the absolute maximum peak concurrency.

### Sample Input and Output
**Input: Sessions**
| user_id | login_time | logout_time |
|---|---|---|
| 1 | '2024-01-01 10:00:00' | '2024-01-01 10:05:00' |
| 2 | '2024-01-01 10:02:00' | '2024-01-01 10:08:00' |
| 3 | '2024-01-01 10:04:00' | '2024-01-01 10:10:00' |

**Output:**
| peak_minute | max_concurrent_users |
|---|---|
| '2024-01-01 10:04:00' | 3 |
*/

-- DDL and DML commands
DROP TABLE IF EXISTS Sessions;
CREATE TABLE Sessions (
    user_id INT,
    login_time TIMESTAMP,
    logout_time TIMESTAMP
);

INSERT INTO Sessions (user_id, login_time, logout_time) VALUES
(1, '2024-01-01 10:00:00', '2024-01-01 10:05:00'),
(2, '2024-01-01 10:02:00', '2024-01-01 10:08:00'),
(3, '2024-01-01 10:04:00', '2024-01-01 10:10:00');


/*
### Approach
To calculate active concurrent users precisely without losing boundaries, we unpivot (or explode) the data into discrete timeline events.
1. Every `login_time` results in a +1 change to active users.
2. Every `logout_time` results in a -1 change to active users.
3. We `UNION ALL` these events into a single timeline.
4. We group the timeline events by the minute truncate, and sum all changes per minute (net flow).
5. We calculate a running total across time using `SUM() OVER(ORDER BY time)` to determine total people online at any minute.
6. Order by that running total `DESC` and pull the peak point.
*/


SELECT * FROM `Sessions`







-- Optimized Solution
WITH EventStream AS (
    SELECT 
        DATE_FORMAT(login_time, '%Y-%m-%d %H:%i:00') AS event_minute, 
        1 AS user_delta
    FROM Sessions
    
    UNION ALL
    
    SELECT 
        DATE_FORMAT(logout_time, '%Y-%m-%d %H:%i:00') AS event_minute, 
        -1 AS user_delta
    FROM Sessions
),
MinuteChanges AS (
    -- Consolidate overlapping logins/logouts at the exact same minute
    SELECT 
        event_minute,
        SUM(user_delta) as net_change
    FROM EventStream
    GROUP BY event_minute
),
RunningConcurrency AS (
    -- Compute running total
    SELECT 
        event_minute,
        SUM(net_change) OVER (ORDER BY event_minute ASC) as concurrent_users
    FROM MinuteChanges
)
SELECT 
    event_minute AS peak_minute,
    concurrent_users AS max_concurrent_users
FROM RunningConcurrency
ORDER BY concurrent_users DESC
LIMIT 1;

