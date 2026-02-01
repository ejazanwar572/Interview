-- Puzzle 43 - Unbounded Preceding
--

-- Determine the minimum quantity for each record between the current row and all previous rows for each `Customer ID`.

/*
| Order ID | Customer ID | Quantity |
|----------|-------------|----------|
| 1        | 1001        | 5        |
| 2        | 1001        | 8        |
| 3        | 1001        | 3        |
| 4        | 1001        | 7        |
| 1        | 2002        | 4        |
| 2        | 2002        | 9        |
*/

-- Here is the expected output.

/*
| Order ID | Customer ID | Quantity | Min Value |
|----------|-------------|----------|-----------|
| 1        | 1001        | 5        | 5         |
| 2        | 1001        | 8        | 5         |
| 3        | 1001        | 3        | 3         |
| 4        | 1001        | 7        | 3         |
| 1        | 2002        | 4        | 4         |
| 2        | 2002        | 9        | 4         |
*/


-- ==================================================
-- Solution for Puzzle 43
-- ==================================================

DROP TABLE IF EXISTS CustomerOrders;

CREATE TABLE CustomerOrders
(
OrderID     INTEGER,
CustomerID  INTEGER,
Quantity    INTEGER NOT NULL,
PRIMARY KEY (OrderID, CustomerID)
);

INSERT INTO CustomerOrders (OrderID, CustomerID, Quantity) VALUES 
(1,1001,5),(2,1001,8),(3,1001,3),(4,1001,7),
(1,2002,4),(2,2002,9);

SELECT  OrderID,
        CustomerID,
        Quantity,
        MIN(Quantity) OVER (PARTITION by CustomerID ORDER BY OrderID) AS MinQuantity
FROM    CustomerOrders;
