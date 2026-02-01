-- Puzzle 32 - First and Last
--

-- Write an SQL statement that determines the most and least experienced spaceman by their job description.

/*
| Spaceman ID | Job Description | Mission Count |
|-------------|-----------------|---------------|
| 1001        | Astrogator      | 6             |
| 2002        | Astrogator      | 12            |
| 3003        | Astrogator      | 17            |
| 4004        | Geologist       | 21            |
| 5005        | Geologist       | 9             |
| 6006        | Geologist       | 8             |
| 7007        | Technician      | 13            |
| 8008        | Technician      | 2             |
| 9009        | Technician      | 7             |
*/

-- Here is the expected output.

/*
| Job Description | Most Experienced | Least Experienced |
|-----------------|------------------|-------------------|
| Astrogator      | 3003             | 1001              |
| Geologist       | 4004             | 6006              |
| Technician      | 7007             | 8008              |
*/


-- ==================================================
-- Solution for Puzzle 32
-- ==================================================

DROP TABLE IF EXISTS Personal;

CREATE TABLE Personal
(
SpacemanID      INTEGER PRIMARY KEY,
JobDescription  VARCHAR(100) NOT NULL,
MissionCount    INTEGER NOT NULL
);

INSERT INTO Personal (SpacemanID, JobDescription, MissionCount) VALUES
(1001,'Astrogator',6),(2002,'Astrogator',12),(3003,'Astrogator',17),
(4004,'Geologist',21),(5005,'Geologist',9),(6006,'Geologist',8),
(7007,'Technician',13),(8008,'Technician',2),(9009,'Technician',7);

--Solution 1
--ROW_NUMBER, MAX, CASE
WITH RankedExperience AS 
(
SELECT  JobDescription,
        SpacemanID,
        MissionCount,
        ROW_NUMBER() OVER (PARTITION BY JobDescription ORDER BY MissionCount DESC) AS rn_max,
        ROW_NUMBER() OVER (PARTITION BY JobDescription ORDER BY MissionCount ASC) AS rn_min
FROM Personal
)
SELECT  MAX(CASE WHEN rn_max = 1 THEN JobDescription END) AS [Job Description],
        MAX(CASE WHEN rn_max = 1 THEN SpacemanID END) AS [Most Experienced],
        MAX(CASE WHEN rn_min = 1 THEN SpacemanID END) AS [Least Experienced]
FROM    RankedExperience
GROUP BY JobDescription;
	
--Solution 2
--MIN and MAX
WITH cte_MinMax AS
(
SELECT  JobDescription,
        MAX(MissionCount) AS MaxMissionCount,
        MIN(MissionCount) AS MinMissionCount
FROM    Personal
GROUP BY JobDescription
)
SELECT  a.JobDescription,
        b.SpacemanID AS MostExperienced,
        c.SpacemanID AS LeastExperienced
FROM    cte_MinMax a INNER JOIN
        Personal b ON a.JobDescription = b.JobDescription AND
                       a.MaxMissionCount = b.MissionCount  INNER JOIN
        Personal c ON a.JobDescription = c.JobDescription AND
                       a.MinMissionCount = c.MissionCount;--Solution 3
--Correlated Subquery
SELECT  s.JobDescription,
        -- Most Experienced
        (SELECT SpacemanID 
         FROM    Personal 
         WHERE   JobDescription = s.JobDescription 
         ORDER BY MissionCount DESC) AS [Most Experienced],
     
        -- Least Experienced
        (SELECT SpacemanID 
         FROM Personal 
         WHERE JobDescription = s.JobDescription 
         ORDER BY MissionCount ASC) AS [Least Experienced]
FROM     Personal s
GROUP BY s.JobDescription
LIMIT 1
LIMIT 1;
