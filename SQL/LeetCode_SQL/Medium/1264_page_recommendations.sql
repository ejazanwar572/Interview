/*
1264. Page Recommendations
Difficulty: Medium
Table Names: Friendship, Likes
Table: Friendship
| user1_id      | int     |
| user2_id      | int     |
Each row of this table indicates that there is a friendship relation between user1_id and user2_id.
Table: Likes
| user_id       | int     |
| page_id       | int     |
Each row of this table indicates that user_id likes page_id.
Write an SQL query to recommend pages to the user with user_id = 1 using the pages that your friends liked. It should not recommend pages you already liked.
Return result table in any order without duplicates.
Example:
Input:
Friendship table:
+----------+----------+
| user1_id | user2_id |
+----------+----------+
| 1        | 2        |
| 1        | 3        |
| 1        | 4        |
| 2        | 3        |
| 2        | 4        |
| 2        | 5        |
| 6        | 1        |
+----------+----------+
Likes table:
+---------+---------+
| user_id | page_id |
+---------+---------+
| 1       | 88      |
| 2       | 23      |
| 3       | 24      |
| 4       | 56      |
| 5       | 11      |
| 6       | 33      |
| 2       | 77      |
| 3       | 77      |
| 6       | 88      |
+---------+---------+
Output:
+------------------+
| recommended_page |
+------------------+
| 23               |
| 24               |
| 56               |
| 33               |
| 77               |
+------------------+
Explanation:
User 1 is friends with users 2, 3, 4 and 6.
Friend 2 likes pages 23 and 77.
Friend 3 likes pages 24 and 77.
Friend 4 likes page 56.
Friend 6 likes pages 33 and 88.
Page 88 is also liked by user 1, so it shouldn't be recommended.
Pages 23, 24, 56, 33, 77 are recommended.
*/

-- Write your MySQL query statement below:













-- Solution:
/*
WITH Friends AS (
    SELECT user2_id AS friend_id FROM Friendship WHERE user1_id = 1
    UNION
    SELECT user1_id AS friend_id FROM Friendship WHERE user2_id = 1
)
SELECT DISTINCT
    l.page_id AS recommended_page
FROM
    Likes l
    JOIN Friends f ON l.user_id = f.friend_id
WHERE
    l.page_id NOT IN (SELECT page_id FROM Likes WHERE user_id = 1);

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

INSERT INTO Friendship (user1_id, user2_id) VALUES
    (1, 2),
    (1, 3),
    (1, 4),
    (2, 3),
    (2, 4),
    (2, 5),
    (6, 1);

DROP TABLE IF EXISTS Likes;
DROP TABLE IF EXISTS Likes;
CREATE TABLE Likes (
    user_id int,
    page_id int
);

INSERT INTO Likes (user_id, page_id) VALUES
    (1, 88),
    (2, 23),
    (3, 24),
    (4, 56),
    (5, 11),
    (6, 33),
    (2, 77),
    (3, 77),
    (6, 88);

SET FOREIGN_KEY_CHECKS = 1;
*/
