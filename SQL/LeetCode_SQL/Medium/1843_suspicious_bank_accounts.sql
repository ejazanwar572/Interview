/*
1843. Suspicious Bank Accounts
Difficulty: Medium
Table Names: Accounts, Transactions
Description:
A bank account is suspicious if the total income exceeds the max_income for this account for two or more consecutive months.
The total income of an account in some month is the sum of all its deposits in that month (i.e., transactions of the type 'Creditor').
Write an SQL query to report the IDs of all suspicious bank accounts.
Schema:
Table: Accounts
| account_id     | int  |
| max_income     | int  |

Table: Transactions
| transaction_id | int      |
| account_id     | int      |
| type           | ENUM     |
| amount         | int      |
| day            | datetime |
type is ENUM('Creditor', 'Debtor') where 'Creditor' means the user deposited money and 'Debtor' means the user withdrew money.
Example Input/Output:
Output:
+------------+
| account_id |
+------------+
| 3          |
+------------+
*/

-- Write your MySQL query statement below:













-- Solution:
/*
WITH MonthlyIncome AS (
    SELECT
        t.account_id,
        DATE_FORMAT(t.day, '%Y-%m') AS month,
        SUM(t.amount) AS total_income
    FROM
        Transactions t
    WHERE
        t.type = 'Creditor'
    GROUP BY
        t.account_id,
        DATE_FORMAT(t.day, '%Y-%m')
),
ExcessiveMonths AS (
    SELECT
        mi.account_id,
        mi.month,
        mi.total_income
    FROM
        MonthlyIncome mi
        JOIN Accounts a ON mi.account_id = a.account_id
    WHERE
        mi.total_income > a.max_income
),
ConsecutiveExcess AS (
    SELECT
        account_id,
        month,
        LEAD(month, 1) OVER (PARTITION BY account_id ORDER BY month) AS next_month
    FROM
        ExcessiveMonths
)
SELECT DISTINCT
    account_id
FROM
    ConsecutiveExcess
WHERE
    PERIOD_DIFF(DATE_FORMAT(STR_TO_DATE(next_month, '%Y-%m'), '%Y%m'), DATE_FORMAT(STR_TO_DATE(month, '%Y-%m'), '%Y%m')) = 1;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Accounts;
DROP TABLE IF EXISTS Accounts;
CREATE TABLE Accounts (
    account_id int,
    max_income int
);

INSERT INTO Accounts (account_id) VALUES
    (3);

DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS Transactions;
CREATE TABLE Transactions (
    transaction_id int,
    account_id int,
    type VARCHAR(255),
    amount int,
    day datetime
);

SET FOREIGN_KEY_CHECKS = 1;
*/
