-- Solution for LeetCode 177: Nth Highest Salary
-- Difficulty: Medium

/*
Problem Statement:
Write an SQL query to report the nth highest salary from the Employee table. If there is no nth highest salary, the query should report null.

Example Input (Employee):
| id | salary |
|----|--------|
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
| 4  | 300    |
| 5  | 400    |
| 6  | 150    |
| 7  | 200    |

Expected Output (N = 2):
| getNthHighestSalary(2) |
|------------------------|
| 300                    |

Schema & DML Data:
*/
USE practice_sql_db;

DROP TABLE IF EXISTS Employee_Nth_Salary;

CREATE TABLE Employee_Nth_Salary (id INT, salary INT);

INSERT INTO
    Employee_Nth_Salary (id, salary)
VALUES (1, 100),
    (2, 200),
    (3, 300),
    (4, 300), -- Tie for 2nd highest
    (5, 400), -- New 1st highest
    (6, 150),
    (7, 200);
-- Tie for 3rd highest

-- ==========================================
-- Your Sol
-- ==========================================

-- In MySQL or typical database clients, you need a DELIMITER 
-- to safely execute a multi-line CREATE FUNCTION script 
-- without it breaking on the first semicolon.

DELIMITER //

DROP FUNCTION IF EXISTS getNthHighestSalary //

CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    -- We declare M since MySQL LIMIT does not accept arithmetic operations like N-1
    DECLARE M INT;
    SET M = N - 1;
    RETURN (
        SELECT DISTINCT salary
        FROM Employee_Nth_Salary
        ORDER BY salary DESC
        LIMIT 1 OFFSET M
    );
END //

DELIMITER ;

-- ==========================================
-- Test Query
-- ==========================================
-- Here is how you call the function to get the 2nd highest salary:

SELECT getNthHighestSalary(3) AS SecondHighest;