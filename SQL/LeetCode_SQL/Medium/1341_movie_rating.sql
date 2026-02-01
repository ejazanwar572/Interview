-- 1341. Movie Rating
-- Difficulty: Medium
-- Table: Movies
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | movie_id      | int     |
-- | title         | varchar |
-- +---------------+---------+
-- movie_id is the primary key of this table.
-- Table: Users
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | user_id       | int     |
-- | name          | varchar |
-- +---------------+---------+
-- user_id is the primary key of this table.
-- Table: MovieRating
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | movie_id      | int     |
-- | user_id       | int     |
-- | rating        | int     |
-- | created_at    | date    |
-- +---------------+---------+
-- (movie_id, user_id) is the primary key of this table.
-- Write an SQL query to:
-- 1. Find the name of the user who has rated the greatest number of movies. In case of a tie, return the lexicographically smaller user name.
-- 2. Find the movie name with the highest average rating in February 2020. In case of a tie, return the lexicographically smaller movie name.
-- Example:
-- Input:
-- Movies table:
-- +-------------+--------------+
-- | movie_id    | title        |
-- +-------------+--------------+
-- | 1           | Avengers     |
-- | 2           | Frozen 2     |
-- | 3           | Joker        |
-- +-------------+--------------+
-- Users table:
-- +-------------+--------------+
-- | user_id     | name         |
-- +-------------+--------------+
-- | 1           | Daniel       |
-- | 2           | Monica       |
-- | 3           | Maria        |
-- | 4           | James        |
-- +-------------+--------------+
-- MovieRating table:
-- +-------------+--------------+--------+------------+
-- | movie_id    | user_id      | rating | created_at |
-- +-------------+--------------+--------+------------+
-- | 1           | 1            | 3      | 2020-01-12 |
-- | 1           | 2            | 4      | 2020-02-11 |
-- | 1           | 3            | 2      | 2020-02-12 |
-- | 1           | 4            | 1      | 2020-01-01 |
-- | 2           | 1            | 5      | 2020-02-17 |
-- | 2           | 2            | 2      | 2020-02-01 |
-- | 2           | 3            | 2      | 2020-03-01 |
-- | 3           | 1            | 3      | 2020-02-22 |
-- | 3           | 2            | 4      | 2020-02-25 |
-- +-------------+--------------+--------+------------+
-- Output:
-- +--------------+
-- | results      |
-- +--------------+
-- | Daniel       |
-- | Frozen 2     |
-- +--------------+
(
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
-- Solution:
