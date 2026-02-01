-- Puzzle 55 - Table Audit
--

-- Conduct an audit on the following tables to identify products and their corresponding quantities that are either matching or unique to each table, and generate the expected output listed below.

-- **Products A**
/*
| Product Name | Quantity |
|--------------|----------|
| Widget       | 7        |
| Doodad       | 9        |
| Gizmo        | 3        |
*/

-- **Products B**
/*
| Product Name | Quantity |
|--------------|----------|
| Widget       | 7        |
| Doodad       | 6        |
| Dingbat      | 9        |
*/

-- Here is the expected output.

/*
|                      Type                    | Product Name |
|----------------------------------------------|--------------|
| Matches in both table A and table B          | Widget       |
| Product does not exist in table A            | Dingbat      |
| Product does not exist in table B            | Gizmo        |
| Quantity in table A and table B do not match | Doodad       |
*/


-- ==================================================
-- Solution for Puzzle 55
-- ==================================================

DROP TABLE IF EXISTS ProductsA;
DROP TABLE IF EXISTS ProductsB;

CREATE TABLE ProductsA
(
ProductName  VARCHAR(100) PRIMARY KEY,
Quantity     INTEGER NOT NULL
);

CREATE TABLE ProductsB
(
ProductName  VARCHAR(100) PRIMARY KEY,
Quantity     INTEGER NOT NULL
);

INSERT INTO ProductsA (ProductName, Quantity) VALUES
('Widget',7),
('Doodad',9),
('Gizmo',3);

INSERT INTO ProductsB (ProductName, Quantity) VALUES
('Widget',7),
('Doodad',6),
('Dingbat',9);

WITH cte_FullOuter AS
(
SELECT  a.ProductName AS ProductNameA,
        b.ProductName AS ProductNameB,
        a.Quantity AS QuantityA,
        b.Quantity AS QuantityB
FROM    ProductsA a /* MySQL_Conversion_Warning: FULL OUTER JOIN not supported. Use LEFT JOIN UNION RIGHT JOIN. */ FULL OUTER JOIN
        ProductsB b ON a.ProductName = b.ProductName
)
SELECT  'Matches in both table A and table B' AS [Type],
        ProductNameA
FROM    cte_FullOuter
WHERE   ProductNameA = ProductNameB AND QuantityA = QuantityB
UNION
SELECT  'Product does not exist in table B' AS [Type],
        ProductNameA
FROM    cte_FullOuter
WHERE   ProductNameB IS NULL
UNION
SELECT  'Product does not exist in table A' AS [Type],
        ProductNameB
FROM   cte_FullOuter
WHERE  ProductNameA IS NULL
UNION
SELECT  'Quantities in table A and table B do not match' AS [Type],
        ProductNameA
FROM    cte_FullOuter
WHERE   ProductNameA = ProductNameB AND QuantityA <> QuantityB;
