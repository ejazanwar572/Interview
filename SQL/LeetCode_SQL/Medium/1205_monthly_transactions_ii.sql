/*
1205. Monthly Transactions II
Difficulty: Medium
Table Names: Transactions, Chargebacks
Table: Transactions
| id             | int     |
| country        | varchar |
| state          | enum    |
| amount         | int     |
| trans_date     | date    |
The table has information about incoming transactions.
The state column is an enum of type ["approved", "declined"].
Table: Chargebacks
| trans_id       | int     |
| trans_date     | date    |
Chargebacks contains basic information regarding incoming chargebacks from some transactions placed in Transactions table.
trans_id is a foreign key to the id column of Transactions table.
Each chargeback corresponds to a transaction in the Transactions table.
Write an SQL query to find for each month and country: the number of approved transactions and their total amount, the number of chargebacks, and their total amount.
Note: In your query, given the month and country, ignore rows with all zeros.
Example:
Input:
Transactions table:
+-----+---------+----------+--------+------------+
| id  | country | state    | amount | trans_date |
+-----+---------+----------+--------+------------+
| 101 | US      | approved | 1000   | 2019-05-18 |
| 102 | US      | declined | 2000   | 2019-05-19 |
| 103 | US      | approved | 3000   | 2019-06-10 |
| 104 | US      | declined | 4000   | 2019-06-13 |
| 105 | US      | approved | 5000   | 2019-06-15 |
+-----+---------+----------+--------+------------+
Chargebacks table:
+----------+------------+
| trans_id | trans_date |
+----------+------------+
| 102      | 2019-05-29 |
| 101      | 2019-06-30 |
| 105      | 2019-09-18 |
+----------+------------+
Output:
+---------+---------+----------------+-----------------+------------------+-------------------+
| month   | country | approved_count | approved_amount | chargeback_count | chargeback_amount |
+---------+---------+----------------+-----------------+------------------+-------------------+
| 2019-05 | US      | 1              | 1000            | 1                | 2000              |
| 2019-06 | US      | 2              | 8000            | 1                | 1000              |
| 2019-09 | US      | 0              | 0               | 1                | 5000              |
+---------+---------+----------------+-----------------+------------------+-------------------+
Approach:
1. Get approved transactions from Transactions table.
2. Get chargebacks joining with Transactions (to get country/amount), using Chargebacks.trans_date as the event date.
3. Union these two sets to get a unified list of events (approved trans OR chargeback) with date, country, amount, type.
4. Group by month and country and sum up counts/amounts.
*/

-- Write your MySQL query statement below:













-- Solution:
/*
WITH Approved AS (
    SELECT
        DATE_FORMAT(trans_date, '%Y-%m') AS month,
        country,
        amount,
        1 AS type -- 1 for approved
    FROM
        Transactions
    WHERE
        state = 'approved'
),
ChargebackInfo AS (
    SELECT
        DATE_FORMAT(c.trans_date, '%Y-%m') AS month,
        t.country,
        t.amount,
        2 AS type -- 2 for chargeback
    FROM
        Chargebacks c
        JOIN Transactions t ON c.trans_id = t.id
),
AllEvents AS (
    SELECT month, country, amount, type FROM Approved
    UNION ALL
    SELECT month, country, amount, type FROM ChargebackInfo
)
SELECT
    month,
    country,
    SUM(CASE WHEN type = 1 THEN 1 ELSE 0 END) AS approved_count,
    SUM(CASE WHEN type = 1 THEN amount ELSE 0 END) AS approved_amount,
    SUM(CASE WHEN type = 2 THEN 1 ELSE 0 END) AS chargeback_count,
    SUM(CASE WHEN type = 2 THEN amount ELSE 0 END) AS chargeback_amount
FROM
    AllEvents
GROUP BY
    month,
    country
ORDER BY
    month,
    country;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS Transactions;
CREATE TABLE Transactions (
    id int,
    country VARCHAR(255),
    state VARCHAR(255),
    amount int,
    trans_date date
);

INSERT INTO Transactions (id, country, state, amount, trans_date) VALUES
    (101, 'US', 'approved', 1000, '2019-05-18'),
    (102, 'US', 'declined', 2000, '2019-05-19'),
    (103, 'US', 'approved', 3000, '2019-06-10'),
    (104, 'US', 'declined', 4000, '2019-06-13'),
    (105, 'US', 'approved', 5000, '2019-06-15');

DROP TABLE IF EXISTS Chargebacks;
DROP TABLE IF EXISTS Chargebacks;
CREATE TABLE Chargebacks (
    trans_id int,
    trans_date date
);

INSERT INTO Chargebacks (trans_id, trans_date) VALUES
    (102, '2019-05-29'),
    (101, '2019-06-30'),
    (105, '2019-09-18');

SET FOREIGN_KEY_CHECKS = 1;
*/
