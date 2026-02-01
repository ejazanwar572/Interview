-- Puzzle 72 - Under Warranty
--

-- Your laptop repair shop offers a 30-day warranty on its repair services. From the following dataset, determine all rework that falls under warranty.

/*
| Repair ID | Customer ID | Repair Date |
|-----------|-------------|-------------|
| 1001      | A           | 01/01/2023  |
| 2002      | A           | 01/15/2023  |
| 3003      | A           | 01/17/2023  |
| 4004      | A           | 03/24/2023  |
| 5005      | A           | 04/01/2023  |
| 6006      | B           | 06/22/2023  |
| 7007      | B           | 06/23/2023  |
| 8008      | B           | 09/01/2023  |
*/

-- Here is the expected output.

/*
| Customer ID | Repair ID | Previous Repair ID | Repair Date | Previous Repair Date | Sequence Number | Repair Gap Days |
|-------------|-----------|--------------------|-------------|----------------------|-----------------|-----------------|
| A           | 2002      | 1001               | 01/15/2023  | 01/01/2023           | 1               | 14              |
| A           | 3003      | 2002               | 01/17/2023  | 01/15/2023           | 2               | 2               |
| A           | 5005      | 4004               | 04/01/2023  | 03/24/2023           | 1               | 8               |
| B           | 7007      | 6006               | 06/23/2023  | 06/22/2023           | 1               | 1               |
*/


-- ==================================================
-- Solution for Puzzle 72
-- ==================================================

DROP TABLE IF EXISTS Repairs;

CREATE TABLE Repairs (
RepairID    INTEGER PRIMARY KEY,
CustomerID  CHAR(1) NOT NULL,
RepairDate  DATE NOT NULL
);

INSERT INTO Repairs (RepairID, CustomerID, RepairDate) VALUES
(1001,'A','2023-01-01'),
(2002,'A','2023-01-15'),
(3003,'A','2023-01-17'),
(4004,'A','2023-03-24'),
(5005,'A','2023-04-01'),
(6006,'B','2023-06-22'),
(7007,'B','2023-06-23'),
(8008,'B','2023-09-01');

WITH cte_Lag AS
(
SELECT  *,
        LAG(RepairDate,1) OVER (PARTITION BY CustomerID ORDER BY RepairDate) AS LagRepairDate,
        LAG(RepairID,1)   OVER (PARTITION BY CustomerID ORDER BY RepairDate) AS LagRepairID
FROM    Repairs
),
cte_DateDiff AS
(
SELECT  TIMESTAMPDIFF(REPAIRDATE, LagRepairDate) AS LagDateDiff, ROW_NUMBER() OVER (ORDER BY RepairDate) AS RowNumber,
        *
FROM cte_Lag
),
cte_GroupKey AS
(
SELECT  CASE WHEN LagDateDiff > 30 THEN 1 END AS GroupKey,
        *
FROM    cte_DateDiff
),
cte_Sum AS
(
SELECT  *,
        SUM(GroupKey) OVER (PARTITION BY CustomerID ORDER BY RowNumber) AS GroupingID
FROM    cte_GroupKey
),
cte_RowNumber AS
(
SELECT  *
        ,ROW_NUMBER() OVER (PARTITION BY CustomerID, GroupingID ORDER BY GroupingID, RepairDate) - 1 AS SequenceNumber
FROM    cte_Sum
)
SELECT  CustomerID
        ,RepairID
        ,LagRepairID AS PreviousRepaidID
        ,RepairDate
        ,LagRepairDate AS PreviousRepairDate
        ,SequenceNumber
        ,LagDateDiff AS RepaidGapDays
FROM    cte_RowNumber
WHERE   SequenceNumber <> 0;
