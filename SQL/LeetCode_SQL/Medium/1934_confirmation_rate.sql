/*
1934. Confirmation Rate
Difficulty: Medium
Table Names: Signups, Confirmations
Description:
The confirmation rate of a user is the number of 'confirmed' messages divided by the total number of requested confirmation messages. The confirmation rate of a user that did not request any confirmation messages is 0. Round the confirmation rate to two decimal places.
Write an SQL query to find the confirmation rate of each user.
Schema:
Table: Signups
| user_id        | int      |
| time_stamp     | datetime |

Table: Confirmations
| user_id        | int      |
| time_stamp     | datetime |
| action         | ENUM     |
action is ENUM('confirmed', 'timeout')
Example Input/Output:
Output:
+---------+-------------------+
| user_id | confirmation_rate |
+---------+-------------------+
| 3       | 0.50              |
| 7       | 0.00              |
| 2       | 0.00              |
+---------+-------------------+
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT
    s.user_id,
    ROUND(IFNULL(AVG(CASE WHEN c.action = 'confirmed' THEN 1 ELSE 0 END), 0), 2) AS confirmation_rate
FROM
    Signups s
    LEFT JOIN Confirmations c ON s.user_id = c.user_id
GROUP BY
    s.user_id;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Signups;
DROP TABLE IF EXISTS Signups;
CREATE TABLE Signups (
    user_id int,
    time_stamp datetime
);


DROP TABLE IF EXISTS Confirmations;
DROP TABLE IF EXISTS Confirmations;
CREATE TABLE Confirmations (
    user_id int,
    time_stamp datetime,
    action VARCHAR(255)
);

SET FOREIGN_KEY_CHECKS = 1;
*/
