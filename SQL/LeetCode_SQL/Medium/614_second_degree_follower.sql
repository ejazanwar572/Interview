/*
614. Second Degree Follower
Difficulty: Medium
Table Names: Follow
Table: Follow
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| followee    | varchar |
| follower    | varchar |
+-------------+---------+
(followee, follower) is the primary key.
A second-degree follower is a user who:
- follows at least one user, and
- is followed by at least one user.
Report the second-degree users and the number of their followers.
Return the result table ordered by follower in alphabetical order.
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT
    f1.follower,
    COUNT(DISTINCT f2.follower) AS num
FROM
    Follow f1
    JOIN Follow f2 ON f1.follower = f2.followee
GROUP BY
    f1.follower
ORDER BY
    f1.follower;
-- Logic Check:
-- f1: table of (someone, USER) -> USER is a follower of someone.
-- f2: table of (USER, someone_else) -> USER is a followee of someone_else.
-- Wait, the question defines "Second Degree Follower" as someone who follows someone AND is followed by someone.
-- My query joins `f1.follower = f2.followee`.
-- f1.follower is the 'central' person.
-- f1 says "Central follows someone". (True, because they appear in follower col).
-- f2 says "Central is followed by someone_else" (True, because they appear in followee col).
-- Then we count `f2.follower` (the people following Central).
-- This matches the requirement "number of their followers".

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Follow;
DROP TABLE IF EXISTS Follow;
CREATE TABLE Follow (
    followee VARCHAR(255),
    follower VARCHAR(255)
);

SET FOREIGN_KEY_CHECKS = 1;
*/
