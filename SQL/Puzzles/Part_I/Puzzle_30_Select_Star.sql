-- Puzzle 30 - Select Star
--

-- Your developers have many bad practices; the worst of them being that they routinely deploy procedures that do not explicitly define which columns to return in their `SELECT` clause.

-- Modify the following table in such a way that the statement `SELECT * FROM Products` will return an error when executed.

CREATE TABLE Products
(
ProductID  INTEGER PRIMARY KEY,
ProductName VARCHAR(200)
);


-- ==================================================
-- Solution for Puzzle 30
-- ==================================================

DROP TABLE IF EXISTS Products;

CREATE TABLE Products
(
ProductID    INTEGER PRIMARY KEY,
ProductName  VARCHAR(100) NOT NULL
);

--Add the following constraint
ALTER TABLE Products ADD ComputedColumn AS (0/0);
