/*
### Problem Description
Write a SQL query to delete all duplicate email entries in a table named `Person`, keeping only unique emails based on its smallest `Id`. Use a `DELETE` statement and not a `SELECT` statement.

### Sample Input and Output
**Input: Person**
| Id | Email |
|---|---|
| 1 | john@example.com |
| 2 | bob@example.com |
| 3 | john@example.com |

**Output:**
| Id | Email |
|---|---|
| 1 | john@example.com |
| 2 | bob@example.com |
*/

-- DDL and DML commands
DROP TABLE IF EXISTS Person;
CREATE TABLE Person (
    Id INT PRIMARY KEY,
    Email VARCHAR(255)
);

INSERT INTO Person (Id, Email) VALUES
(1, 'john@example.com'),
(2, 'bob@example.com'),
(3, 'john@example.com');


/*
### Approach
To delete duplicate records while preserving the one with the smallest ID, we can use a self-join or a subquery.
A robust approach is using `ROW_NUMBER()` over a partition of the email, ordering by ID. 
If the row number > 1, it's a duplicate. However, standard SQL often uses a simpler self-join for DELETE:
We delete `p1` if there exists another record `p2` with the same email but a smaller ID.
*/










-- Optimized Solution
DELETE p1
FROM Person p1
JOIN Person p2
ON p1.Email = p2.Email AND p1.Id > p2.Id;

/* 
Alternative using Subquery (Often used if JOIN in DELETE is not supported by dialect):
DELETE FROM Person 
WHERE Id NOT IN (
    SELECT MIN(Id) 
    FROM Person 
    GROUP BY Email
);
*/
