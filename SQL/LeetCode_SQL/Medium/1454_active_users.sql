/*
1454. Active Users
Difficulty: Medium
Table Names: Accounts, Logins
Description:
Write an SQL query to find the id and the name of active users.
Active users are those who logged in to their accounts for five or more consecutive days.
Return the result table ordered by the id.
Schema:
Table: Accounts
| id            | int     |
| name          | varchar |

Table: Logins
| id            | int     |
| login_date    | date    |
No primary key. May contain duplicates.
Example Input/Output:
Accounts table:
+----+----------+
| id | name     |
+----+----------+
| 1  | Winston  |
| 7  | Jonathan |
+----+----------+
Logins table:
+----+------------+
| id | login_date |
+----+------------+
| 7  | 2020-05-30 |
| 1  | 2020-05-30 |
| 7  | 2020-05-31 |
| 7  | 2020-06-01 |
| 7  | 2020-06-02 |
| 7  | 2020-06-02 |
| 7  | 2020-06-03 |
| 1  | 2020-06-07 |
| 7  | 2020-06-10 |
+----+------------+
Result table:
+----+----------+
| id | name     |
+----+----------+
| 7  | Jonathan |
+----+----------+
*/

-- Write your MySQL query statement below:













-- Solution:
/*
WITH DistinctLogins AS (
    SELECT DISTINCT
        id,
        login_date
    FROM
        Logins
),
GroupedLogins AS (
    SELECT
        id,
        login_date,
        DATE_SUB(login_date, INTERVAL ROW_NUMBER() OVER (PARTITION BY id ORDER BY login_date) DAY) AS grp
    FROM
        DistinctLogins
)
SELECT DISTINCT
    g.id,
    a.name
FROM
    GroupedLogins g
    JOIN Accounts a ON g.id = a.id
GROUP BY
    g.id,
    g.grp
HAVING
    COUNT(*) >= 5
ORDER BY
    g.id;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Accounts;
DROP TABLE IF EXISTS Accounts;
CREATE TABLE Accounts (
    id int,
    name VARCHAR(255)
);

INSERT INTO Accounts (id, name) VALUES
    (1, 'Winston'),
    (7, 'Jonathan'),
    (7, 'Jonathan');

DROP TABLE IF EXISTS Logins;
DROP TABLE IF EXISTS Logins;
CREATE TABLE Logins (
    id int,
    login_date date
);

INSERT INTO Logins (id, login_date) VALUES
    (7, '2020-05-30'),
    (1, '2020-05-30'),
    (7, '2020-05-31'),
    (7, '2020-06-01'),
    (7, '2020-06-02'),
    (7, '2020-06-02'),
    (7, '2020-06-03'),
    (1, '2020-06-07'),
    (7, '2020-06-10');

SET FOREIGN_KEY_CHECKS = 1;
*/
