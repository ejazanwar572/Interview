/*
1831. Maximum Transaction Each Day
Difficulty: Medium
Table Names: Transactions
Description:
Write an SQL query to find the transaction_id(s) with the maximum amount on their respective day. If there is a tie, report all of them.
Schema:
Table: Transactions
| transaction_id| int     |
| day           | datetime|
| amount        | int     |
Example Input/Output:
Output:
+----------------+
| transaction_id |
+----------------+
| 1              |
| 5              |
| 8              |
+----------------+
*/

-- Write your MySQL query statement below:













-- Solution:
/*
WITH RankedTransactions AS (
    SELECT
        transaction_id,
        day,
        amount,
        RANK() OVER (
            PARTITION BY DATE(day) 
            ORDER BY amount DESC
        ) AS rn
    FROM
        Transactions
)
SELECT
    transaction_id
FROM
    RankedTransactions
WHERE
    rn = 1
ORDER BY
    transaction_id;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS Transactions;
CREATE TABLE Transactions (
    transaction_id int,
    day datetime,
    amount int
);

INSERT INTO Transactions (transaction_id) VALUES
    (1),
    (5),
    (8);

SET FOREIGN_KEY_CHECKS = 1;
*/
