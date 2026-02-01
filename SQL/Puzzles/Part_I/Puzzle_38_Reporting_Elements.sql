-- Puzzle 38 - Reporting Elements
--

-- You must provide a report of all distributors and their sales by region. If a distributor had no sales for a region, provide a zero-dollar value for that day. Assume there is at least one sale for each region.

/*
| Region | Distributor | Sales |
|--------|-------------|-------|
| North  | ACE         | 10    |
| South  | ACE         | 67    |
| East   | ACE         | 54    |
| North  | ACME        | 65    |
| South  | ACME        | 9     |
| East   | ACME        | 1     |
| West   | ACME        | 7     |
| North  | Direct Parts| 8     |
| South  | Direct Parts| 7     |
| West   | Direct Parts| 12    |
*/

-- Here is the expected output.

/*
| Region |  Distributor | Sales |
|--------|--------------|-------|
| North  | ACE          | 10    |
| South  | ACE          | 67    |
| East   | ACE          | 54    |
| West   | ACE          | 0     |
| North  | ACME         | 65    |
| South  | ACME         | 9     |
| East   | ACME         | 1     |
| West   | ACME         | 7     |
| North  | Direct Parts | 8     |
| South  | Direct Parts | 7     |
| East   | Direct Parts | 0     |
| West   | Direct Parts | 12    |
*/

-- - In the result set, `ACE` and `Direct Parts` each have a fabricated record with `0` sales.


-- ==================================================
-- Solution for Puzzle 38
-- ==================================================

DROP TABLE IF EXISTS RegionSales;

CREATE TABLE RegionSales
(
Region       VARCHAR(100),
Distributor  VARCHAR(100),
Sales        INTEGER NOT NULL,
PRIMARY KEY (Region, Distributor)
);

INSERT INTO RegionSales (Region, Distributor, Sales) VALUES
('North','ACE',10),
('South','ACE',67),
('East','ACE',54),
('North','ACME',65),
('South','ACME',9),
('East','ACME',1),
('West','ACME',7),
('North','Direct Parts',8),
('South','Direct Parts',7),
('West','Direct Parts',12);

WITH cte_DistinctRegion AS
(
SELECT  DISTINCT Region
FROM    RegionSales
),
cte_DistinctDistributor AS
(
SELECT  DISTINCT Distributor
FROM    RegionSales
),
cte_CrossJoin AS
(
SELECT  Region, Distributor
FROM    cte_DistinctRegion a CROSS JOIN
        cte_DistinctDistributor b
)
SELECT  a.Region,
        a.Distributor,
        IFNULL(b.Sales,0) AS Sales
FROM    cte_CrossJoin a LEFT OUTER JOIN
        RegionSales b ON a.Region = b.Region and a.Distributor = b.Distributor
ORDER BY a.Distributor,
        (CASE a.Region  WHEN 'North' THEN 1
                        WHEN 'South' THEN 2
                        WHEN 'East'  THEN 3
                        WHEN 'West'  THEN 4 END);
