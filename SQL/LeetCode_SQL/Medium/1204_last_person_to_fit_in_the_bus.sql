/*
1204. Last Person to Fit in the Bus
Difficulty: Medium
Table Names: Queue

Table: Queue (person_id, person_name, weight, turn). There is a weight limit of 1000kg. Write a query to find the person_name of the last person that can fit on the bus without exceeding the limit.

Solution
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT person_name
FROM (
    SELECT person_name, SUM(weight) OVER (ORDER BY turn) AS cum_weight
    FROM Queue
) t
WHERE cum_weight <= 1000
ORDER BY cum_weight DESC
LIMIT 1;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Queue;
CREATE TABLE Queue (person_id int, person_name varchar(30), weight int, turn int);

SET FOREIGN_KEY_CHECKS = 1;
*/
