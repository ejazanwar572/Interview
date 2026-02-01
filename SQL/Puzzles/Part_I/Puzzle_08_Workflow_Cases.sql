-- Puzzle 8 - Workflow Cases
--

-- You have a report of all workflows and their case results.  

-- A value of `0` indicates the workflow failed, and a value of `1` indicates it passed.  

-- Write an SQL statement that transforms the following table into the expected output.  

/*
| Workflow | Case 1 | Case 2 | Case 3 |
|----------|--------|--------|--------|
| Alpha    | 0      | 0      | 0      |
| Bravo    | 0      | 1      | 1      |
| Charlie  | 1      | 0      | 0      |
| Delta    | 0      | 0      | 0      |
*/

-- Here is the expected output.

/*
| Workflow | Passed |
|----------|--------|
| Alpha    | 0      |
| Bravo    | 2      |
| Charlie  | 1      |
| Delta    | 0      |
*/


-- Solution
-- Solution for Puzzle 8: Workflow Cases
SELECT Workflow, (Case1 + Case2 + Case3) AS Passed
FROM WorkflowCases;


-- ==================================================
-- Solution for Puzzle 8
-- ==================================================

DROP TABLE IF EXISTS WorkflowCases;

CREATE TABLE WorkflowCases
(
Workflow  VARCHAR(100) PRIMARY KEY,
Case1     INTEGER NOT NULL DEFAULT 0,
Case2     INTEGER NOT NULL DEFAULT 0,
Case3     INTEGER NOT NULL DEFAULT 0
);

INSERT INTO WorkflowCases (Workflow, Case1, Case2, Case3) VALUES
('Alpha',0,0,0),('Bravo',0,1,1),('Charlie',1,0,0),('Delta',0,0,0);

--Solution 1
--Add each column
SELECT  Workflow,
        Case1 + Case2 + Case3 AS PassFail
FROM    WorkflowCases;

--Solution 2
--UNPIVOT operator
WITH cte_PassFail AS
(
SELECT  Workflow, CaseNumber, PassFail
FROM    (
        SELECT Workflow,Case1,Case2,Case3
        FROM WorkflowCases
        ) p UNPIVOT (PassFail FOR CaseNumber IN (Case1,Case2,Case3)) AS UNPVT
)
SELECT  Workflow,
        SUM(PassFail) AS PassFail
FROM    cte_PassFail
GROUP BY Workflow
ORDER BY 1;
