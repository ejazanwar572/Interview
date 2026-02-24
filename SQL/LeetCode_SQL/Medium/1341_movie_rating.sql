/*
1341. Movie Rating
Difficulty: Medium
Table Names: Movies, Users, MovieRating
Table: Movies
| movie_id      | int     |
| title         | varchar |
Table: Users
| user_id       | int     |
| name          | varchar |
Table: MovieRating
| movie_id      | int     |
| user_id       | int     |
| rating        | int     |
| created_at    | date    |
Write an SQL query to:
1. Find the name of the user who has rated the greatest number of movies. In case of a tie, return the lexicographically smaller user name.
2. Find the movie name with the highest average rating in February 2020. In case of a tie, return the lexicographically smaller movie name.
Example:
Input:
Movies table:
+-------------+--------------+
| movie_id    | title        |
+-------------+--------------+
| 1           | Avengers     |
| 2           | Frozen 2     |
| 3           | Joker        |
+-------------+--------------+
Users table:
+-------------+--------------+
| user_id     | name         |
+-------------+--------------+
| 1           | Daniel       |
| 2           | Monica       |
| 3           | Maria        |
| 4           | James        |
+-------------+--------------+
MovieRating table:
+-------------+--------------+--------+------------+
| movie_id    | user_id      | rating | created_at |
+-------------+--------------+--------+------------+
| 1           | 1            | 3      | 2020-01-12 |
| 1           | 2            | 4      | 2020-02-11 |
| 1           | 3            | 2      | 2020-02-12 |
| 1           | 4            | 1      | 2020-01-01 |
| 2           | 1            | 5      | 2020-02-17 |
| 2           | 2            | 2      | 2020-02-01 |
| 2           | 3            | 2      | 2020-03-01 |
| 3           | 1            | 3      | 2020-02-22 |
| 3           | 2            | 4      | 2020-02-25 |
+-------------+--------------+--------+------------+
Output:
+--------------+
| results      |
+--------------+
| Daniel       |
| Frozen 2     |
+--------------+
(
*/

-- Write your MySQL query statement below:













-- Solution:
/*
    SELECT
        u.name AS results
    FROM
        MovieRating m
        JOIN Users u ON m.user_id = u.user_id
    GROUP BY
        u.user_id, u.name
    ORDER BY
        COUNT(m.movie_id) DESC,
        u.name ASC
    LIMIT 1
)
UNION ALL
(
    SELECT
        mv.title AS results
    FROM
        MovieRating m
        JOIN Movies mv ON m.movie_id = mv.movie_id
    WHERE
        m.created_at BETWEEN '2020-02-01' AND '2020-02-29'
    GROUP BY
        mv.movie_id, mv.title
    ORDER BY
        AVG(m.rating) DESC,
        mv.title ASC
    LIMIT 1
);

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Movies;
DROP TABLE IF EXISTS Movies;
CREATE TABLE Movies (
    movie_id int,
    title VARCHAR(255)
);

INSERT INTO Movies (movie_id, title) VALUES
    (1, 'Avengers'),
    (2, 'Frozen 2'),
    (3, 'Joker');

DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Users;
CREATE TABLE Users (
    user_id int,
    name VARCHAR(255)
);

INSERT INTO Users (user_id, name) VALUES
    (1, 'Daniel'),
    (2, 'Monica'),
    (3, 'Maria'),
    (4, 'James');

DROP TABLE IF EXISTS MovieRating;
DROP TABLE IF EXISTS MovieRating;
CREATE TABLE MovieRating (
    movie_id int,
    user_id int,
    rating int,
    created_at date
);

INSERT INTO MovieRating (movie_id, user_id, rating, created_at) VALUES
    (1, 1, 3, '2020-01-12'),
    (1, 2, 4, '2020-02-11'),
    (1, 3, 2, '2020-02-12'),
    (1, 4, 1, '2020-01-01'),
    (2, 1, 5, '2020-02-17'),
    (2, 2, 2, '2020-02-01'),
    (2, 3, 2, '2020-03-01'),
    (3, 1, 3, '2020-02-22'),
    (3, 2, 4, '2020-02-25');

SET FOREIGN_KEY_CHECKS = 1;
*/
