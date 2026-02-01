-- 1204. Last Person to Fit in the Bus
-- Difficulty: Medium
-- 
-- Table: Queue (person_id, person_name, weight, turn). There is a weight limit of 1000kg. Write a query to find the person_name of the last person that can fit on the bus without exceeding the limit.
-- 
/*
Create table If Not Exists Queue (person_id int, person_name varchar(30), weight int, turn int);
*/
-- Solution
SELECT person_name
FROM (
    SELECT person_name, SUM(weight) OVER (ORDER BY turn) AS cum_weight
    FROM Queue
) t
WHERE cum_weight <= 1000
ORDER BY cum_weight DESC
LIMIT 1;
-- Solution:
