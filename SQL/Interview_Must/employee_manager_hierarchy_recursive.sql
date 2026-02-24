-- Advanced SQL Challenge: Recursive Employee Management Hierarchy
-- Difficulty: Senior

/*
Problem Statement:
Given an `Employees` table with `employee_id` and `manager_id`, write a query 
to output the full management chain hierarchy starting from a specific employee 
(e.g., employee_id = 9) all the way up to the CEO (the root node).

Output should include the 'Hierarchy Level' (1 for the employee, 2 for their manager, etc.)

This tests knowledge of Recursive Common Table Expressions (CTEs), a common 
requirement for traversing highly nested organizational or graph data.

Example Input (OrgChart):
| employee_id | employee_name                   | manager_id |
|-------------|---------------------------------|------------|
| 1           | Alice (CEO)                     | NULL       |
| 2           | Bob (VP of Eng)                 | 1          |
| 4           | David (Director of Backend)     | 2          |
| 7           | Grace (Senior Backend Engineer) | 4          |
| 8           | Heidi (Junior Backend Engineer) | 7          |
| 9           | Ivan (Intern)                   | 8          |

Expected Output (for employee_id = 9):
| employee_id | employee_name                   | manager_id | hierarchy_level |
|-------------|---------------------------------|------------|-----------------|
| 9           | Ivan (Intern)                   | 8          | 1               |
| 8           | Heidi (Junior Backend Engineer) | 7          | 2               |
| 7           | Grace (Senior Backend Engineer) | 4          | 3               |
| 4           | David (Director of Backend)     | 2          | 4               |
| 2           | Bob (VP of Eng)                 | 1          | 5               |
| 1           | Alice (CEO)                     | NULL       | 6               |

Schema & DML Data:
*/
USE practice_sql_db;

DROP TABLE IF EXISTS OrgChart;

CREATE TABLE OrgChart (
    employee_id INT,
    employee_name VARCHAR(50),
    manager_id INT -- NULL if they are the top boss (CEO)
);

INSERT INTO
    OrgChart (
        employee_id,
        employee_name,
        manager_id
    )
VALUES (1, 'Alice (CEO)', NULL),
    (2, 'Bob (VP of Eng)', 1),
    (3, 'Charlie (VP of Sales)', 1),
    (
        4,
        'David (Director of Backend)',
        2
    ),
    (
        5,
        'Eve (Director of Frontend)',
        2
    ),
    (6, 'Frank (Sales Lead)', 3),
    (
        7,
        'Grace (Senior Backend Engineer)',
        4
    ),
    (
        8,
        'Heidi (Junior Backend Engineer)',
        7
    ),
    (9, 'Ivan (Intern)', 8);

-- ==========================================
-- Your Sol
-- ==========================================

-- ==========================================
-- Solutions Provided
-- ==========================================

/*
WITH RECURSIVE Hierarchy AS (
-- 1. Base Case / Anchor Member
-- Start with the target employee (Ivan, ID 9)
SELECT 
employee_id, 
employee_name, 
manager_id, 
1 AS hierarchy_level
FROM OrgChart
WHERE employee_id = 9

UNION ALL

-- 2. Recursive Member
-- Join the CTE to the actual table to find the *manager* of the previous row
SELECT 
o.employee_id, 
o.employee_name, 
o.manager_id, 
h.hierarchy_level + 1
FROM OrgChart o
JOIN Hierarchy h ON o.employee_id = h.manager_id
-- Recursion automatically stops when the JOIN fails (e.g., manager_id is NULL for the CEO)
)
SELECT * FROM Hierarchy
ORDER BY hierarchy_level ASC;
*/