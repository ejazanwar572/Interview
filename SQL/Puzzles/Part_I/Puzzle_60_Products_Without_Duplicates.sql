-- Puzzle 60 - Products Without Duplicates
--

-- Given the table below, return a result set of all product codes not associated with multiple products.

/*
| Product  | Product Code |
|----------|--------------|
| Alpha    | 01           |
| Alpha    | 02           |
| Bravo    | 03           |
| Charlie  | 02           |
*/

-- Here is the expected output.

/*
| Product Code |
|--------------|
| 01           |
| 03           |
*/


-- ==================================================
-- Solution for Puzzle 60
-- ==================================================

DROP TABLE IF EXISTS Products;

CREATE TABLE Products
(
Product      VARCHAR(10),
ProductCode  VARCHAR(2),
PRIMARY KEY (Product, ProductCode)
);

INSERT INTO Products (Product, ProductCode) VALUES
('Alpha','01'),
('Alpha','02'),
('Bravo','03'),
('Charlie','02');

SELECT ProductCode
FROM   Products
GROUP BY ProductCode
HAVING COUNT(DISTINCT Product) = 1;
