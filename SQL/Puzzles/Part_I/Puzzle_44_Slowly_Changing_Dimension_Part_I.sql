-- Puzzle 44 - Slowly Changing Dimension Part I
--

-- Given the following table, write an SQL statement to create a Type 2 Slowly Changing Dimension.

/*
| Customer ID | Balance Date | Amount |
|-------------|--------------|--------|
| 1001        | 10/11/2021   | 54.32  |
| 1001        | 10/10/2021   | 17.65  |
| 1001        | 9/18/2021    | 65.56  |
| 1001        | 9/12/2021    | 56.23  |
| 1001        | 9/1/2021     | 42.12  |
| 2002        | 10/15/2021   | 46.52  |
| 2002        | 10/13/2021   | 7.65   |
| 2002        | 9/15/2021    | 75.12  |
| 2002        | 9/10/2021    | 47.34  |
| 2002        | 9/2/2021     | 11.11  |
*/

-- Here is the expected output.

/*
| Customer ID | Start Date | End Date   | Amount |
|-------------|------------|------------|--------|
| 1001        | 10/11/2021 | 12/31/9999 | 54.32  |
| 1001        | 10/10/2021 | 10/10/2021 | 17.65  |
| 1001        | 9/18/2021  | 10/9/2021  | 65.56  |
| 1001        | 9/12/2021  | 9/17/2021  | 56.23  |
| 1001        | 9/1/2021   | 9/11/2021  | 42.12  |
| 2002        | 10/15/2021 | 12/31/9999 | 46.52  |
| 2002        | 10/13/2021 | 10/14/2021 | 7.65   |
| 2002        | 9/15/2021  | 10/12/2021 | 75.12  |
| 2002        | 9/10/2021  | 9/14/2021  | 47.34  |
| 2002        | 9/2/2021   | 9/9/2021   | 11.11  |
*/


-- ==================================================
-- Solution for Puzzle 44
-- ==================================================

DROP TABLE IF EXISTS Balances;

CREATE TABLE Balances
(
CustomerID   INTEGER,
BalanceDate  DATE,
Amount       MONEY NOT NULL,
PRIMARY KEY (CustomerID, BalanceDate)
);

INSERT INTO Balances (CustomerID, BalanceDate, Amount) VALUES
(1001,'10/11/2021',54.32),
(1001,'10/10/2021',17.65),
(1001,'9/18/2021',65.56),
(1001,'9/12/2021',56.23),
(1001,'9/1/2021',42.12),
(2002,'10/15/2021',46.52),
(2002,'10/13/2021',7.65),
(2002,'9/15/2021',75.12),
(2002,'9/10/2021',47.34),
(2002,'9/2/2021',11.11);

WITH cte_Customers AS
(
SELECT  CustomerID,
        BalanceDate,
        LAG(BalanceDate) OVER 
                (PARTITION BY CustomerID ORDER BY BalanceDate DESC)
                    AS EndDate,
        Amount
FROM    Balances
)
SELECT  CustomerID,
        BalanceDate AS StartDate,
        IFNULL(DATEADD(DAY,-1,EndDate),'12/31/9999') AS EndDate,
        Amount
FROM    cte_Customers
ORDER BY CustomerID, BalanceDate DESC;
