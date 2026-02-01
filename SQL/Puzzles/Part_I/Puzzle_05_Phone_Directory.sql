-- Puzzle 5 - Phone Directory
--

-- Your customer phone directory table allows individuals to set up a home, cellular, or work phone number.

-- Write an SQL statement to transform the following table into the expected output.

/*
| Customer ID | Type     | Phone Number |
|-------------|----------|--------------|
| 1001        | Cellular | 555-897-5421 |
| 1001        | Work     | 555-897-6542 |
| 1001        | Home     | 555-698-9874 |
| 2002        | Cellular | 555-963-6544 |
| 2002        | Work     | 555-812-9856 |
| 3003        | Cellular | 555-987-6541 |
*/

-- Here is the expected output.

/*
| Customer ID | Cellular    | Work         | Home         |
|-------------|-------------|--------------|--------------|
| 1001        | 555-897-5421| 555-897-6542 | 555-698-9874 |
| 2002        | 555-963-6544| 555-812-9856 |              |
| 3003        | 555-987-6541|              |              |
*/


-- Solution
-- Solution for Puzzle 5: Phone Directory
SELECT CustomerID,
       MAX(CASE WHEN Type = 'Cellular' THEN PhoneNumber END) AS Cellular,
       MAX(CASE WHEN Type = 'Work' THEN PhoneNumber END) AS Work,
       MAX(CASE WHEN Type = 'Home' THEN PhoneNumber END) AS Home
FROM PhoneDirectory
GROUP BY CustomerID;


-- ==================================================
-- Solution for Puzzle 5
-- ==================================================

DROP TABLE IF EXISTS PhoneDirectory;

CREATE TABLE PhoneDirectory
(
CustomerID   INTEGER,
[Type]       VARCHAR(100),
PhoneNumber  VARCHAR(12) NOT NULL,
PRIMARY KEY (CustomerID, [Type])
);

INSERT INTO PhoneDirectory (CustomerID, [Type], PhoneNumber) VALUES
(1001,'Cellular','555-897-5421'),
(1001,'Work','555-897-6542'),
(1001,'Home','555-698-9874'),
(2002,'Cellular','555-963-6544'),
(2002,'Work','555-812-9856'),
(3003,'Cellular','555-987-6541');

--Solution 1
--/* MySQL_Conversion_Warning: PIVOT not supported. Use CASE/Aggregation. */ PIVOT
SELECT  CustomerID,[Cellular],[Work],[Home]
FROM    PhoneDirectory /* MySQL_Conversion_Warning: PIVOT not supported. Use CASE/Aggregation. */ PIVOT
       (MAX(PhoneNumber) FOR [Type] IN ([Cellular],[Work],[Home])) AS PivotClause;

--Solution 2
--MAX and CASE
SELECT  CustomerID,
        MAX(CASE [Type] WHEN 'Cellular' THEN PhoneNumber END),
        MAX(CASE [Type] WHEN 'Work' THEN PhoneNumber END),
        MAX(CASE [Type] WHEN 'Home' THEN PhoneNumber END)
FROM    PhoneDirectory
GROUP BY CustomerID;

--Solution 3
--OUTER JOIN
WITH cte_Cellular AS
(
SELECT  CustomerID, PhoneNumber AS Cellular
FROM    PhoneDirectory
WHERE   [Type] = 'Cellular'
),
cte_Work AS
(
SELECT  CustomerID, PhoneNumber AS Work
FROM    PhoneDirectory
WHERE   [Type] = 'Work'
),
cte_Home AS
(
SELECT  CustomerID, PhoneNumber AS Home
FROM    PhoneDirectory
WHERE   [Type] = 'Home'
)
SELECT  a.CustomerID,
        b.Cellular,
        c.Work,
        d.Home
FROM    (SELECT DISTINCT CustomerID FROM PhoneDirectory) a LEFT OUTER JOIN
        cte_Cellular b ON a.CustomerID = b.CustomerID LEFT OUTER JOIN
        cte_Work c ON a.CustomerID = c.CustomerID LEFT OUTER JOIN
        cte_Home d ON a.CustomerID = d.CustomerID;

--Solution 4
--MAX
WITH cte_PhoneNumbers AS
(
SELECT  CustomerID,
        PhoneNumber AS Cellular,
        NULL AS work,
        NULL AS home
FROM    PhoneDirectory
WHERE   [Type] = 'Cellular'
UNION
SELECT  CustomerID,
        NULL Cellular,
        PhoneNumber AS Work,
        NULL home
FROM    PhoneDirectory
WHERE   [Type] = 'Work'
UNION
SELECT  CustomerID,
        NULL Cellular,
        NULL Work,
        PhoneNumber AS Home
FROM    PhoneDirectory
WHERE   [Type] = 'Home'
)
SELECT  CustomerID,
        MAX(Cellular),
        MAX(Work),
        MAX(Home)
FROM    cte_PhoneNumbers
GROUP BY CustomerID;
