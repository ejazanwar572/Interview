/*
### Problem Description
Given a table of `Registrations`, write a query to find the pairs of users who registered within exactly 1 day (24 hours or less) of each other. Ensure pairs are unique (i.e. if user 1 and user 2 are a pair, do not list user 2 and user 1).

### Sample Input and Output
**Input: Registrations**
| user_id | reg_time |
|---|---|
| 1 | '2023-01-01 10:00:00' |
| 2 | '2023-01-01 14:00:00' |
| 3 | '2023-01-05 10:00:00' |
| 4 | '2023-01-02 09:00:00' |

**Output:**
| user1_id | user2_id |
|---|---|
| 1 | 2 |
| 1 | 4 |
| 2 | 4 |
*/

-- DDL and DML commands
DROP TABLE IF EXISTS Registrations;
CREATE TABLE Registrations (
    user_id INT,
    reg_time TIMESTAMP
);

INSERT INTO Registrations (user_id, reg_time) VALUES
(1, '2023-01-01 10:00:00'),
(2, '2023-01-01 14:00:00'),
(3, '2023-01-05 10:00:00'),
(4, '2023-01-02 09:00:00');


/*
### Approach
To find pairs of distinct users meeting a specific criteria, we should do a self-join (`JOIN Registrations r1 JOIN Registrations r2`).
To ensure we only get unique pairs `(a, b)` and omit the reversed pair `(b, a)` as well as identity duplicates `(a, a)`, we join on a condition where `r1.user_id < r2.user_id`.
Then we check if the absolute difference between their registration times is less than or equal to 1 day (or 24 hours depending on the SQL dialect). 
*/










-- Optimized Solution
SELECT 
    r1.user_id AS user1_id,
    r2.user_id AS user2_id
FROM Registrations r1
JOIN Registrations r2
  ON r1.user_id < r2.user_id -- Unique pairs constraint
WHERE ABS(TIMESTAMPDIFF(HOUR, r1.reg_time, r2.reg_time)) <= 24; 

/*
-- Note: 'TIMESTAMPDIFF' is MySQL syntax. 
-- In PostgreSQL you could do: 
-- WHERE ABS(EXTRACT(EPOCH FROM (r1.reg_time - r2.reg_time))) <= 86400
*/
