/*
180. Consecutive Numbers
Difficulty: Medium
Table Names: Logs

Table: Logs
| id          | int     |
| num         | varchar |
id is an autoincrement column.

Find all numbers that appear at least three times consecutively.
Return the result table in any order.
Example 1:
Input:
Logs table:
+----+-----+
| id | num |
+----+-----+
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |
+----+-----+
Output:
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
Explanation: 1 is the only number that appears consecutively for at least three times.
Solution
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT DISTINCT l1.num AS ConsecutiveNums
FROM Logs l1
JOIN Logs l2 ON l1.id = l2.id - 1
JOIN Logs l3 ON l2.id = l3.id - 1
WHERE l1.num = l2.num
  AND l2.num = l3.num;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Logs;
DROP TABLE IF EXISTS Logs;
CREATE TABLE Logs (
    id int,
    num VARCHAR(255)
);

INSERT INTO Logs (id, num) VALUES
    (1, '1'),
    (2, '1'),
    (3, '1'),
    (4, '2'),
    (5, '1'),
    (6, '2'),
    (7, '2');

SET FOREIGN_KEY_CHECKS = 1;
*/
