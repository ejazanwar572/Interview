-- Puzzle 13 - Inventory Tracking
--

-- You work for a manufacturing company and need to track inventory adjustments from the warehouse.  

-- Some days, the inventory increases; on other days, it decreases.  

-- Write an SQL statement that will provide a running balance of the inventory.  

/*
| Date      | Quantity Adjustment |
|-----------|---------------------|
| 7/1/2018  | 100                 |
| 7/2/2018  | 75                  |
| 7/3/2018  | -150                |
| 7/4/2018  | 50                  |
| 7/5/2018  | -100                |
*/

-- Here is the expected output.

/*
| Date      | Quantity Adjustment | Inventory |
|-----------|---------------------|-----------|
| 7/1/2018  | 100                 | 100       |
| 7/2/2018  | 75                  | 175       |
| 7/3/2018  | -150                | 25        |
| 7/4/2018  | 50                  | 75        |
| 7/5/2018  | -100                | -25       |
*/


-- Solution
-- Solution for Puzzle 13: Inventory Tracking
SELECT Date, QuantityAdjustment,
       SUM(QuantityAdjustment) OVER (ORDER BY Date) AS Inventory
FROM Inventory;


-- ==================================================
-- Solution for Puzzle 13
-- ==================================================

DROP TABLE IF EXISTS Inventory;

CREATE TABLE Inventory
(
InventoryDate       DATE PRIMARY KEY,
QuantityAdjustment  INTEGER NOT NULL
);

INSERT INTO Inventory (InventoryDate, QuantityAdjustment) VALUES
('7/1/2018',100),('7/2/2018',75),('7/3/2018',-150),
('7/4/2018',50),('7/5/2018',-100);

SELECT  InventoryDate,
        QuantityAdjustment,
        SUM(QuantityAdjustment) OVER (ORDER BY InventoryDate)
FROM    Inventory;
