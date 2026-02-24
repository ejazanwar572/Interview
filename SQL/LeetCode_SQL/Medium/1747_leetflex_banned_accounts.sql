/*
1747. Leetflex Banned Accounts
Difficulty: Medium
Table Names: Logins
Description:
Write an SQL query to find the account_id(s) that should be banned from Leetflex.
An account should be banned if it was logged in from two different IP addresses at the same time (i.e., the login time intervals overlap).
Schema:
Table: Logins
| account_id    | int     |
| ip_address    | int     |
| login         | datetime|
| logout        | datetime|
No primary key.
Example Input/Output:
Output:
+------------+
| account_id |
+------------+
| 1          |
+------------+
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT DISTINCT
    l1.account_id
FROM
    Logins l1
    JOIN Logins l2 ON l1.account_id = l2.account_id
WHERE
    l1.ip_address != l2.ip_address
    AND (
        (l1.login BETWEEN l2.login AND l2.logout)
        OR (l1.logout BETWEEN l2.login AND l2.logout)
    );

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Logins;
DROP TABLE IF EXISTS Logins;
CREATE TABLE Logins (
    account_id int,
    ip_address int,
    login datetime,
    logout datetime
);

INSERT INTO Logins (account_id) VALUES
    (1);

SET FOREIGN_KEY_CHECKS = 1;
*/
