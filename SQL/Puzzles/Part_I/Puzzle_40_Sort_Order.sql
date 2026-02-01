-- Puzzle 40 - Sort Order
--

-- Write an SQL statement that sorts the following values into the expected output. Can you find the most elegant solution?

/*
|   City    |
|-----------|
| Atlanta   |
| Baltimore |
| Chicago   |
| Denver    |
*/

-- Here is the expected output.

/*
| City      |
|-----------|
| Baltimore |
| Denver    |
| Atlanta   |
| Chicago   |
*/


-- ==================================================
-- Solution for Puzzle 40
-- ==================================================

DROP TABLE IF EXISTS SortOrder;

CREATE TABLE SortOrder
(
City  VARCHAR(100) PRIMARY KEY
);

INSERT INTO SortOrder (City) VALUES
('Atlanta'),('Baltimore'),('Chicago'),('Denver');

SELECT  City
FROM    SortOrder
ORDER BY (CASE City WHEN 'Atlanta' THEN 2
                    WHEN 'Baltimore' THEN 1
                    WHEN 'Chicago' THEN 4
                    WHEN 'Denver' THEN 1 END);
