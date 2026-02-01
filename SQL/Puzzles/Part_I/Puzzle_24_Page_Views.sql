-- Puzzle 24 - Page Views
--

-- Write an SQL statement that retrieves records 5 through 10, ordered by the `Order ID` column.

/*
| Order ID | Customer ID | Order Date | Amount | State |
|----------|-------------|------------|--------|-------|
| 1        | 1001        | 1/1/2018   | 100    | TX    |
| 2        | 3003        | 1/1/2018   | 100    | IA    |
| 3        | 1001        | 3/1/2018   | 100    | TX    |
| 4        | 2002        | 2/1/2018   | 150    | TX    |
| 5        | 1001        | 2/1/2018   | 100    | TX    |
| 6        | 4004        | 5/1/2018   | 50     | IA    |
| 7        | 1001        | 1/1/2018   | 150    | TX    |
| 8        | 3003        | 3/1/2018   | 100    | IA    |
| 9        | 4004        | 4/1/2018   | 100    | IA    |
| 10       | 1001        | 1/1/2018   | 75     | TX    |
| 11       | 2002        | 2/1/2018   | 75     | TX    |
| 12       | 3003        | 2/1/2018   | 100    | IA    |
| 13       | 4004        | 5/1/2018   | 100    | IA    |
*/

-- Here is the expected output.

/*
| Order ID | Customer ID | Order Date | Amount | State |
|----------|-------------|------------|--------|-------|
| 5        | 1001        | 2/1/2018   | 100    | TX    |
| 6        | 4004        | 5/1/2018   | 50     | IA    |
| 7        | 1001        | 1/1/2018   | 150    | TX    |
| 8        | 3003        | 3/1/2018   | 100    | IA    |
| 9        | 4004        | 4/1/2018   | 100    | IA    |
| 10       | 1001        | 1/1/2018   | 75     | TX    |
*/


-- ==================================================
-- Solution for Puzzle 24
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
(1, 1001, '2018-01-01', 100, 'TX'),
(2, 3003, '2018-01-01', 100, 'IA'),
(3, 1001, '2018-03-01', 100, 'TX'),
(4, 2002, '2018-02-01', 150, 'TX'),
(5, 1001, '2018-02-01', 100, 'TX'),
(6, 4004, '2018-05-01', 50,  'IA'),
(7, 1001, '2018-01-01', 150, 'TX'),
(8, 3003, '2018-03-01', 100, 'IA'),
(9, 4004, '2018-04-01', 100, 'IA'),
(10, 1001, '2018-01-01', 75,  'TX'),
(11, 2002, '2018-02-01', 75,  'TX'),
(12, 3003, '2018-02-01', 100, 'IA'),
(13, 4004, '2018-05-01', 100, 'IA');

--Solution 1
--OFFSET FETCH NEXT
SELECT  OrderID, CustomerID, OrderDate, Amount, [State]
FROM    Orders
ORDER BY OrderID
OFFSET 4 ROWS FETCH NEXT 6 ROWS ONLY;

--Solution 2
--RowNumber
WITH cte_RowNumber AS
(
SELECT  ROW_NUMBER() OVER (ORDER BY OrderID) AS RowNumber,
        OrderID, CustomerID, OrderDate, Amount, [State]
FROM    Orders
)
SELECT  OrderID, CustomerID, OrderDate, Amount, [State]
FROM    cte_RowNumber
WHERE   RowNumber BETWEEN 5 AND 10;
