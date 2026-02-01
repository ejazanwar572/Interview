-- Puzzle 14 - Indeterminate Process Log
--

-- Your process log contains several workflows, each broken down by step number, with possible status values of `Complete`, `Running`, or `Error`.  

-- Your task is to write an SQL statement that creates an overall status based on the following requirements:  

-- - If all steps of a workflow are of the same status (`Error`, `Complete`, or `Running`), then return the distinct status.  
-- - If any steps of a workflow have an `Error` status along with a status of `Complete` or `Running`, set the overall status to `Indeterminate`.  
-- - If the workflow steps have a combination of `Complete` and `Running` (without any Errors), set the overall status to `Running`.  

/*
| Workflow | Step Number |  Status  |
|----------|-------------|----------|
| Alpha    | 1           | Error    |
| Alpha    | 2           | Complete |
| Alpha    | 3           | Running  |
| Bravo    | 1           | Complete |
| Bravo    | 2           | Complete |
| Charlie  | 1           | Running  |
| Charlie  | 2           | Running  |
| Delta    | 1           | Error    |
| Delta    | 2           | Error    |
| Echo     | 1           | Running  |
| Echo     | 2           | Complete |
*/

-- Here is the expected output.

/*
| Workflow |    Status     |
|----------|---------------|
| Alpha    | Indeterminate |
| Bravo    | Complete      |
| Charlie  | Running       |
| Delta    | Error         |
| Echo     | Running       |
*/


-- Solution
-- Solution for Puzzle 14: Indeterminate Process Log
WITH StatusCounts AS (
    SELECT Workflow,
           SUM(CASE WHEN Status = 'Error' THEN 1 ELSE 0 END) AS ErrorCount,
           SUM(CASE WHEN Status = 'Running' THEN 1 ELSE 0 END) AS RunningCount,
           SUM(CASE WHEN Status = 'Complete' THEN 1 ELSE 0 END) AS CompleteCount,
           COUNT(*) AS TotalCount
    FROM ProcessLog
    GROUP BY Workflow
)
SELECT Workflow,
       CASE
           WHEN ErrorCount > 0 AND ErrorCount < TotalCount THEN 'Indeterminate'
           WHEN ErrorCount = TotalCount THEN 'Error'
           WHEN RunningCount > 0 AND CompleteCount > 0 THEN 'Running'
           WHEN RunningCount = TotalCount THEN 'Running'
           WHEN CompleteCount = TotalCount THEN 'Complete'
       END AS Status
FROM StatusCounts;


-- ==================================================
-- Solution for Puzzle 14
-- ==================================================

DROP TABLE IF EXISTS ProcessLog;

CREATE TABLE ProcessLog
(
Workflow    VARCHAR(100),
StepNumber  INTEGER,
RunStatus   VARCHAR(100) NOT NULL,
PRIMARY KEY (Workflow, StepNumber)
);

INSERT INTO ProcessLog (Workflow, StepNumber, RunStatus) VALUES
('Alpha',1,'Error'),('Alpha',2,'Complete'),('Alpha',3,'Running'),
('Bravo',1,'Complete'),('Bravo',2,'Complete'),
('Charlie',1,'Running'),('Charlie',2,'Running'),
('Delta',1,'Error'),('Delta',2,'Error'),
('Echo',1,'Running'),('Echo',2,'Complete');

--Solution 1
--MIN and MAX
WITH cte_MinMax AS
(
SELECT  Workflow,
        MIN(RunStatus) AS MinStatus,
        MAX(RunStatus) AS MaxStatus
FROM    ProcessLog
GROUP BY Workflow
),
cte_Error AS
(
SELECT  Workflow,
        MAX(CASE RunStatus WHEN 'Error' THEN RunStatus END) AS ErrorState,
        MAX(CASE RunStatus WHEN 'Running' THEN RunStatus END) AS RunningState
FROM    ProcessLog
WHERE   RunStatus IN ('Error','Running')
GROUP BY Workflow
)
SELECT  a.Workflow,
        CASE WHEN a.MinStatus = a.MaxStatus THEN a.MinStatus
             WHEN b.ErrorState = 'Error' THEN 'Indeterminate'
             WHEN b.RunningState = 'Running' THEN b.RunningState END AS RunStatus
FROM    cte_MinMax a LEFT OUTER JOIN
        cte_Error b ON a.WorkFlow = b.WorkFlow
ORDER BY 1;

--Solution 2
--COUNT and STRING_AGG
WITH cte_Distinct AS
(
SELECT DISTINCT
       Workflow,
       RunStatus
FROM   ProcessLog
),
cte_StringAgg AS
(
SELECT  Workflow,
        GROUP_CONCAT(RunStatus SEPARATOR ', ') AS RunStatus_Agg,
        COUNT(DISTINCT RunStatus) AS DistinctCount
FROM    cte_Distinct
GROUP BY Workflow
)
SELECT  Workflow,
        CASE WHEN DistinctCount = 1 THEN RunStatus_Agg
             WHEN RunStatus_Agg LIKE '%Error%' THEN 'Indeterminate'
             WHEN RunStatus_Agg LIKE '%Running%' THEN 'Running' END AS RunStatus
FROM    cte_StringAgg
ORDER BY 1;
