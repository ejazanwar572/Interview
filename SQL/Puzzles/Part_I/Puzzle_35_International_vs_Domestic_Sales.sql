-- Puzzle 35 - International vs. Domestic Sales
--

-- You work in a sales office that sells widgets both domestically and internationally.

-- Write an SQL statement that shows all sales representatives who either had a domestic sale or an international sale, but not both.

/*
| Invoice ID | Sales Rep ID | Amount  |   Sales Type   |
|------------|--------------|---------|----------------|
| 1          | 1001         | 13,454  | International  |
| 2          | 2002         | 3,434   | International  |
| 3          | 4004         | 54,645  | International  |
| 4          | 5005         | 234,345 | International  |
| 5          | 1001         | 4,564   | Domestic       |
| 6          | 2002         | 34,534  | Domestic       |
| 7          | 3003         | 345     | Domestic       |
| 8          | 6006         | 6,543   | Domestic       |
*/

-- Here is the expected output.

/*
| Sales Rep ID |
|--------------|
| 3003         |
| 4004         |
| 5005         |
| 6006         |
*/

-- - `Sales Rep ID` `3003`, `4004`, `5005`, and `6006` appear because they had either an international sale or a domestic sale, but not both.


-- ==================================================
-- Solution for Puzzle 35
-- ==================================================

DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders
(
InvoiceID   INTEGER PRIMARY KEY,
SalesRepID  INTEGER NOT NULL,
Amount      MONEY NOT NULL,
SalesType   VARCHAR(100) NOT NULL
);

INSERT INTO Orders (InvoiceId, SalesRepID, Amount, SalesType) VALUES
(1,1001,13454,'International'),
(2,2002,3434,'International'),
(3,4004,54645,'International'),
(4,5005,234345,'International'),
(5,1001,4564,'Domestic'),
(6,2002,34534,'Domestic'),
(7,3003,345,'Domestic'),
(8,6006,6543,'Domestic');

SELECT  SalesRepID
FROM    Orders
GROUP BY SalesRepID
HAVING   COUNT(DISTINCT SalesType) = 1;
