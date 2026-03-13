/*
### Problem Description
You are analyzing an A/B test. The `assignments` table shows which group ('control' or 'test') a user was placed in and the precise timestamp. The `events` table tracks 'click' events. Calculate the Click-Through Rate (CTR) for both the Control and Test groups. 

*Critical constraint:* Only clicks that occurred *strictly after* the user was assigned to their group should be counted towards their group's CTR. CTR is defined as `(Users who clicked / Total users assigned) * 100`.

### Sample Input and Output
**Input: assignments**
| user_id | variant | assignment_time |
|---|---|---|
| 1 | 'control' | '2024-01-01 10:00:00' |
| 2 | 'test' | '2024-01-01 11:00:00' |
| 3 | 'test' | '2024-01-01 12:00:00' |

**Input: events**
| event_id | user_id | event_name | event_time |
|---|---|---|---|
| 100 | 1 | 'click' | '2024-01-01 10:05:00' | -- Valid (after assignment)
| 101 | 2 | 'click' | '2024-01-01 09:00:00' | -- Invalid (before assignment)
| 102 | 3 | 'view' | '2024-01-01 12:05:00' | -- Invalid (wrong event)

**Output:**
| variant | total_users | clicking_users | ctr_percentage |
|---|---|---|---|
| 'control' | 1 | 1 | 100.00 |
| 'test' | 2 | 0 | 0.00 |
*/

-- DDL and DML commands
DROP TABLE IF EXISTS assignments;
CREATE TABLE assignments (
    user_id INT,
    variant VARCHAR(20),
    assignment_time TIMESTAMP
);

DROP TABLE IF EXISTS events;
CREATE TABLE events (
    event_id INT,
    user_id INT,
    event_name VARCHAR(20),
    event_time TIMESTAMP
);

INSERT INTO assignments (user_id, variant, assignment_time) VALUES
(1, 'control', '2024-01-01 10:00:00'),
(2, 'test', '2024-01-01 11:00:00'),
(3, 'test', '2024-01-01 12:00:00');

INSERT INTO events (event_id, user_id, event_name, event_time) VALUES
(100, 1, 'click', '2024-01-01 10:05:00'),
(101, 2, 'click', '2024-01-01 09:00:00'),
(102, 3, 'view', '2024-01-01 12:05:00');


/*
### Approach
1. Use the `assignments` table as the base to ensure we count all users, even those who didn't click (`LEFT JOIN`).
2. Join `events` but include the time constraint `e.event_time > a.assignment_time` directly in the `ON` clause. 
3. Include the event filter `e.event_name = 'click'` in the `ON` clause so unmatched users still return as part of the total.
4. Group by the variant and aggregate the counts. Use `COUNT(DISTINCT ...)` to handle users who clicked multiple times.
*/










-- Optimized Solution
SELECT 
    a.variant,
    COUNT(DISTINCT a.user_id) AS total_users,
    COUNT(DISTINCT e.user_id) AS clicking_users,
    ROUND(
        (COUNT(DISTINCT e.user_id) * 100.0) / COUNT(DISTINCT a.user_id), 
        2
    ) AS ctr_percentage
FROM assignments a
LEFT JOIN events e 
  ON a.user_id = e.user_id 
  AND e.event_name = 'click'
  AND e.event_time > a.assignment_time
GROUP BY a.variant;
