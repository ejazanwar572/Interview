/*
1907. Count Salary Categories
Difficulty: Medium
Table Names: Accounts
Description:
Write an SQL query to calculate the number of bank accounts for each salary category. The salary categories are:
"Low Salary": All the salaries strictly less than $20000.
"Average Salary": All the salaries in the inclusive range [$20000, $50000].
"High Salary": All the salaries strictly greater than $50000.
The result table must contain all three categories. If there are no accounts in a category, then report 0.
Schema:
Table: Accounts
| account_id  | int  |
| income      | int  |
Example Input/Output:
Output:
+----------------+----------------+
| category       | accounts_count |
+----------------+----------------+
| Low Salary     | 1              |
| Average Salary | 0              |
| High Salary    | 3              |
+----------------+----------------+
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT 'Low Salary' AS category, COUNT(account_id) AS accounts_count FROM Accounts WHERE income < 20000
UNION ALL
SELECT 'Average Salary', COUNT(account_id) FROM Accounts WHERE income BETWEEN 20000 AND 50000
UNION ALL
SELECT 'High Salary', COUNT(account_id) FROM Accounts WHERE income > 50000;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Accounts;
DROP TABLE IF EXISTS Accounts;
CREATE TABLE Accounts (
    account_id int,
    income int
);

SET FOREIGN_KEY_CHECKS = 1;
*/
