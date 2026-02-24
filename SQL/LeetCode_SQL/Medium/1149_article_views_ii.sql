/*
1149. Article Views II
Difficulty: Medium
Table Names: Views
Table: Views
| article_id    | int     |
| author_id     | int     |
| viewer_id     | int     |
| view_date     | date    |
Each row of this table indicates that some viewer viewed an article (written by some author) on some date.
Note: equal author_id and viewer_id indicate the same person.
Write an SQL query to find all the users that viewed more than one article on the same date, sorted in ascending order by their id.
Example:
Input:
Views table:
+------------+-----------+-----------+------------+
| article_id | author_id | viewer_id | view_date  |
+------------+-----------+-----------+------------+
| 1          | 3         | 5         | 2019-08-01 |
| 3          | 4         | 5         | 2019-08-01 |
| 1          | 3         | 6         | 2019-08-02 |
| 2          | 7         | 7         | 2019-08-01 |
| 2          | 7         | 7         | 2019-08-08 |
+------------+-----------+-----------+------------+
Output:
+------+
| id   |
+------+
| 5    |
| 6    |
+------+
Wait, the example output I saw earlier only had 5. Let's re-read carefully.
User 5: viewed article 1 on 08-01, article 3 on 08-01. Count = 2. Meets criteria.
User 6: viewed article 1 on 08-02. Only 1 article.
User 7: viewed article 2 on 08-01, article 2 on 08-08. Different dates. On 08-01 count=1, on 08-08 count=1.
So only 5 should be in output.
Wait, if duplicate rows exist (same article, same day), does it count as "more than one article"?
"viewed more than one article" implies DISTINCT articles.
If I view article 1 twice on the same day, that's not viewing more than one article.
So COUNT(DISTINCT article_id) > 1.
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT DISTINCT
    viewer_id AS id
FROM
    Views
GROUP BY
    viewer_id,
    view_date
HAVING
    COUNT(DISTINCT article_id) > 1
ORDER BY
    id;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Views;
DROP TABLE IF EXISTS Views;
CREATE TABLE Views (
    article_id int,
    author_id int,
    viewer_id int,
    view_date date
);

INSERT INTO Views (article_id, author_id, viewer_id, view_date) VALUES
    (1, 3, 5, '2019-08-01'),
    (3, 4, 5, '2019-08-01'),
    (1, 3, 6, '2019-08-02'),
    (2, 7, 7, '2019-08-01'),
    (2, 7, 7, '2019-08-08');

SET FOREIGN_KEY_CHECKS = 1;
*/
