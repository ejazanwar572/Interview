/*
### Problem Description
Write a SQL query to find the users who made their first and last transaction on the exact same day. Return the user IDs.

### Sample Input and Output
**Input: Transactions**
| user_id | transaction_id | transaction_date |
|---|---|---|
| 1 | 100 | '2023-01-01 10:00:00' |
| 1 | 101 | '2023-01-01 12:00:00' |
| 2 | 102 | '2023-01-01 11:00:00' |
| 2 | 103 | '2023-01-02 11:00:00' |
| 3 | 104 | '2023-01-03 09:00:00' |

**Output:**
| user_id |
|---|
| 1 |
| 3 |
*/

-- DDL and DML commands
DROP TABLE IF EXISTS Transactions;
CREATE TABLE Transactions (
    user_id INT,
    transaction_id INT,
    transaction_date TIMESTAMP
);

INSERT INTO Transactions (user_id, transaction_id, transaction_date) VALUES
(1, 100, '2023-01-01 10:00:00'),
(1, 101, '2023-01-01 12:00:00'),
(2, 102, '2023-01-01 11:00:00'),
(2, 103, '2023-01-02 11:00:00'),
(3, 104, '2023-01-03 09:00:00');


/*
### Approach
We need to group the transactions by `user_id` and evaluate whether the date (ignoring time) of their minimum transaction timestamp is the same as the date of their maximum transaction timestamp.
We can use the `HAVING` clause to filter the aggregated results where `DATE(MIN(transaction_date)) = DATE(MAX(transaction_date))`.
*/










-- Optimized Solution
SELECT user_id
FROM Transactions
GROUP BY user_id
HAVING DATE(MIN(transaction_date)) = DATE(MAX(transaction_date));
