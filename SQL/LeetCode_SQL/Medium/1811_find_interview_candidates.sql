/*
1811. Find Interview Candidates
Difficulty: Medium
Table Names: Contests, Users
Description:
Find all interview candidates. A candidate is someone who:
1. Won any medal in three or more consecutive contests.
2. Won three or more gold medals in total.
Schema:
Table: Contests
| contest_id    | int     |
| gold_medal    | int     |
| silver_medal  | int     |
| bronze_medal  | int     |

Table: Users
| user_id       | int     |
| mail          | varchar |
| name          | varchar |
Example Input/Output:
Output:
+-------+--------------------+
| name  | mail               |
+-------+--------------------+
| Sarah | sarah@leetcode.com |
+-------+--------------------+
*/

-- Write your MySQL query statement below:













-- Solution:
/*
WITH Medals AS (
    SELECT contest_id, gold_medal AS user_id FROM Contests
    UNION ALL
    SELECT contest_id, silver_medal AS user_id FROM Contests
    UNION ALL
    SELECT contest_id, bronze_medal AS user_id FROM Contests
),
ConsecutiveMedals AS (
    SELECT
        user_id,
        contest_id,
        LAG(contest_id, 1) OVER (PARTITION BY user_id ORDER BY contest_id) AS prev1,
        LAG(contest_id, 2) OVER (PARTITION BY user_id ORDER BY contest_id) AS prev2
    FROM
        Medals
),
Candidates AS (
    -- Condition 1: Three or more consecutive contests
    SELECT DISTINCT user_id
    FROM ConsecutiveMedals
    WHERE contest_id = prev1 + 1 AND prev1 = prev2 + 1
    
    UNION
    
    -- Condition 2: Won three or more gold medals
    SELECT gold_medal AS user_id
    FROM Contests
    GROUP BY gold_medal
    HAVING COUNT(*) >= 3
)
SELECT
    u.name,
    u.mail
FROM
    Candidates c
    JOIN Users u ON c.user_id = u.user_id;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Contests;
DROP TABLE IF EXISTS Contests;
CREATE TABLE Contests (
    contest_id int,
    gold_medal int,
    silver_medal int,
    bronze_medal int
);


DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Users;
CREATE TABLE Users (
    user_id int,
    mail VARCHAR(255),
    name VARCHAR(255)
);

INSERT INTO Users (name, mail) VALUES
    ('Sarah', 'sarah@leetcode.com');

SET FOREIGN_KEY_CHECKS = 1;
*/
