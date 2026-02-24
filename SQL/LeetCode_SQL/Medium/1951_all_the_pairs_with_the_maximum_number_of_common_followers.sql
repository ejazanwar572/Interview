/*
1951. All the Pairs With the Maximum Number of Common Followers
Difficulty: Medium
Table Names: Relations
Description:
Write an SQL query to find all the pairs of users that have the maximum number of common followers.
Return the result table in any order.
Schema:
Table: Relations
| user_id     | int  |
| follower_id | int  |
Example Input/Output:
Output:
+----------+----------+
| user1_id | user2_id |
+----------+----------+
| 1        | 7        |
+----------+----------+
*/

-- Write your MySQL query statement below:













-- Solution:
/*
WITH CommonFollowers AS (
    SELECT
        r1.user_id AS user1_id,
        r2.user_id AS user2_id,
        COUNT(r1.follower_id) AS common_count
    FROM
        Relations r1
        JOIN Relations r2 ON r1.follower_id = r2.follower_id AND r1.user_id < r2.user_id
    GROUP BY
        r1.user_id,
        r2.user_id
),
MaxCommon AS (
    SELECT
        MAX(common_count) AS max_count
    FROM
        CommonFollowers
)
SELECT
    cf.user1_id,
    cf.user2_id
FROM
    CommonFollowers cf
    JOIN MaxCommon mc ON cf.common_count = mc.max_count;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Relations;
DROP TABLE IF EXISTS Relations;
CREATE TABLE Relations (
    user_id int,
    follower_id int
);

SET FOREIGN_KEY_CHECKS = 1;
*/
