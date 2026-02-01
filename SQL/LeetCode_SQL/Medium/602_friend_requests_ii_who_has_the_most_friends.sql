-- 602. Friend Requests II: Who Has the Most Friends
-- Difficulty: Medium
-- 
-- Table: RequestAccepted
-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | requester_id   | int     |
-- | accepter_id    | int     |
-- | accept_date    | date    |
-- +----------------+---------+
-- (requester_id, accepter_id) is the primary key (combination of columns with unique values) for this table.
-- This table contains the ID of the user who sent the request, the ID of the user who received the request, and the date when the request was accepted.
-- 
-- Write a solution to find the people who have the most friends and the most friends number.
-- The test cases are generated so that only one person has the most friends.
-- 
/*
Create table If Not Exists RequestAccepted (requester_id int, accepter_id int, accept_date date)\nTruncate table RequestAccepted\ninsert into RequestAccepted (requester_id, accepter_id, accept_date) values ('1', '2', '2016/06/03')\ninsert into RequestAccepted (requester_id, accepter_id, accept_date) values ('1', '3', '2016/06/08')\ninsert into RequestAccepted (requester_id, accepter_id, accept_date) values ('2', '3', '2016/06/08')\ninsert into RequestAccepted (requester_id, accepter_id, accept_date) values ('3', '4', '2016/06/09')
*/
-- Solution
SELECT id, COUNT(*) AS num
FROM (
    SELECT requester_id AS id FROM RequestAccepted
    UNION ALL
    SELECT accepter_id AS id FROM RequestAccepted
) t
GROUP BY id
ORDER BY num DESC
LIMIT 1;
-- Solution:
