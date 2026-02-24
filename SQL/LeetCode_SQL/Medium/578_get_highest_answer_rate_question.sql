/*
578. Get Highest Answer Rate Question
Difficulty: Medium
Table Names: SurveyLog

Table: SurveyLog
| id          | int  |
| action      | enum |
| question_id | int  |
| answer_id   | int  |
| q_num       | int  |
| timestamp   | int  |
This table may contain duplicate rows.
action is an ENUM (category) of the type: "show", "answer", "skip".
Each row of this table indicates the user with ID = id has taken an action with the question question_id at time timestamp.
If the action taken by the user is "answer", answer_id will contain the id of that answer, otherwise, it will be null.
q_num is the numeral order of the question in the current session.

The answer rate for a question is the number of times it is answered divided by the number of times it is shown.
Write a solution to report the question that has the highest answer rate. If multiple questions have the same maximum answer rate, report the one with the smallest question_id.
Example 1:
Input:
SurveyLog table:
+----+--------+-------------+-----------+-------+-----------+
| id | action | question_id | answer_id | q_num | timestamp |
+----+--------+-------------+-----------+-------+-----------+
| 5  | show   | 285         | null      | 1     | 123       |
| 5  | answer | 285         | 124124    | 1     | 124       |
| 5  | show   | 369         | null      | 2     | 125       |
| 5  | skip   | 369         | null      | 2     | 126       |
+----+--------+-------------+-----------+-------+-----------+
Output:
+-----------+
| survey_log|
+-----------+
| 285       |
+-----------+
Explanation:
Question 285 was shown 1 time and answered 1 time. The answer rate is 1.0.
Question 369 was shown 1 time and was not answered. The answer rate is 0.0.
Question 285 has the highest answer rate.
Solution
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT question_id AS survey_log
FROM SurveyLog
GROUP BY question_id
ORDER BY SUM(CASE WHEN action = 'answer' THEN 1 ELSE 0 END) / SUM(CASE WHEN action = 'show' THEN 1 ELSE 0 END) DESC, question_id ASC
LIMIT 1;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS SurveyLog;
DROP TABLE IF EXISTS SurveyLog;
CREATE TABLE SurveyLog (
    id int,
    action VARCHAR(255),
    question_id int,
    answer_id int,
    q_num int,
    timestamp int
);

INSERT INTO SurveyLog (id, action, question_id, answer_id, q_num, timestamp) VALUES
    (5, 'show', 285, NULL, 1, 123),
    (5, 'answer', 285, 124124, 1, 124),
    (5, 'show', 369, NULL, 2, 125),
    (5, 'skip', 369, NULL, 2, 126);

SET FOREIGN_KEY_CHECKS = 1;
*/
