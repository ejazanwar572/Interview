/*
1193. Monthly Transactions I
Difficulty: Medium
Table Names: Transactions

Table: Transactions (id, country, state, amount, trans_date). Write an SQL query to find for each month and country, the number of transactions and their total amount, the number of approved transactions and their total amount.

Solution
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT 
    DATE_FORMAT(trans_date, '%Y-%m') AS month,
    country,
    COUNT(*) AS trans_count,
    SUM(state = 'approved') AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(IF(state = 'approved', amount, 0)) AS approved_total_amount
FROM Transactions
GROUP BY month, country;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Transactions;
CREATE TABLE Transactions (id int, country varchar(4), state VARCHAR(255), amount int, trans_date date);

SET FOREIGN_KEY_CHECKS = 1;
*/
