-- Puzzle 75 - Symmetric Matches
--

-- Write an SQL statement to determine which boxes have the same dimensions.

/*
| Box ID | Length | Width | Height |
|--------|--------|-------|--------|
| A      | 10     | 25    | 15     |
| B      | 15     | 10    | 25     |
| C      | 10     | 16    | 24     |
*/

-- Here is the expected output.

/*
| Box ID | Grouping ID |
|--------|-------------|
| A      | 1           |
| B      | 1           |
| C      | 2           |
*/


-- ==================================================
-- Solution for Puzzle 75
-- ==================================================

DROP TABLE IF EXISTS Boxes;

CREATE TABLE Boxes 
(
Box      CHAR(1) PRIMARY KEY,
[Length] INTEGER,
Width    INTEGER,
Height   INTEGER
);

INSERT INTO Boxes (Box, [Length], Width, Height) VALUES
('A', 10, 25, 15),
('B', 15, 10, 25),
('C', 10, 16, 24);


WITH cte_StringAgg AS 
(
SELECT  Box,
        -- Use CROSS JOIN LATERAL to unpivot and then re-/* MySQL_Conversion_Warning: PIVOT not supported. Use CASE/Aggregation. */ pivot sorted dimensions
        GROUP_CONCAT(CAST(value AS VARCHAR(10)) ORDER BY value SEPARATOR ',') AS SortedDims 
FROM    Boxes CROSS JOIN LATERAL 
        (VALUES ([Length]), (Width), (Height)) AS D(value)
GROUP BY Box
),
cte_GroupID AS 
(
SELECT  DISTINCT 
        SortedDims,
        DENSE_RANK() OVER (ORDER BY SortedDims) AS GroupingID
FROM    cte_StringAgg
)
SELECT  n.Box,
        g.GroupingID
FROM    cte_StringAgg n INNER JOIN 
        cte_GroupID g ON n.SortedDims = g.SortedDims
ORDER BY n.Box;
