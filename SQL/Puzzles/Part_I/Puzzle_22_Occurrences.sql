-- Puzzle 22 - Occurrences
--

-- Write an SQL statement that returns all distinct process log messages and the workflow in which each message occurred most often.

/*
| Workflow | Message                            | Occurrences |
|----------|------------------------------------|-------------|
| Bravo    | Error: Cannot Divide by 0          | 3           |
| Alpha    | Error: Conversion Failed           | 5           |
| Charlie  | Error: Conversion Failed           | 7           |
| Alpha    | Error: Unidentified error occurred | 9           |
| Bravo    | Error: Unidentified error occurred | 1           |
| Charlie  | Error: Unidentified error occurred | 10          |
| Alpha    | Status Complete                    | 8           |
| Charlie  | Status Complete                    | 6           |
*/

-- Here is the expected output.

/*
| Workflow | Message                            | Occurrences |
|----------|------------------------------------|-------------|
| Bravo    | Error: Cannot Divide by 0          | 3           |
| Charlie  | Error: Conversion Failed           | 7           |
| Charlie  | Error: Unidentified error occurred | 10          |
| Alpha    | Status Complete                    | 8           |
*/


-- ==================================================
-- Solution for Puzzle 22
-- ==================================================

DROP TABLE IF EXISTS ProcessLog;

CREATE TABLE ProcessLog
(
Workflow     VARCHAR(100),
LogMessage   VARCHAR(100),
Occurrences  INTEGER NOT NULL,
PRIMARY KEY (Workflow, LogMessage)
);

INSERT INTO ProcessLog (Workflow, LogMessage, Occurrences) VALUES
('Alpha','Error: Conversion Failed',5),
('Alpha','Status Complete',8),
('Alpha','Error: Unidentified error occurred',9),
('Bravo','Error: Cannot Divide by 0',3),
('Bravo','Error: Unidentified error occurred',1),
('Charlie','Error: Unidentified error occurred',10),
('Charlie','Error: Conversion Failed',7),
('Charlie','Status Complete',6);

--Solution 1
--Rank 
WITH cte_RankedMessages AS 
(
SELECT  Workflow,
        LogMessage,
        Occurrences,
        RANK() OVER (PARTITION BY LogMessage ORDER BY Occurrences DESC) AS rnk
FROM ProcessLog
)
SELECT Workflow, LogMessage, Occurrences
FROM   cte_RankedMessages
WHERE rnk = 1;

--Solution 2
--MAX
WITH cte_LogMessageCount AS
(
SELECT  LogMessage,
        MAX(Occurrences) AS MaxOccurrences
FROM    ProcessLog
GROUP BY LogMessage
)
SELECT  a.Workflow,
        a.LogMessage,
        a.Occurrences
FROM    ProcessLog a INNER JOIN
        cte_LogMessageCount b ON a.LogMessage = b.LogMessage AND
                                 a.Occurrences = b.MaxOccurrences
ORDER BY 1;

--Solution 3
--Correlated Subquery
SELECT Workflow, LogMessage, Occurrences
FROM ProcessLog p
WHERE Occurrences = (SELECT MAX(Occurrences) FROM ProcessLog WHERE LogMessage = p.LogMessage);

--Solution 4
--ALL
--Correlated Subquery
SELECT  WorkFlow,
        LogMessage,
        Occurrences
FROM    ProcessLog AS e1
WHERE   Occurrences > ALL(SELECT    e2.Occurrences
                            FROM    ProcessLog AS e2
                           WHERE    e2.LogMessage = e1.LogMessage AND
                                    e2.WorkFlow <> e1.WorkFlow);
