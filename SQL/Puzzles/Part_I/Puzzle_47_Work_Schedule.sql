-- Puzzle 47 - Work Schedule
--

-- Given a table of employee shifts and another table of their activities, merge the two tables and write an SQL statement that produces the desired output. If an employee is scheduled and has no activity planned, label the time frame as `Work`.

-- **Schedule**    
/*
| Schedule ID | Start Time      | End Time        |
|-------------|-----------------|-----------------|
| A           | 10/1/2021 10:00 | 10/1/2021 15:00 |
| B           | 10/1/2021 10:15 | 10/1/2021 12:15 |
*/

-- **Activity**    
/*
| Schedule ID | Activity | Start Time      | End Time        |
|-------------|----------|-----------------|-----------------|
| A           | Meeting  | 10/1/2021 10:00 | 10/1/2021 10:30 |
| A           | Break    | 10/1/2021 12:00 | 10/1/2021 12:30 |
| A           | Meeting  | 10/1/2021 13:00 | 10/1/2021 13:30 |
| B           | Break    | 10/1/2021 11:00 | 10/1/2021 11:15 |
*/

-- Here is the expected output.

/*
| Schedule ID | Activity | Start Time      | End Time        |
|-------------|----------|-----------------|-----------------|
| A           | Meeting  | 10/1/2021 10:00 | 10/1/2021 10:30 |
| A           | Work     | 10/1/2021 10:30 | 10/1/2021 12:00 |
| A           | Break    | 10/1/2021 12:00 | 10/1/2021 12:30 |
| A           | Work     | 10/1/2021 12:30 | 10/1/2021 13:00 |
| A           | Meeting  | 10/1/2021 13:00 | 10/1/2021 13:30 |
| A           | Work     | 10/1/2021 13:30 | 10/1/2021 15:00 |
| B           | Work     | 10/1/2021 10:15 | 10/1/2021 11:00 |
| B           | Break    | 10/1/2021 11:00 | 10/1/2021 11:15 |
| B           | Work     | 10/1/2021 11:15 | 10/1/2021 12:15 |
*/


-- ==================================================
-- Solution for Puzzle 47
-- ==================================================

DROP TABLE IF EXISTS Schedule;
DROP TABLE IF EXISTS Activity;
DROP TABLE IF EXISTS ScheduleTimes;
DROP TABLE IF EXISTS ActivityCoalesce;

CREATE TABLE Schedule
(
ScheduleId  CHAR(1) PRIMARY KEY,
StartTime   DATETIME NOT NULL,
EndTime     DATETIME NOT NULL
);

CREATE TABLE Activity
(
ScheduleID   CHAR(1) REFERENCES Schedule (ScheduleID),
ActivityName VARCHAR(100),
StartTime    DATETIME,
EndTime      DATETIME,
PRIMARY KEY (ScheduleID, ActivityName, StartTime, EndTime)
);

INSERT INTO Schedule (ScheduleID, StartTime, EndTime) VALUES
('A',CAST('2021-10-01 10:00:00' AS DATETIME),CAST('2021-10-01 15:00:00' AS DATETIME)),
('B',CAST('2021-10-01 10:15:00' AS DATETIME),CAST('2021-10-01 12:15:00' AS DATETIME));

INSERT INTO Activity (ScheduleID, ActivityName, StartTime, EndTime) VALUES
('A','Meeting',CAST('2021-10-01 10:00:00' AS DATETIME),CAST('2021-10-01 10:30:00' AS DATETIME)),
('A','Break',CAST('2021-10-01 12:00:00' AS DATETIME),CAST('2021-10-01 12:30:00' AS DATETIME)),
('A','Meeting',CAST('2021-10-01 13:00:00' AS DATETIME),CAST('2021-10-01 13:30:00' AS DATETIME)),
('B','Break',CAST('2021-10-01 11:00:00'AS DATETIME),CAST('2021-10-01 11:15:00' AS DATETIME));

--Step 1
SELECT  ScheduleID, StartTime AS ScheduleTime 
INTO    ScheduleTimes
FROM    Schedule
UNION
SELECT  ScheduleID, EndTime FROM Schedule
UNION
SELECT  ScheduleID, StartTime FROM Activity
UNION
SELECT  ScheduleID, EndTime FROM Activity;

--Step 2
SELECT  a.ScheduleID
        ,a.ScheduleTime
        ,COALESCE(b.ActivityName, c.ActivityName, 'Work') AS ActivityName
INTO    ActivityCoalesce
FROM    ScheduleTimes a LEFT OUTER JOIN
        Activity b ON a.ScheduleTime = b.StartTime AND a.ScheduleId = b.ScheduleID LEFT OUTER JOIN
        Activity c ON a.ScheduleTime = c.EndTime AND a.ScheduleId = b.ScheduleID LEFT OUTER JOIN
        Schedule d ON a.ScheduleTime = d.StartTime AND a.ScheduleId = b.ScheduleID LEFT OUTER JOIN
        Schedule e ON a.ScheduleTime = e.EndTime AND a.ScheduleId = b.ScheduleID 
ORDER BY a.ScheduleID, a.ScheduleTime;

--Step 3
WITH cte_Lead AS
(
SELECT  ScheduleID,
        ActivityName,
        ScheduleTime AS StartTime,
        LEAD(ScheduleTime) OVER (PARTITION BY ScheduleID ORDER BY ScheduleTime) AS EndTime
FROM    ActivityCoalesce
)
SELECT  ScheduleID, ActivityName, StartTime, EndTime
FROM    cte_Lead
WHERE   EndTime IS NOT NULL;
