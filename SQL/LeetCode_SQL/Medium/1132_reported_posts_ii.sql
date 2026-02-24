/*
1132. Reported Posts II
Difficulty: Medium
Table Names: Actions, Removals
Table: Actions
| user_id       | int     |
| post_id       | int     |
| action_date   | date    |
| action        | enum    |
| extra         | varchar |
The action column is an ENUM type of ('view', 'like', 'reaction', 'comment', 'report', 'share').
The extra column has optional information about the action, such as a reason for the report or a type of reaction.
Table: Removals
| post_id       | int     |
| remove_date   | date    |
Each row in this table indicates that some post was removed due to being reported or for some other reason.
Write an SQL query to find the average daily percentage of posts that, after being reported as spam, were actually removed. Round the result to 2 decimal places.
Example:
Input:
Actions table:
+---------+---------+-------------+--------+--------+
| user_id | post_id | action_date | action | extra  |
+---------+---------+-------------+--------+--------+
| 1       | 1       | 2019-07-01  | report | spam   |
| 1       | 1       | 2019-07-01  | view   | null   |
| 2       | 2       | 2019-07-04  | report | spam   |
| 3       | 4       | 2019-07-04  | report | spam   |
| 4       | 3       | 2019-07-02  | view   | null   |
+---------+---------+-------------+--------+--------+
Removals table:
+---------+-------------+
| post_id | remove_date |
+---------+-------------+
| 2       | 2019-07-20  |
| 5       | 2019-07-21  |
+---------+-------------+
Output:
+-----------------------+
| average_daily_percent |
+-----------------------+
| 75.00                 |
+-----------------------+
Explanation:
2019-07-01: 1 post reported as spam (id 1). Not removed. 0/1 = 0%.
2019-07-04: 2 posts reported as spam (ids 2, 4). Post 2 removed. 1/2 = 50%.
Wait, the example output says 75.00%.
Let's re-read the example carefully.
"average daily percentage of posts that, after being reported as spam, were actually removed"
2019-07-01: Post 1 reported. Not in removals. Rate = 0%.
2019-07-04: Post 2 reported, REMOVED. Post 4 reported, NOT removed. Rate = 1/2 = 50% ?
Average = (0 + 50) / 2 = 25% ?
UNLESS remove_date doesn't matter, just existence in Removals.
Is "spam" the only extra? Yes, 'extra' column must be 'spam' for report action.
Let's check the provided example data again vs logic.
Actions:
1, 1, 2019-07-01, report, spam
2, 2, 2019-07-04, report, spam
3, 4, 2019-07-04, report, spam
Removals:
2 (removed)
5 (removed) - 5 was never reported in Actions? Irrelevant.
Daily stats:
2019-07-01: 1 spam report (post 1). Removed? No. Perc = 0%.
2019-07-04: 2 spam reports (post 2, 4). Removed? Post 2 is in Removals. Post 4 is not. Perc = 1/2 = 50%.
Avg = (0 + 50)/2 = 25%.
Why is example output 75.00?
Ah, maybe my manual trace is wrong or the example input above is partial.
Let's assume the question asks: For each date, calculate (removed_spam_posts / total_spam_posts) * 100. Then avg those daily percentages.
Is it possible distinct posts per day?
"average daily percentage"
1. Identify spam posts per day. (Distinct post_id per action_date WHERE action='report' AND extra='spam')
2. Check which of these are in Removals.
3. Calc daily %
4. Avg daily %
*/

-- Write your MySQL query statement below:













-- Solution:
/*
WITH DailyStats AS (
    SELECT
        action_date,
        COUNT(DISTINCT a.post_id) AS total_spam,
        COUNT(DISTINCT r.post_id) AS removed_spam
    FROM
        Actions a
        LEFT JOIN Removals r ON a.post_id = r.post_id
    WHERE
        a.action = 'report' 
        AND a.extra = 'spam'
    GROUP BY
        action_date
)
SELECT
    ROUND(AVG(removed_spam / total_spam) * 100, 2) AS average_daily_percent
FROM
    DailyStats;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Actions;
DROP TABLE IF EXISTS Actions;
CREATE TABLE Actions (
    user_id int,
    post_id int,
    action_date date,
    action VARCHAR(255),
    extra VARCHAR(255)
);

INSERT INTO Actions (user_id, post_id, action_date, action, extra) VALUES
    (1, 1, '2019-07-01', 'report', 'spam'),
    (1, 1, '2019-07-01', 'view', NULL),
    (2, 2, '2019-07-04', 'report', 'spam'),
    (3, 4, '2019-07-04', 'report', 'spam'),
    (4, 3, '2019-07-02', 'view', NULL);

DROP TABLE IF EXISTS Removals;
DROP TABLE IF EXISTS Removals;
CREATE TABLE Removals (
    post_id int,
    remove_date date
);

INSERT INTO Removals (post_id, remove_date) VALUES
    (2, '2019-07-20'),
    (5, '2019-07-21');

SET FOREIGN_KEY_CHECKS = 1;
*/
