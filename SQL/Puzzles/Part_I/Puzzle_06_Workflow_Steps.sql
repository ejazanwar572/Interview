-- Puzzle 6 - Workflow Steps
--

-- Write an SQL statement that determines all workflows that have started but have not been completed.  

/*
| Workflow | Step Number | Completion Date |
|----------|-------------|-----------------|
| Alpha    | 1           | 7/2/2018        |
| Alpha    | 2           | 7/2/2018        |
| Alpha    | 3           | 7/1/2018        |
| Bravo    | 1           | 6/25/2018       |
| Bravo    | 2           |                 |
| Bravo    | 3           | 6/27/2018       |
| Charlie  | 1           |                 |
| Charlie  | 2           | 7/1/2018        |
*/

-- Here is the expected output.

/*
| Workflow |
|----------|
| Bravo    |
| Charlie  |
*/

-- - The expected output would be `Bravo` and `Charlie`, as they have a workflow that has started but has not been completed.  
-- - **Bonus:** Write this query using only the `COUNT` function with no subqueries. Can you figure out the trick?  


-- Solution
-- Solution for Puzzle 6: Workflow Steps
SELECT Workflow
FROM Workflows
WHERE CompletionDate IS NULL
GROUP BY Workflow;


-- ==================================================
-- Solution for Puzzle 6
-- ==================================================

DROP TABLE IF EXISTS WorkflowSteps;

CREATE TABLE WorkflowSteps
(
Workflow        VARCHAR(100),
StepNumber      INTEGER,
CompletionDate  DATE NULL,
PRIMARY KEY (Workflow, StepNumber)
);

INSERT INTO WorkflowSteps (Workflow, StepNumber, CompletionDate) VALUES
('Alpha',1,'7/2/2018'),('Alpha',2,'7/2/2018'),('Alpha',3,'7/1/2018'),
('Bravo',1,'6/25/2018'),('Bravo',2,NULL),('Bravo',3,'6/27/2018'),
('Charlie',1,NULL),('Charlie',2,'7/1/2018');

--Solution 1
--NULL operators
WITH cte_NotNull AS
(
SELECT  DISTINCT
        Workflow
FROM    WorkflowSteps
WHERE   CompletionDate IS NOT NULL
),
cte_Null AS
(
SELECT  Workflow
FROM    WorkflowSteps
WHERE   CompletionDate IS NULL
)
SELECT  Workflow
FROM    cte_NotNull
WHERE   Workflow IN (SELECT Workflow FROM cte_Null);

--Solution 2
--HAVING clause and COUNT functions
SELECT  Workflow
FROM    WorkflowSteps
GROUP BY Workflow
HAVING  COUNT(*) <> COUNT(CompletionDate);

--Solution 3
--HAVING clause with MAX function
SELECT  Workflow
FROM    WorkflowSteps
GROUP BY Workflow
HAVING  MAX(CASE WHEN CompletionDate IS NULL THEN 1 ELSE 0 END) = 1;
