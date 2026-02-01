-- Puzzle 25 - Top Vendors
--

-- Write an SQL statement that returns the vendor from which each customer has placed the most orders.

/*
| Order ID | Customer ID | Count |    Vendor    |
|----------|-------------|-------|--------------|
| 1        | 1001        | 12    | Direct Parts |
| 2        | 1001        | 54    | Direct Parts |
| 3        | 1001        | 32    | ACME         |
| 4        | 2002        | 7     | ACME         |
| 5        | 2002        | 16    | ACME         |
| 6        | 2002        | 5     | Direct Parts |
*/

-- Here is the expected output.

/*
| Customer ID |    Vendor    |
|-------------|--------------|
| 1001        | Direct Parts |
| 2002        | ACME         |
*/


-- ==================================================
-- Solution for Puzzle 25
-- ==================================================

DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders
(
OrderID     INTEGER PRIMARY KEY,
CustomerID  INTEGER NOT NULL,
[Count]     INTEGER NOT NULL,
Vendor      VARCHAR(100) NOT NULL
);

INSERT INTO Orders (OrderID, CustomerID, [Count], Vendor) VALUES
(1,1001,12,'Direct Parts'),
(2,1001,54,'Direct Parts'),
(3,1001,32,'ACME'),
(4,2002,7,'ACME'),
(5,2002,16,'ACME'),
(6,2002,5,'Direct Parts');

--Solution 1
--MAX window function
WITH cte_Max AS
(
SELECT  OrderID, CustomerID, [Count], Vendor,
        MAX([Count]) OVER (PARTITION BY CustomerID ORDER BY CustomerID) AS MaxCount
FROM    Orders
)
SELECT  CustomerID, Vendor
FROM    cte_Max
WHERE   [Count] = MaxCount
ORDER BY 1, 2;

--Solution 1
--RANK function
WITH cte_Rank AS
(
SELECT  CustomerID,
        Vendor,
        RANK() OVER (PARTITION BY CustomerID ORDER BY [Count] DESC) AS Rnk
FROM    Orders
GROUP BY CustomerID, Vendor, [Count]
)
SELECT  DISTINCT b.CustomerID, b.Vendor
FROM    Orders a INNER JOIN
        cte_Rank b ON a.CustomerID = b.CustomerID AND a.Vendor = b.Vendor
WHERE   Rnk = 1
ORDER BY 1, 2;

--Solution 3
--MAX with Correlated SubQuery
WITH cte_Max AS
(
SELECT  CustomerID,
        MAX([Count]) AS MaxOrderCount
FROM    Orders
GROUP BY CustomerID
)
SELECT  CustomerID, Vendor
FROM    Orders a
WHERE   EXISTS (SELECT 1 FROM cte_Max b WHERE a.CustomerID = b.CustomerID and a.[Count] = MaxOrderCount)
ORDER BY 1, 2;

--Solution 4
--ALL Operator with Correlated Subquery
SELECT  CustomerID, Vendor
FROM    Orders a
WHERE   [Count] >= ALL(SELECT [Count] FROM Orders b WHERE a.CustomerID = b.CustomerID)
ORDER BY 1, 2;

--Solution 5
--MAX Functionr with Correlated Subquery
SELECT  CustomerID, Vendor
FROM    Orders a
WHERE   [Count] >= (SELECT MAX([Count]) FROM Orders b WHERE a.CustomerID = b.CustomerID)
ORDER BY 1, 2;
