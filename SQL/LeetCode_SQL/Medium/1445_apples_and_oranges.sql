/*
1445. Apples & Oranges
Difficulty: Medium
Table Names: Sales
Description:
Write an SQL query to report the difference between the number of apples and oranges sold each day.
Return the result table ordered by sale_date.
Schema:
Table: Sales
| sale_date     | date    |
| fruit         | enum    |
| sold_num      | int     |
Example Input/Output:
Sales table:
+------------+------------+-------------+
| sale_date  | fruit      | sold_num    |
+------------+------------+-------------+
| 2020-05-01 | apples     | 10          |
| 2020-05-01 | oranges    | 8           |
| 2020-05-02 | apples     | 15          |
| 2020-05-02 | oranges    | 15          |
| 2020-05-03 | apples     | 20          |
| 2020-05-03 | oranges    | 0           |
| 2020-05-04 | apples     | 15          |
| 2020-05-04 | oranges    | 16          |
+------------+------------+-------------+
Result table:
+------------+--------------+
| sale_date  | diff         |
+------------+--------------+
| 2020-05-01 | 2            |
| 2020-05-02 | 0            |
| 2020-05-03 | 20           |
| 2020-05-04 | -1           |
+------------+--------------+
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT
    sale_date,
    SUM(
        CASE
            WHEN fruit = 'apples' THEN sold_num
            WHEN fruit = 'oranges' THEN -sold_num
            ELSE 0
        END
    ) AS diff
FROM
    Sales
GROUP BY
    sale_date
ORDER BY
    sale_date;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Sales;
CREATE TABLE Sales (
    sale_date date,
    fruit VARCHAR(255),
    sold_num int
);

INSERT INTO Sales (sale_date, fruit, sold_num) VALUES
    ('2020-05-01', 'apples', 10),
    ('2020-05-01', 'oranges', 8),
    ('2020-05-02', 'apples', 15),
    ('2020-05-02', 'oranges', 15),
    ('2020-05-03', 'apples', 20),
    ('2020-05-03', 'oranges', 0),
    ('2020-05-04', 'apples', 15),
    ('2020-05-04', 'oranges', 16);

SET FOREIGN_KEY_CHECKS = 1;
*/
