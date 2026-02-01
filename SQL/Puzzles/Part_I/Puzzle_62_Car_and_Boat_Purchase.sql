-- Puzzle 62 - Car and Boat Purchase
--

-- You won the lottery and want to buy both a car and a boat. However, the car must be $200,000 more than the boat. What are your options given the following vehicles?

/*
| Vehicle ID | Type |        Model        |  Price   |
|------------|------|---------------------|----------|
| 1          | Car  | Rolls-Royce Phantom | 460,000  |
| 2          | Car  | Cadillac CT5        | 39,000   |
| 3          | Car  | Porsche Boxster     | 63,000   |
| 4          | Car  | Lamborghini Spyder  | 290,000  |
| 5          | Boat | Malibu              | 210,000  |
| 6          | Boat | ATX 22-S            | 85,000   |
| 7          | Boat | Sea Ray SLX         | 520,000  |
| 8          | Boat | Mastercraft         | 25,000   |
*/

-- Here is the expected outcome.

/*
|           Car       |     Boat    |
|---------------------|-------------|
| Lamborghini Spyder  | ATX 22-S    |
| Lamborghini Spyder  | Mastercraft |
| Rolls-Royce Phantom | ATX 22-S    |
| Rolls-Royce Phantom | Malibu      |
| Rolls-Royce Phantom | Mastercraft |
*/


-- ==================================================
-- Solution for Puzzle 62
-- ==================================================

DROP TABLE IF EXISTS Vehicles;

CREATE TABLE Vehicles (
VehicleID  INTEGER PRIMARY KEY,
[Type]     VARCHAR(20),
Model      VARCHAR(20),
Price      MONEY
);

INSERT INTO Vehicles (VehicleID, [Type], Model, Price) VALUES
(1, 'Car','Rolls-Royce Phantom', 460000),
(2, 'Car','Cadillac CT5', 39000),
(3, 'Car','Porsche Boxster', 63000),
(4, 'Car','Lamborghini Spyder', 290000),
(5, 'Boat','Malibu', 210000),
(6, 'Boat', 'ATX 22-S', 85000),
(7, 'Boat', 'Sea Ray SLX', 520000),
(8, 'Boat', 'Mastercraft', 25000);

SELECT  a.Model AS Car,
        b.Model AS Boat
FROM    Vehicles a CROSS JOIN
        Vehicles B
WHERE   a.Type = 'Car' AND
        b.Type = 'Boat' AND
        a.Price > b.Price + 200000
ORDER BY 1,2;
