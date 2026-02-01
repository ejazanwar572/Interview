-- 601. Human Traffic of Stadium
-- Difficulty: Hard
-- 
-- Table: Stadium
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | visit_date    | date    |
-- | people        | int     |
-- +---------------+---------+
-- visit_date is the column with unique values for this table.
-- Each row of this table contains the visit date and visit id to the stadium with the number of people during the visit.
-- As the id increases, the date increases as well.
-- 
-- Write a solution to display the records with three or more rows with consecutive id's, and the number of people is greater than or equal to 100 for each.
-- Return the result table ordered by visit_date in ascending order.
-- 
/*
Create table If Not Exists Stadium (id int, visit_date DATE, people int)\nTruncate table Stadium\ninsert into Stadium (id, visit_date, people) values ('1', '2017-01-01', '10')\ninsert into Stadium (id, visit_date, people) values ('2', '2017-01-02', '109')\ninsert into Stadium (id, visit_date, people) values ('3', '2017-01-03', '150')\ninsert into Stadium (id, visit_date, people) values ('4', '2017-01-04', '99')\ninsert into Stadium (id, visit_date, people) values ('5', '2017-01-05', '145')\ninsert into Stadium (id, visit_date, people) values ('6', '2017-01-06', '1455')\ninsert into Stadium (id, visit_date, people) values ('7', '2017-01-07', '199')\ninsert into Stadium (id, visit_date, people) values ('8', '2017-01-09', '188')
*/
-- Solution
WITH Q AS (
    SELECT *, 
           id - ROW_NUMBER() OVER (ORDER BY id) AS id_diff
    FROM Stadium
    WHERE people >= 100
)
SELECT id, visit_date, people
FROM Q
WHERE id_diff IN (
    SELECT id_diff 
    FROM Q
    GROUP BY id_diff
    HAVING COUNT(*) >= 3
)
ORDER BY visit_date;
-- Solution:
