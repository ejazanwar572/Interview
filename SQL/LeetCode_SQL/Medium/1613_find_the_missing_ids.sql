/*
1613. Find the Missing IDs
Difficulty: Medium
Table Names: Customers
Description:
Find the missing customer IDs in the range between 1 and the maximum customer_id in the table.
Schema:
Table: Customers
| customer_id   | int     |
| customer_name | varchar |
Example Input/Output:
Input:
Customers table:
+-------------+---------------+
| customer_id | customer_name |
+-------------+---------------+
| 1           | Alice         |
| 4           | Bob           |
+-------------+---------------+
Output:
+-----+
| ids |
+-----+
| 2   |
| 3   |
+-----+
*/

-- Write your MySQL query statement below:













-- Solution:
/*
WITH RECURSIVE NumberSeq AS (
    SELECT 1 AS ids
    UNION ALL
    SELECT ids + 1
    FROM NumberSeq
    WHERE ids < (SELECT MAX(customer_id) FROM Customers)
)
SELECT
    ids
FROM
    NumberSeq
WHERE
    ids NOT IN (SELECT customer_id FROM Customers);

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
    customer_id int PRIMARY KEY,
    customer_name VARCHAR(255)
);

INSERT INTO Customers (customer_id, customer_name) VALUES
    (1, 'Alice'),
    (4, 'Bob');

SET FOREIGN_KEY_CHECKS = 1;
*/
