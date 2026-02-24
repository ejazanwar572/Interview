-- Advanced SQL Challenge: User Search Sessions (30 Min Gap)
-- Difficulty: Senior

/*
Problem Statement:
Compute the total number of unique search 'sessions' for users based on their activity timestamps.
A 'new session' is definitively marked when a user has a gap of more than 30 minutes 
between consecutive search events.

Expected Output:
user_id, session_id (Sequential integer per user), session_start_time, session_end_time, event_count

Edge Cases Handled:
- Users with only a single event.
- Multiple short events forming a single long session.

Example Input (UserSearchEvents):
| user_id | event_time          |
|---------|---------------------|
| 1       | 2023-11-01 10:00:00 |
| 1       | 2023-11-01 10:15:00 |
| 1       | 2023-11-01 10:35:00 |
| 1       | 2023-11-01 11:15:00 |
| 2       | 2023-11-01 08:00:00 |
| 3       | 2023-11-01 15:00:00 |
| 3       | 2023-11-01 15:05:00 |
| 3       | 2023-11-01 16:00:00 |

Expected Output:
| user_id | session_id | session_start_time  | session_end_time    | event_count |
|---------|------------|---------------------|---------------------|-------------|
| 1       | 1          | 2023-11-01 10:00:00 | 2023-11-01 10:35:00 | 3           |
| 1       | 2          | 2023-11-01 11:15:00 | 2023-11-01 11:15:00 | 1           |
| 2       | 1          | 2023-11-01 08:00:00 | 2023-11-01 08:00:00 | 1           |
| 3       | 1          | 2023-11-01 15:00:00 | 2023-11-01 15:05:00 | 2           |
| 3       | 2          | 2023-11-01 16:00:00 | 2023-11-01 16:00:00 | 1           |

Schema & DML Data:
*/
USE practice_sql_db;

DROP TABLE IF EXISTS UserSearchEvents;

CREATE TABLE UserSearchEvents (
    user_id INT,
    event_time DATETIME
);

INSERT INTO
    UserSearchEvents (user_id, event_time)
VALUES (1, '2023-11-01 10:00:00'), -- Session 1 Starts
    (1, '2023-11-01 10:15:00'), -- Same session (15m gap)
    (1, '2023-11-01 10:35:00'), -- Same session (20m gap)
    (1, '2023-11-01 11:15:00'), -- Session 2 Starts (40m gap!)
    (2, '2023-11-01 08:00:00'), -- Single event session
    (3, '2023-11-01 15:00:00'), -- Session 1 Starts
    (3, '2023-11-01 15:05:00'),
    (3, '2023-11-01 16:00:00');
-- Session 2 Starts (55m gap)

-- ==========================================
-- Your Sol
-- ==========================================

-- ==========================================
-- Solutions Provided
-- ==========================================

/*
WITH TimeGaps AS (
SELECT 
user_id,
event_time,
-- Calculate the difference in minutes from the prior event
TIMESTAMPDIFF(MINUTE, 
LAG(event_time) OVER(PARTITION BY user_id ORDER BY event_time), 
event_time
) as min_since_last_event
FROM UserSearchEvents
),
SessionFlags AS (
SELECT 
user_id,
event_time,
-- If the gap is > 30 mins OR it's the first event (NULL), mark as a new session (1)
CASE WHEN min_since_last_event > 30 OR min_since_last_event IS NULL THEN 1 ELSE 0 END AS is_new_session
FROM TimeGaps
),
SessionIDs AS (
SELECT
user_id,
event_time,
-- A running total of the flags gives us a unique session ID per user!
SUM(is_new_session) OVER (
PARTITION BY user_id 
ORDER BY event_time
) AS session_id
FROM SessionFlags
)
SELECT 
user_id,
session_id,
MIN(event_time) AS session_start_time,
MAX(event_time) AS session_end_time,
COUNT(*) AS event_count
FROM SessionIDs
GROUP BY 
user_id, 
session_id;
*/