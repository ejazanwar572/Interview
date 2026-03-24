/*
Problem Description:
Find the second most recent transaction for each user. If a user has only one transaction, return that transaction.

Sample Input:
transactions table:
+--------+---------+---------------------+--------+
| trx_id | user_id | transaction_date    | amount |
+--------+---------+---------------------+--------+
| 1      | 101     | 2023-11-01 10:00:00 | 50.0   |
| 2      | 101     | 2023-11-05 14:30:00 | 150.0  |
| 3      | 101     | 2023-11-10 09:15:00 | 200.0  |
| 4      | 102     | 2023-11-02 11:00:00 | 100.0  |
+--------+---------+---------------------+--------+

Sample Output:
+--------+---------+---------------------+--------+
| trx_id | user_id | transaction_date    | amount |
+--------+---------+---------------------+--------+
| 2      | 101     | 2023-11-05 14:30:00 | 150.0  |
| 4      | 102     | 2023-11-02 11:00:00 | 100.0  |
+--------+---------+---------------------+--------+
*/

-- DDL and DML
DROP TABLE IF EXISTS transactions;
CREATE TABLE transactions (
    trx_id INT,
    user_id INT,
    transaction_date DATETIME,
    amount DECIMAL(10, 2)
);

INSERT INTO transactions (trx_id, user_id, transaction_date, amount) VALUES
(1, 101, '2023-11-01 10:00:00', 50.0),
(2, 101, '2023-11-05 14:30:00', 150.0),
(3, 101, '2023-11-10 09:15:00', 200.0),
(4, 102, '2023-11-02 11:00:00', 100.0);

/*
Problem Solving Approach:
1. Use the `ROW_NUMBER()` window function to rank each user's transactions by date in descending order.
2. Also calculate the total number of transactions for each user using `COUNT() OVER()`.
3. Filter the results where the rank is 2 (second most recent) OR the total count is 1 (only one transaction exists).
*/

-- Optimized Solution
WITH RankedTransactions AS (
    SELECT 
        trx_id,
        user_id,
        transaction_date,
        amount,
        ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date DESC) as rnk,
        COUNT(trx_id) OVER(PARTITION BY user_id) as total_txns
    FROM transactions
)
SELECT 
    trx_id,
    user_id,
    transaction_date,
    amount
FROM RankedTransactions
WHERE rnk = 2 OR total_txns = 1;
