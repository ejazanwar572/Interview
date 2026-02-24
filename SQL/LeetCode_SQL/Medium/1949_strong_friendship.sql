/*
1949. Strong Friendship
Difficulty: Medium
Table Names: Friendship
Description:
A friendship between a pair of friends x and y is strong if x and y have at least three common friends.
Write an SQL query to find all the strong friendships.
Note that the result table should not contain duplicates with user1_id < user2_id.
Schema:
Table: Friendship
| user1_id      | int     |
| user2_id      | int     |
Example Input/Output:
Output:
+----------+----------+----------------+
| user1_id | user2_id | common_friends |
+----------+----------+----------------+
| 1        | 2        | 3              |
+----------+----------+----------------+
*/

-- Write your MySQL query statement below:













-- Solution:
/*
WITH AllFriends AS (
    SELECT user1_id AS user_id, user2_id AS friend_id FROM Friendship
    UNION ALL
    SELECT user2_id AS user_id, user1_id AS friend_id FROM Friendship
)
SELECT
    f.user1_id,
    f.user2_id,
    COUNT(af1.friend_id) AS common_friends
FROM
    Friendship f
    JOIN AllFriends af1 ON f.user1_id = af1.user_id
    JOIN AllFriends af2 ON f.user2_id = af2.user_id AND af1.friend_id = af2.friend_id
GROUP BY
    f.user1_id,
    f.user2_id
HAVING
    COUNT(af1.friend_id) >= 3;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Friendship;
DROP TABLE IF EXISTS Friendship;
CREATE TABLE Friendship (
    user1_id int,
    user2_id int
);

SET FOREIGN_KEY_CHECKS = 1;
*/
