-- Puzzle 17 - De-Grouping
--

-- Write an SQL Statement to de-group the following data.  

/*
| Product  | Quantity |
|----------|----------|
| Pencil   | 3        |
| Eraser   | 4        |
| Notebook | 2        |
*/

-- Here is the expected output.

/*
| Product  | Quantity |
|----------|----------|
| Pencil   | 1        |
| Pencil   | 1        |
| Pencil   | 1        |
| Eraser   | 1        |
| Eraser   | 1        |
| Eraser   | 1        |
| Eraser   | 1        |
| Notebook | 1        |
| Notebook | 1        |
*/


-- ==================================================
-- Solution for Puzzle 17
-- ==================================================

DROP TABLE IF EXISTS Ungroup;
DROP TABLE IF EXISTS Numbers;

CREATE TABLE Ungroup
(
ProductDescription  VARCHAR(100) PRIMARY KEY,
Quantity            INTEGER NOT NULL
);

INSERT INTO Ungroup (ProductDescription, Quantity) VALUES
('Pencil',3),('Eraser',4),('Notebook',2);

--Solution 1
--Numbers Table
SELECT IntegerValue
INTO   Numbers
FROM   (VALUES(1),(2),(3),(4)) a(IntegerValue) 

ALTER TABLE Ungroup ADD FOREIGN KEY (Quantity) REFERENCES Numbers(IntegerValue);

SELECT  a.ProductDescription,
        1 AS Quantity
FROM    Ungroup a CROSS JOIN
        Numbers b
WHERE   a.Quantity >= b.IntegerValue;

--Solution 2
--Recursion
WITH cte_Recursion AS
(
SELECT  ProductDescription,Quantity 
FROM    Ungroup
UNION ALL
SELECT  ProductDescription,Quantity-1 
FROM    cte_Recursion
WHERE   Quantity >= 2
    )
SELECT  ProductDescription,1 AS Quantity
FROM   cte_Recursion
ORDER BY ProductDescription DESC;
