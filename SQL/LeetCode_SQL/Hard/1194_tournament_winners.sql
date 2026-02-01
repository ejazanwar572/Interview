-- 1194. Tournament Winners
-- Difficulty: Hard
-- Table: Players
-- +-------------+-------+
-- | Column Name | Type  |
-- +-------------+-------+
-- | player_id   | int   |
-- | group_id    | int   |
-- +-------------+-------+
-- player_id is the primary key of this table.
-- Each row of this table indicates the group of each player.
-- Table: Matches
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | match_id      | int     |
-- | first_player  | int     |
-- | second_player | int     |
-- | first_score   | int     |
-- | second_score  | int     |
-- +---------------+---------+
-- match_id is the primary key of this table.
-- Each row is a record of a match, first_player and second_player contain the player_id of each match.
-- first_score and second_score contain the number of points of the first_player and second_player respectively.
-- The winner of the match is the player with the higher score. A player may play multiple matches against each other or different players.
-- The winner in each group is the player who scored the maximum total points within the group. In the case of a tie, the lowest player_id wins.
-- Write an SQL query to find the winner in each group.
-- Example:
-- Input:
-- Players table:
-- +-----------+----------+
-- | player_id | group_id |
-- +-----------+----------+
-- | 15        | 1        |
-- | 25        | 1        |
-- | 30        | 1        |
-- | 45        | 1        |
-- | 10        | 2        |
-- | 35        | 2        |
-- | 50        | 2        |
-- | 20        | 3        |
-- | 40        | 3        |
-- +-----------+----------+
-- Matches table:
-- +----------+--------------+---------------+-------------+--------------+
-- | match_id | first_player | second_player | first_score | second_score |
-- +----------+--------------+---------------+-------------+--------------+
-- | 1        | 15           | 45            | 3           | 0            |
-- | 2        | 30           | 25            | 1           | 2            |
-- | 3        | 30           | 15            | 2           | 0            |
-- | 4        | 40           | 20            | 5           | 2            |
-- | 5        | 35           | 50            | 1           | 1            |
-- +----------+--------------+---------------+-------------+--------------+
-- Output:
-- +----------+-----------+
-- | group_id | player_id |
-- +----------+-----------+
-- | 1        | 15        |
-- | 2        | 35        |
-- | 3        | 40        |
-- +----------+-----------+
-- Explanation:
-- Group 1:
-- Player 15: 3 points (match 1) + 0 points (match 3) = 3 total. (Wait, match 3: second_player 15 score 0)
-- Player 25: 2 points (match 2).
-- Player 30: 1 point (match 2) + 2 points (match 3) = 3 total.
-- Player 45: 0 points (match 1).
-- Tie between 15 and 30 for max score 3. Lowest ID is 15. Winner 15.
WITH AllScores AS (
    SELECT first_player AS player_id, first_score AS score FROM Matches
    UNION ALL
    SELECT second_player AS player_id, second_score AS score FROM Matches
),
PlayerTotalScores AS (
    SELECT
        p.group_id,
        p.player_id,
        IFNULL(SUM(s.score), 0) AS total_score
    FROM
        Players p
        LEFT JOIN AllScores s ON p.player_id = s.player_id
    GROUP BY
        p.group_id,
        p.player_id
),
RankedPlayers AS (
    SELECT
        group_id,
        player_id,
        ROW_NUMBER() OVER (
            PARTITION BY group_id 
            ORDER BY total_score DESC, player_id ASC
        ) AS rn
    FROM
        PlayerTotalScores
)
SELECT
    group_id,
    player_id
FROM
    RankedPlayers
WHERE
    rn = 1;
-- Solution:
