-- Puzzle 65 - Home Listings
--

-- You are presented with a dataset of home listings, each with a unique `Home ID` and a `Status`. Your objective is to assign a grouping key to each record based on specific conditions. A new grouping key should be initiated whenever a record is in the status `New Listing` or `Relisted`. Each subsequent record, following either of these statuses, should inherit the same grouping key until the next occurrence of `New Listing` or `Relisted`.

/*
| Listing ID | Home ID |     Status     |
|------------|---------|----------------|
| 1          | Home A  | New Listing    |
| 2          | Home A  | Pending        |
| 3          | Home A  | Relisted       |
| 4          | Home B  | New Listing    |
| 5          | Home B  | Under Contract |
| 6          | Home B  | Relisted       |
| 7          | Home C  | New Listing    |
| 8          | Home C  | Under Contract |
| 9          | Home C  | Closed         |
*/

-- Here is the expected output.

/*
| Listing ID | Home ID |     Status     | Grouping ID |
|------------|---------|----------------|-------------|
| 1          | Home A  | New Listing    | 1           |
| 2          | Home A  | Pending        | 1           |
| 3          | Home A  | Relisted       | 2           |
| 4          | Home B  | New Listing    | 3           |
| 5          | Home B  | Under Contract | 3           |
| 6          | Home B  | Relisted       | 4           |
| 7          | Home C  | New Listing    | 5           |
| 8          | Home C  | Under Contract | 5           |
| 9          | Home C  | Closed         | 5           |
*/


-- ==================================================
-- Solution for Puzzle 65
-- ==================================================

DROP TABLE IF EXISTS HomeListings;

CREATE TABLE HomeListings
(
ListingID  INTEGER PRIMARY KEY,
HomeID     VARCHAR(100),
[Status]     VARCHAR(100)
);

INSERT INTO HomeListings (ListingID, HomeID, [Status]) VALUES 
(1, 'Home A', 'New Listing'),
(2, 'Home A', 'Pending'),
(3, 'Home A', 'Relisted'),
(4, 'Home B', 'New Listing'),
(5, 'Home B', 'Under Contract'),
(6, 'Home B', 'Relisted'),
(7, 'Home C', 'New Listing'),
(8, 'Home C', 'Under Contract'),
(9, 'Home C', 'Closed');

WITH cte_Case AS
(
SELECT  *,
        (CASE WHEN Status IN ('New Listing', 'Relisted') THEN 1 END) AS IsNewOrRelisted
FROM    HomeListings
)
SELECT  ListingID, HomeID, Status,
        SUM(IsNewOrRelisted) OVER (ORDER BY ListingID) AS GroupingID
FROM    cte_Case;
