-- Puzzle 10 - Mean, Median, Mode, and Range
--

-- - The **mean** is the average of all numbers (31.09).  
-- - The **median** is the middle number in a sequence of numbers (14).  
-- - The **mode** is the number that occurs most often within a set of numbers (10).  
-- - The **range** is the difference between the largest and smallest values in a set of numbers (85).  

-- Write an SQL statement to determine the mean, median, mode, and range of the set of integers provided in the following DDL statement.  

CREATE TABLE SampleData
(
IntegerValue INTEGER
);

INSERT INTO SampleData
VALUES (5),(6),(10),(10),(13),(14),(17),(20),(81),(90),(76);-- Solution
-- Solution for Puzzle 10: Mean, Median, Mode, and Range
SELECT
    AVG(IntegerValue) AS Mean,
    MAX(IntegerValue) - MIN(IntegerValue) AS Range,
    (SELECT IntegerValue FROM SampleData GROUP BY IntegerValue ORDER BY COUNT(*) DESC) AS Mode,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY IntegerValue) OVER () AS Median
FROM SampleData
LIMIT 1;
-- Note: Logic for Mode/Median may vary by SQL dialect (this uses T-SQL).


-- ==================================================
-- Solution for Puzzle 10
-- ==================================================

DROP TABLE IF EXISTS SampleData;

CREATE TABLE SampleData
(
IntegerValue  INTEGER NOT NULL
);

INSERT INTO SampleData (IntegerValue) VALUES
(5),(6),(10),(10),(13),(14),(17),(20),(81),(90),(76);--Median
SELECT
        ((SELECT IntegerValue
        FROM    (
                SELECT PERCENT IntegerValue
                FROM    SampleData
                ORDER BY IntegerValue
                ) a
        ORDER BY IntegerValue DESC) +  --Add the Two Together
        (SELECT TOP 1 IntegerValue
        FROM (
            SELECT  TOP 50 PERCENT IntegerValue
            FROM    SampleData
            ORDER BY IntegerValue DESC
            ) a
        ORDER BY IntegerValue ASC)
        ) * 1.0 /2 AS Median
LIMIT 1
LIMIT 50;

--Mean and Range
SELECT  AVG(IntegerValue) AS Mean,
        MAX(IntegerValue) - MIN(IntegerValue) AS [Range]
FROM    SampleData;--Mode
SELECT IntegerValue AS Mode,
        COUNT(*) AS ModeCount
FROM    SampleData
GROUP BY IntegerValue
ORDER BY ModeCount DESC
LIMIT 1;
