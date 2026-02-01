-- Puzzle 20 - Price Points
--

-- Write an SQL statement to determine the current price point for each product.

/*
| Product ID | Effective Date | Unit Price |
|------------|----------------|------------|
| 1001       | 1/1/2018       | 1.99       |
| 1001       | 4/15/2018      | 2.99       |
| 1001       | 6/8/2018       | 3.99       |
| 2002       | 4/17/2018      | 1.99       |
| 2002       | 5/19/2018      | 2.99       |
*/

-- Here is the expected output.

/*
| Product ID | Effective Date | Unit Price |
|------------|----------------|------------|
| 1001       | 6/8/2018       | 3.99       |
| 2002       | 5/19/2018      | 2.99       |
*/


-- ==================================================
-- Solution for Puzzle 20
-- ==================================================

DROP TABLE IF EXISTS ValidPrices;

CREATE TABLE ValidPrices
(
ProductID      INTEGER,
UnitPrice      MONEY,
EffectiveDate  DATE,
PRIMARY KEY (ProductID, UnitPrice, EffectiveDate)
);

INSERT INTO ValidPrices (ProductID, UnitPrice, EffectiveDate) VALUES
(1001,1.99,'1/01/2018'),
(1001,2.99,'4/15/2018'),
(1001,3.99,'6/8/2018'),
(2002,1.99,'4/17/2018'),
(2002,2.99,'5/19/2018');

--Solution 1
--NOT EXISTS
SELECT  ProductID,
        EffectiveDate,
        COALESCE(UnitPrice,0) AS UnitPrice
FROM    ValidPrices AS pp
WHERE   NOT EXISTS (SELECT    1
                    FROM      ValidPrices AS ppl
                    WHERE     ppl.ProductID = pp.ProductID AND
                              ppl.EffectiveDate > pp.EffectiveDate);

--Solution 2
--RANK
WITH cte_ValidPrices AS
(
SELECT  RANK() OVER (PARTITION BY ProductID ORDER BY EffectiveDate DESC) AS Rnk,
        ProductID,
        EffectiveDate,
        UnitPrice
FROM    ValidPrices
)
SELECT  Rnk, ProductID, EffectiveDate, UnitPrice
FROM    cte_ValidPrices
WHERE   Rnk = 1;

--Solution 3
--MAX
WITH cte_MaxEffectiveDate AS
(
SELECT  ProductID,
        MAX(EffectiveDate) AS MaxEffectiveDate
FROM    ValidPrices
GROUP BY ProductID
)
SELECT  a.*
FROM    ValidPrices a INNER JOIN
        cte_MaxEffectiveDate b ON a.EffectiveDate = b.MaxEffectiveDate AND a.ProductID = b.ProductID;
