-- Puzzle 4 - Two Predicates
--

-- Write an SQL statement given the following requirements.  

-- For every customer who had a delivery to California (CA), provide a result set of the customer orders that were delivered to Texas (TX).  

/*
| Customer ID | Order ID | Delivery State | Amount |
|-------------|----------|----------------|--------|
| 1001        | 1        | CA             | 340    |
| 1001        | 2        | TX             | 950    |
| 1001        | 3        | TX             | 670    |
| 1001        | 4        | TX             | 860    |
| 2002        | 5        | WA             | 320    |
| 3003        | 6        | CA             | 650    |
| 3003        | 7        | CA             | 830    |
| 4004        | 8        | TX             | 120    |
*/

-- Here is the expected output.

/*
| Customer ID | Order ID | Delivery State | Amount |
|-------------|----------|----------------|--------|
| 1001        | 2        | TX             | 950    |
| 1001        | 3        | TX             | 670    |
| 1001        | 4        | TX             | 860    |
*/

-- - `Customer ID` `1001` appears in the result set because they had deliveries to both California (`CA`) and Texas (`TX`).  
-- - `Customer ID` `3003` does not appear because they never had a delivery to Texas (`TX`).  
-- - `Customer ID` `4004` does not appear because they never had a delivery to California (`CA`).  


-- Solution
-- Solution for Puzzle 4: Two Predicates
SELECT CustomerID, OrderID, DeliveryState, Amount
FROM Orders
WHERE DeliveryState = 'TX'
AND CustomerID IN (
    SELECT CustomerID
    FROM Orders
    WHERE DeliveryState = 'CA'
);


-- ==================================================
-- Solution for Puzzle 4
-- ==================================================

DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders
(
CustomerID     INTEGER,
OrderID        INTEGER,
DeliveryState  VARCHAR(100) NOT NULL,
Amount         MONEY NOT NULL,
PRIMARY KEY (CustomerID, OrderID)
);

INSERT INTO Orders (CustomerID, OrderID, DeliveryState, Amount) VALUES
(1001,1,'CA',340),(1001,2,'TX',950),(1001,3,'TX',670),
(1001,4,'TX',860),(2002,5,'WA',320),(3003,6,'CA',650),
(3003,7,'CA',830),(4004,8,'TX',120);

--Solution 1
--INNER JOIN
WITH cte_CA AS
(
SELECT  DISTINCT CustomerID
FROM    Orders
WHERE   DeliveryState = 'CA'
)
SELECT  b.CustomerID, b.OrderID, b.DeliveryState, b.Amount
FROM    cte_CA a INNER JOIN
        Orders b ON a.CustomerID = B.CustomerID
WHERE   b.DeliveryState = 'TX';

--Solution 2
--IN
WITH cte_CA AS
(
SELECT  CustomerID
FROM    Orders
WHERE   DeliveryState = 'CA'
)
SELECT  CustomerID,
        OrderID,
        DeliveryState,
        Amount
FROM    Orders
WHERE   DeliveryState = 'TX' AND
        CustomerID IN (SELECT b.CustomerID FROM cte_CA b);

--Solution 3
--COUNT
WITH cte_distinct AS
(
SELECT DISTINCT CustomerID, DeliveryState
FROM   Orders
WHERE  DeliveryState IN ('CA','TX')
)
SELECT CustomerID
FROM   cte_distinct
GROUP BY CustomerID
HAVING COUNT(*) = 2;
