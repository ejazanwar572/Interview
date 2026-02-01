-- Puzzle 1 - Shopping Carts
--

-- You are tasked with auditing two shopping carts.  

-- Write an SQL statement to transform the following tables into the expected output.  

-- **Cart 1**
/*
| Item  |
|-------|
| Sugar |
| Bread |
| Juice |
| Soda  |
| Flour |
*/

-- **Cart 2**
/*
| Item   |
|--------|
| Sugar  |
| Bread  |
| Butter |
| Cheese |
| Fruit  |
*/

-- Here is the expected output.

/*
| Item Cart 1 | Item Cart 2 |
|-------------|-------------|
| Sugar       | Sugar       |
| Bread       | Bread       |
| Juice       |             |
| Soda        |             |
| Flour       |             |
|             | Butter      |
|             | Cheese      |
|             | Fruit       |
*/


-- Solution
-- Solution for Puzzle 1: Shopping Carts
SELECT
    a.Item AS ItemCart1,
    b.Item AS ItemCart2
FROM Cart1 a
/* MySQL_Conversion_Warning: FULL OUTER JOIN not supported. Use LEFT JOIN UNION RIGHT JOIN. */ FULL OUTER JOIN Cart2 b ON a.Item = b.Item;


-- ==================================================
-- Solution for Puzzle 1
-- ==================================================

DROP TABLE IF EXISTS Cart1;
DROP TABLE IF EXISTS Cart2;

CREATE TABLE Cart1
(
Item  VARCHAR(100) PRIMARY KEY
);

CREATE TABLE Cart2
(
Item  VARCHAR(100) PRIMARY KEY
);

INSERT INTO Cart1 (Item) VALUES
('Sugar'),('Bread'),('Juice'),('Soda'),('Flour');

INSERT INTO Cart2 (Item) VALUES
('Sugar'),('Bread'),('Butter'),('Cheese'),('Fruit');

--Solution 1
--/* MySQL_Conversion_Warning: FULL OUTER JOIN not supported. Use LEFT JOIN UNION RIGHT JOIN. */ FULL OUTER JOIN
SELECT  a.Item AS ItemCart1,
        b.Item AS ItemCart2
FROM    Cart1 a /* MySQL_Conversion_Warning: FULL OUTER JOIN not supported. Use LEFT JOIN UNION RIGHT JOIN. */ FULL OUTER JOIN
        Cart2 b ON a.Item = b.Item;

--Solution 2
--LEFT JOIN, UNION and RIGHT JOIN
SELECT  a.Item AS Item1,
        b.Item AS Item2
FROM    Cart1 a 
        LEFT JOIN Cart2 b ON a.Item = b.Item
UNION
SELECT  a.Item AS Item1,
        b.Item AS Item2
FROM    Cart1 a 
        RIGHT JOIN Cart2 b ON a.Item = b.Item;

--Solution 3
--This solution does not use a /* MySQL_Conversion_Warning: FULL OUTER JOIN not supported. Use LEFT JOIN UNION RIGHT JOIN. */ FULL OUTER JOIN
SELECT  a.Item AS Item1,
        b.Item AS Item2
FROM    Cart1 a INNER JOIN
        Cart2 b ON a.Item = b.Item
UNION
SELECT  a.Item AS Item1,
        NULL AS Item2
FROM    Cart1 a
WHERE   a.Item NOT IN (SELECT b.Item FROM Cart2 b)
UNION
SELECT  NULL AS Item1, 
        b.Item AS Item2
FROM    Cart2 b
WHERE b.Item NOT IN (SELECT a.Item FROM Cart1 a)
ORDER BY 1,2;
