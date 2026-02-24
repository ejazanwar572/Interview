/*
2388. Change Null Values in a Table to the Previous Value
Difficulty: Medium
Table Names: CoffeeShop
Description:
    - Database

## Description

Table: CoffeeShop

| id          | int     |
| drink       | varchar |
Each row in this table shows the order id and the name of the drink ordered. Some drink rows are nulls.

Write a solution to replace the null values of the drink with the name of the drink of the previous row that is not null. It is guaranteed that the drink on the first row of the table is not null.

Return the result table in the same order as the input.

The result format is shown in the following example.

Example 1:

Input:
CoffeeShop table:
+----+-------------------+
| id | drink             |
+----+-------------------+
| 9  | Rum and Coke      |
| 6  | null              |
| 7  | null              |
| 3  | St Germain Spritz |
| 1  | Orange Margarita  |
| 2  | null              |
+----+-------------------+
Output:
+----+-------------------+
| id | drink             |
+----+-------------------+
| 9  | Rum and Coke      |
| 6  | Rum and Coke      |
| 7  | Rum and Coke      |
| 3  | St Germain Spritz |
| 1  | Orange Margarita  |
| 2  | Orange Margarita  |
+----+-------------------+
Explanation:
For ID 6, the previous value that is not null is from ID 9. We replace the null with &quot;Rum and Coke&quot;.
For ID 7, the previous value that is not null is from ID 9. We replace the null with &quot;Rum and Coke;.
For ID 2, the previous value that is not null is from ID 1. We replace the null with &quot;Orange Margarita&quot;.
Note that the rows in the output are the same as in the input.
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT
    id,
    CASE
        WHEN drink IS NOT NULL THEN @cur := drink
        ELSE @cur
    END AS drink
FROM CoffeeShop;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS CoffeeShop;
DROP TABLE IF EXISTS CoffeeShop;
CREATE TABLE CoffeeShop (
    id int,
    drink VARCHAR(255)
);

INSERT INTO CoffeeShop (id, drink) VALUES
    (9, 'Rum and Coke'),
    (6, NULL),
    (7, NULL),
    (3, 'St Germain Spritz'),
    (1, 'Orange Margarita'),
    (2, NULL),
    (9, 'Rum and Coke'),
    (6, 'Rum and Coke'),
    (7, 'Rum and Coke'),
    (3, 'St Germain Spritz'),
    (1, 'Orange Margarita'),
    (2, 'Orange Margarita');

SET FOREIGN_KEY_CHECKS = 1;
*/
