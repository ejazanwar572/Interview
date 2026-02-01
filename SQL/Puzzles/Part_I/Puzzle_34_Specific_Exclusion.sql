-- Puzzle 34 - Specific Exclusion
--

-- Write an SQL statement that returns all rows except where the `Customer ID` is `1001` and the `Amount` is `$50`.

/*
| Order ID | Customer ID | Amount |
|----------|-------------|--------|
| 1        | 1001        | 25     |
| 2        | 1001        | 50     |
| 3        | 2002        | 65     |
| 4        | 3003        | 50     |
*/

-- Here is the expected output.

/*
| Order ID | Customer ID | Amount |
|----------|-------------|--------|
| 1        | 1001        | 25     |
| 3        | 2002        | 65     |
| 4        | 3003        | 50     |
*/


-- ==================================================
-- Solution for Puzzle 34
-- ==================================================

DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders
(
OrderID     INTEGER PRIMARY KEY,
CustomerID  INTEGER NOT NULL,
Amount      MONEY NOT NULL
);

INSERT INTO Orders (OrderID, CustomerID, Amount) VALUES
(1,1001,25),(2,1001,50),(3,2002,65),(4,3003,50);

--Solutions 1 and 2 show Morgan's Law.
--Solution 1
--NOT
SELECT  OrderID,
        CustomerID,
        Amount
FROM    Orders
WHERE   NOT(CustomerID = 1001 AND Amount = 50);

--Solution 2 
--OR
SELECT  OrderID,
        CustomerID,
        Amount
FROM    Orders
WHERE   CustomerID <> 1001 OR Amount <> 50;

--Solution 3
--EXCEPT
SELECT  OrderID,
        CustomerID,
        Amount
FROM    Orders
EXCEPT
SELECT  OrderID,
        CustomerID,
        Amount
FROM    Orders
WHERE   CustomerID = 1001 AND Amount = 50;
