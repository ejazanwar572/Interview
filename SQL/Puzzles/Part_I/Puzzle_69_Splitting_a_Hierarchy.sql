-- Puzzle 69 - Splitting a Hierarchy
--

-- You are given the following unbalanced hierarchical structure and must split the branches into two groups, `Group A` and `Group B`.

/*
| Parent | Child |
|--------|-------|
| A      | B     |
| A      | C     |
| B      | D     |
| B      | E     |
| D      | G     |
| C      | F     |
*/

-- Here is the expected output.

/*
|  Group  | ID |
|---------|----|
| Group A | A  |
| Group A | B  |
| Group A | D  |
| Group A | E  |
| Group A | G  |
| Group B | A  |
| Group B | C  |
| Group B | F  |
*/


-- ==================================================
-- Solution for Puzzle 69
-- ==================================================

DROP TABLE IF EXISTS OrganizationChart;

CREATE TABLE OrganizationChart
(
ManagerID   CHAR(1),
EmployeeID  CHAR(1) NOT NULL PRIMARY KEY
);

INSERT INTO OrganizationChart (ManagerID, EmployeeID) VALUES
(NULL, 'A'),
('A', 'B'),
('A', 'C'),
('B', 'D'),
('B', 'E'),
('D', 'G'),
('C', 'F');

DROP TABLE IF EXISTS OrganizationChartSummary;

CREATE TABLE OrganizationChartSummary
(
Summary  VARCHAR(5000) NOT NULL PRIMARY KEY
);

--Seed the table
INSERT INTO OrganizationChartSummary (Summary)
SELECT  EmployeeID
FROM    OrganizationChart 
WHERE   ManagerID IS NULL;

WHILE @@RowCount >= 1
BEGIN
INSERT INTO OrganizationChartSummary (Summary)
SELECT  CONCAT(a.Summary, ' / ', b.EmployeeID)
FROM    OrganizationChartSummary a INNER JOIN
        OrganizationChart b ON RIGHT(a.Summary,1) = b.ManagerID 
WHERE   CONCAT(a.Summary, ' / ', b.EmployeeID) NOT IN (SELECT Summary FROM OrganizationChartSummary);
END;

WITH cte_GroupID AS
(
SELECT  ROW_NUMBER() OVER (ORDER BY Summary) AS GroupID, 
        *
FROM    OrganizationChartSummary
WHERE   LENGTH(Summary) = LENGTH(REPLACE(Summary,'/','')) + 1 AND
        LENGTH(Summary) > 1
),
cte_Like AS
(
SELECT  a.GroupID, b.*
FROM    cte_GroupID a INNER JOIN
        OrganizationChartSummary b ON b.Summary LIKE '%' + a.Summary + '%'
)
SELECT  DISTINCT
        a.GroupID,
        TRIM(b.value) AS EmployeeID
FROM    cte_Like a
        CROSS JOIN LATERAL STRING_SPLIT(a.Summary, '/') b
ORDER BY 1,2;
