-- Puzzle 51 - Primary Key Creation
--

-- Given the following table, whose natural key is a combination of the columns `Assembly ID` and `Part`, use the `HASHBYTES` and `CHECKSUM` functions to create two new columns that can be used as primary keys.

-- The goal here is to create a single column that is unique and re-creatable. The benefit of creating a hashbytes or checksum column is to aid in data profiling and integrity checks when a table contains a multitude of columns that form the natural key (and some of these columns can be NULL).

/*
| Assembly ID |  Part  |
|-------------|--------|
| 1001        | Bolt   |
| 1001        | Screw  |
| 2002        | Nut    |
| 2002        | Washer |
| 3003        | Toggle |
| 3003        | Bolt   |
*/


-- ==================================================
-- Solution for Puzzle 51
-- ==================================================

DROP TABLE IF EXISTS Assembly;

CREATE TABLE Assembly
(
AssemblyID  INTEGER,
Part        VARCHAR(100),
PRIMARY KEY (AssemblyID, Part)
);

INSERT INTO Assembly (AssemblyID, Part) VALUES
(1001,'Bolt'),(1001,'Screw'),(2002,'Nut'),
(2002,'Washer'),(3003,'Toggle'),(3003,'Bolt');

SELECT  HASHBYTES('SHA2_512',CONCAT(AssemblyID, Part)) AS ExampleUniqueID1,
        CHECKSUM(CONCAT(AssemblyID, Part)) AS ExampleUniqueID12,
        AssemblyID,
        Part
FROM    Assembly;
