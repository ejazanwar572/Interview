-- Puzzle 63 - Promotion Codes
--

-- Identify all orders linked to a single product with a `PROMO` discount value. If an order is associated with multiple products or multiple discounts, it should not be included in the result.

/*
| Order ID | Product | Discount |
|----------|---------|----------|
| 1        | Item 1  | PROMO    |
| 1        | Item 1  | PROMO    |
| 1        | Item 1  | MARKDOWN |
| 1        | Item 2  | PROMO    |
| 2        | Item 2  |          |
| 2        | Item 3  | MARKDOWN |
| 2        | Item 3  |          |
| 3        | Item 1  | PROMO    |
| 3        | Item 1  | PROMO    |
| 3        | Item 1  | PROMO    |
*/

-- Here is the expected output.

/*
| Order ID |
|----------|
| 3        |
*/

-- - `Order ID` `3` meets these criteria because it has a connection to only one product (`Item 1`), and all the products linked to it have a discount value of `PROMO`.  
-- - `Order ID` `1` does not meet the criteria as it is linked to two different products (`Item 1` and `Item 2`).


-- ==================================================
-- Solution for Puzzle 63
-- ==================================================

DROP TABLE IF EXISTS Promotions;

CREATE TABLE Promotions (
OrderID   INTEGER NOT NULL,
Product   VARCHAR(255) NOT NULL,
Discount  VARCHAR(255)
);

INSERT INTO Promotions (OrderID, Product, Discount) VALUES 
(1, 'Item1', 'PROMO'),
(1, 'Item1', 'PROMO'),
(1, 'Item1', 'MARKDOWN'),
(1, 'Item2', 'PROMO'),
(2, 'Item2', NULL),
(2, 'Item3', 'MARKDOWN'),
(2, 'Item3', NULL),
(3, 'Item1', 'PROMO'),
(3, 'Item1', 'PROMO'),
(3, 'Item1', 'PROMO');

SELECT OrderID
FROM   Promotions
WHERE  Discount = ALL(SELECT 'PROMO')
GROUP BY OrderID
HAVING COUNT(DISTINCT Product) = 1;
