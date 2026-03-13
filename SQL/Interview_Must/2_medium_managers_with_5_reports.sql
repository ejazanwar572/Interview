-- Solution for LeetCode 570: Managers with at Least 5 Direct Reports
-- Difficulty: Medium

/*
Problem: Find managers with at least five direct reports.

Edge Cases Handled:
- An employee might not have a manager (managerId is NULL).
- We only consider count of direct reports (managerId mapping) >= 5.

Example Input (Employee):
| id  | name  | department | managerId |
|-----|-------|------------|-----------|
| 101 | John  | A          | NULL      |
| 102 | Dan   | A          | 101       |
| 103 | James | A          | 101       |
| 104 | Amy   | A          | 101       |
| 105 | Anne  | A          | 101       |
| 106 | Ron   | B          | 101       |
| 107 | Mike  | C          | 102       |
| 108 | Lucas | C          | 102       |
| 109 | Sarah | D          | NULL      |

Expected Output:
| name |
|------|
| John |

Schema & DML Data:
*/
USE practice_sql_db;

DROP TABLE IF EXISTS Employee;

CREATE TABLE Employee (
    id INT,
    name VARCHAR(255),
    department VARCHAR(255),
    managerId INT
);

INSERT INTO
    Employee (
        id,
        name,
        department,
        managerId
    )
VALUES
    -- John is the manager for 5 employees (Dan, James, Amy, Anne, Ron) -> Should be included
    (101, 'John', 'A', NULL),
    (102, 'Dan', 'A', 101),
    (103, 'James', 'A', 101),
    (104, 'Amy', 'A', 101),
    (105, 'Anne', 'A', 101),
    (106, 'Ron', 'B', 101),
    -- Dan is the manager for 2 employees (Mike, Lucas) -> Should NOT be included
    (107, 'Mike', 'C', 102),
    (108, 'Lucas', 'C', 102),
    -- Employee without reports -> Should NOT be included
    (109, 'Sarah', 'D', NULL);

-- ==========================================
-- Your Sol
-- ==========================================

SELECT Manager, COUNT(DISTINCT id) as reportess
FROM (
        SELECT a.id, a.name, a.department, b.name as Manager
        FROM `Employee` a
            LEFT JOIN `Employee` b ON a.`managerId` = b.id
    ) t
GROUP BY
    1
HAVING
    reportess >= 5

-- ==========================================
-- Solutions Provided
-- ==========================================

-- Approach 1: Using JOIN and GROUP BY
-- We count the number of reports for each managerId and join with Employee to get the name.
/*
SELECT t1.name
FROM Employee AS t1 
JOIN (
SELECT managerId
FROM Employee
GROUP BY managerId
HAVING COUNT(id) >= 5
) AS t2 ON t1.id = t2.managerId;
*/

-- Approach 2: Subquery with IN (Often cleaner)
/*
SELECT name 
FROM Employee 
WHERE id IN (
SELECT managerId 
FROM Employee 
GROUP BY managerId 
HAVING COUNT(*) >= 5
);
*/