-- Puzzle 12 - Average Days
--

-- Write an SQL statement to determine the average number of days between executions for each workflow.  

/*
| Workflow | Execution Date |
|----------|----------------|
| Alpha    | 6/1/2018       |
| Alpha    | 6/14/2018      |
| Alpha    | 6/15/2018      |
| Bravo    | 6/1/2018       |
| Bravo    | 6/2/2018       |
| Bravo    | 6/19/2018      |
| Charlie  | 6/1/2018       |
| Charlie  | 6/15/2018      |
| Charlie  | 6/30/2018      |
*/

-- Here is the expected output.

/*
| Workflow | Average Days |
|----------|--------------|
| Alpha    | 7            |
| Bravo    | 9            |
| Charlie  | 14           |
*/


-- Solution
-- Solution for Puzzle 12: Average Days
WITH DiffCTE AS (
    SELECT Workflow, ExecutionDate,
           DATEDIFF(LEAD(ExecutionDate, ExecutionDate) OVER (PARTITION BY Workflow ORDER BY ExecutionDate)) AS DaysDiff
    FROM Workflows
)
SELECT Workflow, AVG(DaysDiff)
FROM DiffCTE
WHERE DaysDiff IS NOT NULL
GROUP BY Workflow;


-- ==================================================
-- Solution for Puzzle 12
-- ==================================================

DROP TABLE IF EXISTS ProcessLog;

CREATE TABLE ProcessLog
(
Workflow       VARCHAR(100),
ExecutionDate  DATE,
PRIMARY KEY (Workflow, ExecutionDate)
);

INSERT INTO ProcessLog (Workflow, ExecutionDate) VALUES
('Alpha','6/01/2018'),('Alpha','6/14/2018'),('Alpha','6/15/2018'),
('Bravo','6/1/2018'),('Bravo','6/2/2018'),('Bravo','6/19/2018'),
('Charlie','6/1/2018'),('Charlie','6/15/2018'),('Charlie','6/30/2018');

WITH cte_DayDiff AS
(
SELECT  Workflow,
        (TIMESTAMPDIFF(1, NULL, LAG(ExecutionDate) OVER
                (PARTITION BY Workflow ORDER BY ExecutionDate),ExecutionDate)) AS DateDifference
FROM    ProcessLog
)
SELECT  Workflow,
        AVG(DateDifference)
FROM    cte_DayDiff
WHERE   DateDifference IS NOT NULL
GROUP BY Workflow;
