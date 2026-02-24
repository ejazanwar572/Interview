/*
1440. Evaluate Boolean Expression
Difficulty: Medium
Table Names: Variables, Expressions
Description:
Write an SQL query to evaluate the boolean expressions in the Expressions table.
Return the result table in any order.
Schema:
Table: Variables
| name          | varchar |
| value         | int     |

Table: Expressions
| left_operand  | varchar |
| operator      | enum    |
| right_operand | varchar |
operator is an enum ('<', '>', '=').
Example Input/Output:
Variables table:
+------+-------+
| name | value |
+------+-------+
| x    | 66    |
| y    | 77    |
+------+-------+
Expressions table:
+--------------+----------+---------------+
| left_operand | operator | right_operand |
+--------------+----------+---------------+
| x            | >        | y             |
| x            | <        | y             |
| x            | =        | y             |
| y            | >        | x             |
| y            | <        | x             |
| x            | =        | x             |
+--------------+----------+---------------+
Result table:
+--------------+----------+---------------+-------+
| left_operand | operator | right_operand | value |
+--------------+----------+---------------+-------+
| x            | >        | y             | false |
| x            | <        | y             | true  |
| x            | =        | y             | false |
| y            | >        | x             | true  |
| y            | <        | x             | false |
| x            | =        | x             | true  |
+--------------+----------+---------------+-------+
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT
    e.left_operand,
    e.operator,
    e.right_operand,
    CASE
        WHEN e.operator = '>' AND v1.value > v2.value THEN 'true'
        WHEN e.operator = '<' AND v1.value < v2.value THEN 'true'
        WHEN e.operator = '=' AND v1.value = v2.value THEN 'true'
        ELSE 'false'
    END AS value
FROM
    Expressions e
    JOIN Variables v1 ON e.left_operand = v1.name
    JOIN Variables v2 ON e.right_operand = v2.name;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Variables;
DROP TABLE IF EXISTS Variables;
CREATE TABLE Variables (
    name VARCHAR(255),
    value int
);

INSERT INTO Variables (name, value) VALUES
    ('x', 66),
    ('y', 77);

DROP TABLE IF EXISTS Expressions;
DROP TABLE IF EXISTS Expressions;
CREATE TABLE Expressions (
    left_operand VARCHAR(255),
    operator VARCHAR(255),
    right_operand VARCHAR(255)
);

INSERT INTO Expressions (left_operand, operator, right_operand) VALUES
    ('x', '>', 'y'),
    ('x', '<', 'y'),
    ('x', '=', 'y'),
    ('y', '>', 'x'),
    ('y', '<', 'x'),
    ('x', '=', 'x');

SET FOREIGN_KEY_CHECKS = 1;
*/
