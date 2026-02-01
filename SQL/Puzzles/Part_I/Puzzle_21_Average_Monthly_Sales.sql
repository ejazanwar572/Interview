-- Puzzle 21 - Average Monthly Sales
--

-- Write an SQL statement that returns a list of states where customers have an average monthly sales value that is consistently greater than $100.

/*
| Order ID | Customer ID | Order Date | Amount | State |
|----------|-------------|------------|--------|-------|
| 1        | 1001        | 1/1/2018   | 100    | TX    |
| 2        | 1001        | 1/1/2018   | 150    | TX    |
| 3        | 1001        | 1/1/2018   | 75     | TX    |
| 4        | 1001        | 2/1/2018   | 100    | TX    |
| 5        | 1001        | 3/1/2018   | 100    | TX    |
| 6        | 2002        | 2/1/2018   | 75     | TX    |
| 7        | 2002        | 2/1/2018   | 150    | TX    |
| 8        | 3003        | 1/1/2018   | 100    | IA    |
| 9        | 3003        | 2/1/2018   | 100    | IA    |
| 10       | 3003        | 3/1/2018   | 100    | IA    |
| 11       | 4004        | 4/1/2018   | 100    | IA    |
| 12       | 4004        | 5/1/2018   | 50     | IA    |
| 13       | 4004        | 5/1/2018   | 100    | IA    |
*/

-- Here is the expected output.

/*
| State |
|-------|
| TX    |
*/

-- - Texas (`TX`) would show in the result set as `Customer ID` `1001` and `2002` each has their average monthly value over $100.
-- - Iowa (`IA`) would not show in the result set because `Customer ID` `4004` did not have an average monthly value over $100 in May 2018.


-- ==================================================
-- Solution for Puzzle 21
-- ==================================================

DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders
(
OrderID     INTEGER PRIMARY KEY,
CustomerID  INTEGER NOT NULL,
OrderDate   DATE NOT NULL,
Amount      MONEY NOT NULL,
[State]     VARCHAR(2) NOT NULL
);

INSERT INTO Orders (OrderID, CustomerID, OrderDate, Amount, [State]) VALUES
(1,1001,'1/1/2018',100,'TX'),
(2,1001,'1/1/2018',150,'TX'),
(3,1001,'1/1/2018',75,'TX'),
(4,1001,'2/1/2018',100,'TX'),
(5,1001,'3/1/2018',100,'TX'),
(6,2002,'2/1/2018',75,'TX'),
(7,2002,'2/1/2018',150,'TX'),
(8,3003,'1/1/2018',100,'IA'),
(9,3003,'2/1/2018',100,'IA'),
(10,3003,'3/1/2018',100,'IA'),
(11,4004,'4/1/2018',100,'IA'),
(12,4004,'5/1/2018',50,'IA'),
(13,4004,'5/1/2018',100,'IA');

WITH cte_AvgMonthlySalesCustomer AS
(
SELECT  CustomerID,
        OrderDate,
        [State],
        AVG(Amount) AS AverageValue
FROM    Orders
GROUP BY CustomerID,OrderDate,[State]
),
cte_MinAverageValueState AS
(
SELECT  [State]
FROM    cte_AvgMonthlySalesCustomer
GROUP BY [State]
HAVING  MIN(AverageValue) >= 100
)
SELECT  [State]
FROM    cte_MinAverageValueState;
