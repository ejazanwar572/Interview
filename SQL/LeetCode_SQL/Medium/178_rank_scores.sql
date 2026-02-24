/*
178. Rank Scores
Difficulty: Medium
Table Names: Scores

Table: Scores
| id          | int     |
| score       | decimal |
Each row of this table contains the score of a game. Score is a floating point value with two decimal places.

Write a solution to find the rank of the scores. The ranking should be calculated according to the following rules:
1. The scores should be ranked from the highest to the lowest.
2. If there is a tie between two scores, both should have the same ranking.
3. After a tie, the next ranking number should be the next consecutive integer value. In other words, there should be no holes between ranks.
Return the result table ordered by score in descending order.
Example 1:
Input:
Scores table:
+----+-------+
| id | score |
+----+-------+
| 1  | 3.50  |
| 2  | 3.65  |
| 3  | 4.00  |
| 4  | 3.85  |
| 5  | 4.00  |
| 6  | 3.65  |
+----+-------+
Output:
+-------+------+
| score | rank |
+-------+------+
| 4.00  | 1    |
| 4.00  | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.65  | 3    |
| 3.50  | 4    |
+-------+------+
Solution
*/

-- Write your MySQL query statement below:

SELECT
    *,
    row_number() OVER (
        ORDER BY score
    ) as row_number_,
    rank() over (
        order by score
    ) as rank_,
    dense_rank() over (
        order by score
    ) as dense_rank_
FROM Scores

-- Solution:

-- SELECT
--     score,
--     DENSE_RANK() OVER (ORDER BY score DESC) AS 'rank'
-- FROM Scores
-- ORDER BY score DESC;

-- Create Table & Insert Data:

USE practice_sql_db;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Scores;

DROP TABLE IF EXISTS Scores;

CREATE TABLE Scores (id int, score float);

INSERT INTO
    Scores (id, score)
VALUES (1, 3.50),
    (2, 3.65),
    (3, 4.00),
    (4, 3.85),
    (5, 4.00),
    (6, 3.65);

SET FOREIGN_KEY_CHECKS = 1;

SELECT * FROM Scores;