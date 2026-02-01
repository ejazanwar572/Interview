-- Puzzle 45 - Slowly Changing Dimension Part II
--

-- Given the following table with overlapping time frames. Write an SQL statement to identify the overlapping records.

/*
| Customer ID | Start Date | End Date   | Amount |
|-------------|------------|------------|--------|
| 1001        | 10/11/2021 | 12/31/9999 | 54.32  |
| 1001        | 10/10/2021 | 10/10/2021 | 17.65  |
| 1001        | 9/18/2021  | 10/12/2021 | 65.56  |
| 2002        | 9/12/2021  | 9/17/2021  | 56.23  |
| 2002        | 9/1/2021   | 9/17/2021  | 42.12  |
| 2002        | 8/15/2021  | 8/31/2021  | 16.32  |
*/

-- Here is the expected output.

/*
| Customer ID | Start Date | End Date   | Amount |
|-------------|------------|------------|--------|
| 1001        | 9/18/2021  | 10/12/2021 | 65.56  |
| 2002        | 9/1/2021   | 9/17/2021  | 42.12  |
*/


-- ==================================================
-- Solution for Puzzle 45
-- ==================================================

DROP TABLE IF EXISTS Balances;

CREATE TABLE Balances
(
CustomerID  INTEGER,
StartDate   DATE,
EndDate     DATE,
Amount      MONEY,
PRIMARY KEY (CustomerID, StartDate)
);

INSERT INTO Balances (CustomerID, StartDate, EndDate, Amount) VALUES
(1001,'10/11/2021','12/31/9999',54.32),
(1001,'10/10/2021','10/10/2021',17.65),
(1001,'9/18/2021','10/12/2021',65.56),
(2002,'9/12/2021','9/17/2021',56.23),
(2002,'9/1/2021','9/17/2021',42.12),
(2002,'8/15/2021','8/31/2021',16.32);

WITH cte_Lag AS
(
SELECT  CustomerID, StartDate, EndDate, Amount,
        LAG(StartDate) OVER 
            (PARTITION BY CustomerID ORDER BY StartDate DESC) AS StartDate_Lag
FROM    Balances
)
SELECT  CustomerID, StartDate, EndDate, Amount, StartDate_Lag
FROM    cte_Lag
WHERE   EndDate >= StartDate_Lag
ORDER BY CustomerID, StartDate DESC;
