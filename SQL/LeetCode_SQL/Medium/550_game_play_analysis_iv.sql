/*
550. Game Play Analysis IV
Difficulty: Medium
Table Names: Activity

Table: Activity
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
This table shows the activity of players of some games.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on someday using some device.

Write a solution to report the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places. In other words, you need to count the number of players that logged in for at least two consecutive days starting from their first login date, then divide that number by the total number of players.
Example 1:
Input:
Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-03-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+
Output:
+-----------+
| fraction  |
+-----------+
| 0.33      |
+-----------+
Explanation:
Only the player with id 1 logged in on the first day 2016-03-01 and also logged in on the second day 2016-03-02.
The number of players that logged in for at least two consecutive days starting from their first login date is 1, and the total number of players is 3.
So the answer is 1 / 3 = 0.33
Solution
*/

-- Write your MySQL query statement below:













-- Solution:
/*
WITH FirstLogin AS (
    SELECT player_id, MIN(event_date) AS first_login_date
    FROM Activity
    GROUP BY player_id
)
SELECT 
    ROUND(
        COUNT(a.player_id) / (SELECT COUNT(DISTINCT player_id) FROM Activity), 
        2
    ) AS fraction
FROM FirstLogin f
JOIN Activity a ON f.player_id = a.player_id 
    AND a.event_date = DATE_ADD(f.first_login_date, INTERVAL 1 DAY);

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Activity;
DROP TABLE IF EXISTS Activity;
CREATE TABLE Activity (
    player_id int,
    device_id int,
    event_date date,
    games_played int
);

INSERT INTO Activity (player_id, device_id, event_date, games_played) VALUES
    (1, 2, '2016-03-01', 5),
    (1, 2, '2016-03-02', 6),
    (2, 3, '2017-06-25', 1),
    (3, 1, '2016-03-02', 0),
    (3, 4, '2018-07-03', 5);

SET FOREIGN_KEY_CHECKS = 1;
*/
