-- Puzzle 53 - Spouse IDs
--

-- You are given the following table of individuals and their spouses. Every individual exists both as a `Primary ID` and a `Spouse ID`. You need to create a group criteria key to match the associated records.

/*
| Primary ID | Spouse ID |
|------------|-----------|
| Pat        | Charlie   |
| Jordan     | Casey     |
| Ashley     | Dee       |
| Charlie    | Pat       |
| Casey      | Jordan    |
| Dee        | Ashley    |
*/

-- Here is the expected output.

/*
| Group ID | Primary ID | Spouse ID |
|----------|------------|-----------|
| 1        | Ashley     | Dee       |
| 1        | Dee        | Ashley    |
| 2        | Jordan     | Casey     |
| 2        | Casey      | Jordan    |
| 3        | Charlie    | Pat       |
| 3        | Pat        | Charlie   |
*/


-- ==================================================
-- Solution for Puzzle 53
-- ==================================================

DROP TABLE IF EXISTS Spouses;

CREATE TABLE Spouses
(
PrimaryID  VARCHAR(100),
SpouseID   VARCHAR(100),
PRIMARY KEY (PrimaryID, SpouseID)
);

INSERT INTO Spouses (PrimaryID, SpouseID) VALUES
('Pat','Charlie'),('Jordan','Casey'),
('Ashley','Dee'),('Charlie','Pat'),
('Casey','Jordan'),('Dee','Ashley');

WITH cte_Reciprocals AS
(
SELECT
        (CASE WHEN PrimaryID < SpouseID THEN PrimaryID ELSE SpouseID END) AS ID1,
        (CASE WHEN PrimaryID > SpouseID THEN PrimaryID ELSE SpouseID END) AS ID2,
        PrimaryID,
        SpouseID
FROM    Spouses
),
cte_DenseRank AS
(
SELECT  DENSE_RANK() OVER (ORDER BY ID1) AS GroupID,
        ID1, ID2, PrimaryID, SpouseID
FROM    cte_Reciprocals
)
SELECT  GroupID,
        b.PrimaryID,
        b.SpouseID
FROM    cte_DenseRank a INNER JOIN
        Spouses b ON a.PrimaryID = b.PrimaryID AND a.SpouseID = b.SpouseID;
