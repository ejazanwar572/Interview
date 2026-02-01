-- Puzzle 33 - Deadlines
--

-- You are employed by a company specializing in manufacturing various light bulbs. Each bulb is composed of distinct components, each requiring a specific number of days for production, and these components can be constructed independently.

-- Your task is to analyze a table of orders with their respective requested delivery dates and ascertain whether each order can be completed and assembled by the specified delivery date.

-- **Orders**
/*
| Order ID | Component | Days to Deliver |
|----------|-----------|-----------------|
| 1        | Aurora    | 7               |
| 2        | Twilight  | 3               |
| 3        | SunRay    | 9               |
*/

-- **Manufacturing Time**
/*
| Product  |    Component    | Days to Manufacture |
|----------|-----------------|---------------------|
| Aurora   | Photon Coil     | 7                   |
| Aurora   | Filament        | 2                   |
| Aurora   | Shine Capacitor | 3                   |
| Aurora   | Glow Sphere     | 1                   |
| Twilight | Photon Coil     | 7                   |
| Twilight | Filament        | 2                   |
| SunRay   | Shine Capacitor | 3                   |
| SunRay   | Photon Coil     | 1                   |
*/

-- Here is the expected output.

/*
| Order ID | Product  | Days to Build | Days to Deliver | Schedule          |
|----------|----------|---------------|-----------------|-------------------|
| 1        | Aurora   | 7             | 7               | On Schedule       |
| 2        | Twilight | 7             | 3               | Behind Schedule   |
| 3        | SunRay   | 3             | 9               | Ahead of Schedule |
*/


-- ==================================================
-- Solution for Puzzle 33
-- ==================================================

DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS ManufacturingTimes;

CREATE TABLE Orders
(
OrderID        INTEGER PRIMARY KEY,
Product        VARCHAR(100) NOT NULL,
DaysToDeliver  INTEGER NOT NULL
);

CREATE TABLE ManufacturingTimes
(
Product            VARCHAR(100),
Component          VARCHAR(100),
DaysToManufacture  INTEGER NOT NULL,
PRIMARY KEY (Product, Component)
);

INSERT INTO Orders (OrderID, Product, DaysToDeliver) VALUES
(1, 'Aurora', 7),
(2, 'Twilight', 3),
(3, 'SunRay', 9);

INSERT INTO ManufacturingTimes (Product, Component, DaysToManufacture) VALUES
('Aurora', 'Photon Coil', 7),
('Aurora', 'Filament', 2),
('Aurora', 'Shine Capacitor', 3),
('Aurora', 'Glow Sphere', 1),
('Twilight', 'Photon Coil', 7),
('Twilight', 'Filament', 2),
('SunRay', 'Shine Capacitor', 3),
('SunRay', 'Photon Coil', 1);

WITH cte_Max AS
(
SELECT  Product,
        MAX(DaysToManufacture) AS DaysToBuild
FROM    ManufacturingTimes b
GROUP BY Product
)
SELECT  a.OrderID,
        a.Product,
        b.DaystoBuild,
        a.DaysToDeliver,
        CASE WHEN b.DaystoBuild = DaystoDeliver THEN 'On Schedule'
             WHEN b.DaystoBuild < DaystoDeliver THEN 'Ahead of Schedule'
             WHEN b.DaystoBuild > DaystoDeliver THEN 'Behind Schedule' END AS Schedule
FROM    Orders a INNER JOIN
        cte_Max b ON a.Product = b.Product;
