-- Puzzle 37 - Group Criteria Keys
--

-- Write an SQL statement that provides a key based on the distinct combination of the columns `Distributor`, `Facility`, and `Zone`.

/*
| Order ID | Distributor  | Facility | Zone | Amount |
|----------|--------------|----------|------|--------|
| 1        | ACME         | 123      | ABC  | 100    |
| 2        | ACME         | 123      | ABC  | 75     |
| 3        | Direct Parts | 789      | XYZ  | 150    |
| 4        | Direct Parts | 789      | XYZ  | 125    |
*/

-- Here is the expected output.

/*
| Criteria ID | Order ID | Distributor  | Facility | Zone | Amount |
|-------------|----------|--------------|----------|------|--------|
| 1           | 1        | ACME         | 123      | ABC  | 100    |
| 1           | 2        | ACME         | 123      | ABC  | 75     |
| 2           | 3        | Direct Parts | 789      | XYZ  | 150    |
| 2           | 4        | Direct Parts | 789      | XYZ  | 125    |
*/


-- ==================================================
-- Solution for Puzzle 37
-- ==================================================

DROP TABLE IF EXISTS GroupCriteria;

CREATE TABLE GroupCriteria
(
OrderID      INTEGER PRIMARY KEY,
Distributor  VARCHAR(100) NOT NULL,
Facility     INTEGER NOT NULL,
[Zone]       VARCHAR(100) NOT NULL,
Amount       MONEY NOT NULL
);

INSERT INTO GroupCriteria (OrderID, Distributor, Facility, [Zone], Amount) VALUES
(1,'ACME',123,'ABC',100),
(2,'ACME',123,'ABC',75),
(3,'Direct Parts',789,'XYZ',150),
(4,'Direct Parts',789,'XYZ',125);

SELECT  DENSE_RANK() OVER (ORDER BY Distributor, Facility, [Zone]) AS CriteriaID,
        OrderID,
        Distributor,
        Facility,
        [Zone],
        Amount
FROM    GroupCriteria;
