-- Puzzle 36 - Traveling Salesman
--

-- Here is a well-known problem known as the Traveling Salesman.

-- Write an SQL statement that shows all the possible routes from Austin to Des Moines. Which route is the most expensive? Which route is the least expensive?

-- Note that the data represents a cyclic graph.

/*
| Route ID | Departure City | Arrival City | Cost |
|----------|----------------|--------------|------|
| 1        | Austin         | Dallas       | 100  |
| 2        | Dallas         | Memphis      | 200  |
| 3        | Memphis        | Des Moines   | 300  |
| 4        | Dallas         | Des Moines   | 400  |
*/

-- Here is the expected output.

/*
| Route Path                                   | Total Cost |
|----------------------------------------------|------------|
| Austin --> Dallas --> Des Moines             | 500        |
| Austin --> Dallas --> Memphis --> Des Moines | 600        |
*/


-- ==================================================
-- Solution for Puzzle 36
-- ==================================================

DROP TABLE IF EXISTS Routes;

CREATE TABLE Routes
(
RouteID        INTEGER NOT NULL,
DepartureCity  VARCHAR(30) NOT NULL,
ArrivalCity    VARCHAR(30) NOT NULL,
Cost           MONEY NOT NULL,
PRIMARY KEY (DepartureCity, ArrivalCity)
);

INSERT INTO Routes (RouteID, DepartureCity, ArrivalCity, Cost) VALUES
(1,'Austin','Dallas',100),
(2,'Dallas','Memphis',200),
(3,'Memphis','Des Moines',300),
(4,'Dallas','Des Moines',400);

--Solution 1
--Recursion
DROP TABLE IF EXISTS TravelingSalesman;

WITH cte_Map (Nodes, LastNode, NodeMap, Cost) AS 
(
SELECT  2 AS Nodes,
        ArrivalCity,
        CAST('\' + DepartureCity + '\' + ArrivalCity + '\' AS VARCHAR(MAX)) AS NodeMap,
        Cost
FROM    Routes
WHERE   DepartureCity = 'Austin'
UNION ALL
SELECT  m.Nodes + 1 AS Nodes,
        r.ArrivalCity AS LastNode,
        CAST(m.NodeMap + r.ArrivalCity + '\' AS VARCHAR(MAX)) AS NodeMap,
        m.Cost + r.Cost AS Cost
FROM    cte_Map AS m INNER JOIN
        Routes AS r ON r.DepartureCity = m.LastNode
WHERE   m.NodeMap NOT LIKE '\%' + r.ArrivalCity + '%\'
)
SELECT  NodeMap, Cost
INTO    TravelingSalesman
FROM    cte_Map
;

WITH cte_LeftReplace AS
(
SELECT  LEFT(NodeMap,LENGTH(NodeMap)-1) AS RoutePath,
        Cost
FROM    TravelingSalesman
WHERE   RIGHT(NodeMap,11) = 'Des Moines\'
),
cte_RightReplace AS
(
SELECT  SUBSTRING(RoutePath,2,LENGTH(RoutePath)-1) AS RoutePath,
        Cost
FROM    cte_LeftReplace
)
SELECT  REPLACE(RoutePath,'\', ' -->') AS RoutePath,
        Cost AS TotalCost
FROM    cte_RightReplace;

--Solution 2
--WHILE Loop
DROP TABLE IF EXISTS RoutesList;

CREATE TABLE RoutesList
(
InsertDate      DATETIME DEFAULT NOW() NOT NULL,
RouteInsertID   INTEGER NOT NULL,
RoutePath       VARCHAR(8000) NOT NULL,
TotalCost       MONEY NOT NULL,
LastArrival     VARCHAR(100)
);

INSERT INTO RoutesList (RouteInsertID, RoutePath, TotalCost, LastArrival)
SELECT  1,
        CONCAT(DepartureCity,',',ArrivalCity),
        Cost,
        ArrivalCity
FROM    Routes
WHERE   DepartureCity = 'Austin';

DECLARE @vRowCount INTEGER = 1;
DECLARE @vRouteInsertID INTEGER = 2;

WHILE @vRowCount >= 1
BEGIN

     WITH cte_LastArrival AS
     (
     SELECT   RoutePath
             ,TotalCost
             ,REVERSE(SUBSTRING(REVERSE(RoutePath),0,INSTR(',REVERSE(RoutePath, ')))) AS LastArrival
     FROM    RoutesList
     WHERE   LastArrival <> 'Des Moines'
     )
     INSERT INTO RoutesList (RouteInsertID, RoutePath, TotalCost, LastArrival)
     SELECT  @vRouteInsertID
             ,CONCAT(a.RoutePath,',',b.ArrivalCity)
             ,a.TotalCost + b.Cost
             ,b.ArrivalCity
     FROM    cte_LastArrival a INNER JOIN
             Routes b ON a.LastArrival = b.DepartureCity AND INSTR(RoutePath, b.ArrivalCity) = 0;

     SET @vRowCount = @@ROWCOUNT;

     DELETE  RoutesList
     WHERE   RouteInsertID < @vRouteInsertID
             AND LastArrival <> 'Des Moines';

     SET @vRouteInsertID = @vRouteInsertID + 1;
END;

SELECT  REPLACE(RoutePath,',',' --> ') AS RoutePath,
        TotalCost
FROM    RoutesList
ORDER BY 1;
