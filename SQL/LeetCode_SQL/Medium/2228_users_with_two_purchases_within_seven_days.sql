/*
2228. Users With Two Purchases Within Seven Days
Difficulty: Medium
Table Names: Purchases
Description:
    - Database

## Description

Table: Purchases

| purchase_id   | int  |
| user_id       | int  |
| purchase_date | date |
purchase_id contains unique values.
This table contains logs of the dates that users purchased from a certain retailer.

Write a solution to report the IDs of the users that made any two purchases at most 7 days apart.

Return the result table ordered by user_id.

The result format is in the following example.

Example 1:

Input:
Purchases table:
+-------------+---------+---------------+
| purchase_id | user_id | purchase_date |
+-------------+---------+---------------+
| 4           | 2       | 2022-03-13    |
| 1           | 5       | 2022-02-11    |
| 3           | 7       | 2022-06-19    |
| 6           | 2       | 2022-03-20    |
| 5           | 7       | 2022-06-19    |
| 2           | 2       | 2022-06-08    |
+-------------+---------+---------------+
Output:
+---------+
| user_id |
+---------+
| 2       |
| 7       |
+---------+
Explanation:
User 2 had two purchases on 2022-03-13 and 2022-03-20. Since the second purchase is within 7 days of the first purchase, we add their ID.
User 5 had only 1 purchase.
User 7 had two purchases on the same day so we add their ID.
*/

-- Write your MySQL query statement below:













-- Solution:
/*
WITH
    t AS (
        SELECT
            user_id,
            DATEDIFF(
                purchase_date,
                LAG(purchase_date, 1) OVER (
                    PARTITION BY user_id
                    ORDER BY purchase_date
                )
            ) AS d
        FROM Purchases
    )
SELECT DISTINCT user_id
FROM t
WHERE d <= 7
ORDER BY user_id;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Purchases;
DROP TABLE IF EXISTS Purchases;
CREATE TABLE Purchases (
    purchase_id int,
    user_id int,
    purchase_date date
);

INSERT INTO Purchases (purchase_id, user_id, purchase_date) VALUES
    (4, 2, '2022-03-13'),
    (1, 5, '2022-02-11'),
    (3, 7, '2022-06-19'),
    (6, 2, '2022-03-20'),
    (5, 7, '2022-06-19'),
    (2, 2, '2022-06-08');
INSERT INTO Purchases (user_id) VALUES
    (2),
    (7);

SET FOREIGN_KEY_CHECKS = 1;
*/
