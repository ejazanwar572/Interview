-- Puzzle 73 - Distinct Statuses
--

-- You are given a list of workflows with different statuses. For each record, determine the number of unique statuses that occurred prior to and including the current status.

/*
| Step ID | Workflow | Status  |
|---------|----------|---------|
| 1       | Alpha   | Open     |
| 2       | Alpha   | Open     |
| 3       | Alpha   | Inactive |
| 4       | Alpha   | Open     |
| 5       | Bravo   | Closed   |
| 6       | Bravo   | Closed   |
| 7       | Bravo   | Open     |
| 8       | Bravo   | Inactive |
*/

-- Here is the expected output.

/*
| Step ID | Workflow | Status   | Count |
|---------|----------|----------|-------|
| 1       | Alpha    | Open     | 1     |
| 2       | Alpha    | Open     | 1     |
| 3       | Alpha    | Inactive | 2     |
| 4       | Alpha    | Open     | 2     |
| 5       | Bravo    | Closed   | 1     |
| 6       | Bravo    | Closed   | 1     |
| 7       | Bravo    | Open     | 2     |
| 8       | Bravo    | Inactive | 3     |
*/


-- ==================================================
-- Solution for Puzzle 73
-- ==================================================

DROP TABLE IF EXISTS WorkflowSteps;

CREATE TABLE WorkflowSteps
(
StepID    INTEGER PRIMARY KEY,
Workflow  VARCHAR(50),
[Status]  VARCHAR(50)
);

INSERT INTO WorkflowSteps (StepID, Workflow, [Status]) VALUES
(1, 'Alpha', 'Open'),
(2, 'Alpha', 'Open'),
(3, 'Alpha', 'Inactive'),
(4, 'Alpha', 'Open'),
(5, 'Bravo', 'Closed'),
(6, 'Bravo', 'Closed'),
(7, 'Bravo', 'Open'),
(8, 'Bravo', 'Inactive');

SELECT  a.StepID,
        a.Workflow,
        a.[Status],
        COUNT(DISTINCT b.[Status]) AS [Count]
FROM    WorkflowSteps a INNER JOIN
        WorkflowSteps b ON a.StepID >= b.StepID AND a.Workflow = b.Workflow
GROUP BY a.StepID, a.Workflow, a.[Status]
ORDER BY 1;
