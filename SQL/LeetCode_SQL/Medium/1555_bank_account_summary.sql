/*
1555. Bank Account Summary
Difficulty: Medium
Table Names: Users, Transactions
Description:
Calculate the current balance of all users. Each user has an initial credit and a list of transactions.
Report the current balance and whether they are liquidated (balance < 0).
Schema:
Table: Users
| user_id       | int     |
| user_name     | varchar |
| credit        | int     |

Table: Transactions
| trans_id      | int     |
| paid_by       | int     |
| paid_to       | int     |
| amount        | int     |
| transacted_on | date    |
Example Input/Output:
Output:
+---------+------------+---------+----------------+
| user_id | user_name  | credit  | is_liquidated  |
+---------+------------+---------+----------------+
| 1       | Moustafa   | -100    | Yes            |
| 2       | Jonathan   | 500     | No             |
+---------+------------+---------+----------------+
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT
    u.user_id,
    u.user_name,
    u.credit - IFNULL(SUM(CASE WHEN t.paid_by = u.user_id THEN t.amount ELSE 0 END), 0)
             + IFNULL(SUM(CASE WHEN t.paid_to = u.user_id THEN t.amount ELSE 0 END), 0) AS credit,
    CASE
        WHEN u.credit - IFNULL(SUM(CASE WHEN t.paid_by = u.user_id THEN t.amount ELSE 0 END), 0)
                      + IFNULL(SUM(CASE WHEN t.paid_to = u.user_id THEN t.amount ELSE 0 END), 0) < 0 THEN 'Yes'
        ELSE 'No'
    END AS is_liquidated
FROM
    Users u
    LEFT JOIN Transactions t ON u.user_id = t.paid_by OR u.user_id = t.paid_to
GROUP BY
    u.user_id,
    u.user_name,
    u.credit;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Users;
CREATE TABLE Users (
    user_id int,
    user_name VARCHAR(255),
    credit int
);


DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS Transactions;
CREATE TABLE Transactions (
    trans_id int,
    paid_by int,
    paid_to int,
    amount int,
    transacted_on date
);

SET FOREIGN_KEY_CHECKS = 1;
*/
