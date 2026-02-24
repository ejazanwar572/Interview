/*
1393. Capital Gain/Loss
Difficulty: Medium
Table Names: Stocks
Description:
Write an SQL query to report the Capital gain/loss for each stock. The capital gain/loss of a stock is the total gain or loss after buying and selling the stock one or many times.
Return the result table in any order.
Schema:
Table: Stocks
| stock_name    | varchar |
| operation     | enum    |
| operation_day | int     |
| price         | int     |
The operation column is an ENUM of type ('Sell', 'Buy').
It is guaranteed that each 'Sell' operation for a stock has a corresponding 'Buy' operation on a previous day.
Example Input/Output:
Stocks table:
+---------------+-----------+---------------+--------+
| stock_name    | operation | operation_day | price  |
+---------------+-----------+---------------+--------+
| Leetcode      | Buy       | 1             | 1000   |
| Corona Masks  | Buy       | 2             | 10     |
| Leetcode      | Sell      | 5             | 9000   |
| Handbags      | Buy       | 17            | 30000  |
| Corona Masks  | Sell      | 3             | 1010   |
| Corona Masks  | Buy       | 4             | 1000   |
| Corona Masks  | Sell      | 5             | 500    |
| Corona Masks  | Buy       | 6             | 1000   |
| Handbags      | Sell      | 29            | 7000   |
| Corona Masks  | Sell      | 10            | 10000  |
+---------------+-----------+---------------+--------+
Result table:
+---------------+-------------------+
| stock_name    | capital_gain_loss |
+---------------+-------------------+
| Corona Masks  | 9500              |
| Leetcode      | 8000              |
| Handbags      | -23000            |
+---------------+-------------------+
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT
    stock_name,
    SUM(
        CASE
            WHEN operation = 'Buy' THEN -price
            ELSE price
        END
    ) AS capital_gain_loss
FROM
    Stocks
GROUP BY
    stock_name;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Stocks;
DROP TABLE IF EXISTS Stocks;
CREATE TABLE Stocks (
    stock_name VARCHAR(255),
    operation VARCHAR(255),
    operation_day int,
    price int
);

INSERT INTO Stocks (stock_name, operation, operation_day, price) VALUES
    ('Leetcode', 'Buy', 1, 1000),
    ('Corona Masks', 'Buy', 2, 10),
    ('Leetcode', 'Sell', 5, 9000),
    ('Handbags', 'Buy', 17, 30000),
    ('Corona Masks', 'Sell', 3, 1010),
    ('Corona Masks', 'Buy', 4, 1000),
    ('Corona Masks', 'Sell', 5, 500),
    ('Corona Masks', 'Buy', 6, 1000),
    ('Handbags', 'Sell', 29, 7000),
    ('Corona Masks', 'Sell', 10, 10000);

SET FOREIGN_KEY_CHECKS = 1;
*/
