-- Puzzle 39 - Prime Numbers
--

-- A prime number is a natural number greater than one that has no positive divisors other than one and itself.

-- Write an SQL statement to determine which of the integers provided in the following DDL statement are prime numbers.

CREATE TABLE PrimeNumbers
(
    IntegerValue INTEGER PRIMARY KEY
);

INSERT INTO PrimeNumbers VALUES
(1),(2),(3),(4),(5),(6),(7),(8),(9),(10);

-- Here is the expected output.

/*
| Integer Value |
|---------------|
| 2             |
| 3             |
| 5             |
| 7             |
*/


-- ==================================================
-- Solution for Puzzle 39
-- ==================================================

DROP TABLE IF EXISTS PrimeNumbers;

CREATE TABLE PrimeNumbers
(
IntegerValue  INTEGER PRIMARY KEY
);

INSERT INTO PrimeNumbers (IntegerValue) VALUES
(1),(2),(3),(4),(5),(6),(7),(8),(9),(10);

SELECT  IntegerValue
FROM    PrimeNumbers p
WHERE   IntegerValue > 1
AND NOT EXISTS (
    SELECT  1
    FROM    PrimeNumbers d
    WHERE   d.IntegerValue > 1
      AND   d.IntegerValue < p.IntegerValue
      AND   p.IntegerValue % d.IntegerValue = 0
);
