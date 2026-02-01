-- Puzzle 66 - Matching Parts
--

-- You are working with a dataset of manufactured parts, each having a unique serial number and categorized as either a bolt, washer, or nut. The challenge is to group these parts into sets based on their manufacture date, ensuring that the earliest manufactured parts are grouped first.

/*
| Serial  | Manufacture Day | Product |
|---------|------------------|---------|
| A111    | 1                | Bolt    |
| B111    | 3                | Bolt    |
| C111    | 5                | Bolt    |
| D222    | 2                | Washer  |
| E222    | 4                | Washer  |
| F222    | 6                | Washer  |
| G333    | 3                | Nut     |
| H333    | 5                | Nut     |
| I333    | 7                | Nut     |
*/

-- Here is the expected output.

/*
| Bolt | Washer |  Nut |
|------|--------|------|
| A111 | D222   | G333 |
| B111 | E222   | H333 |
| C111 | F222   | I333 |
*/


-- ==================================================
-- Solution for Puzzle 66
-- ==================================================

DROP TABLE IF EXISTS Parts;

CREATE TABLE Parts
(
SerialNumber    VARCHAR(100) PRIMARY KEY,
ManufactureDay  INTEGER,
Product         VARCHAR(100)
);

INSERT INTO Parts (SerialNumber, ManufactureDay, Product) VALUES
('A111', 1, 'Bolt'),
('B111', 3, 'Bolt'),
('C111', 5, 'Bolt'),
('D222', 2, 'Washer'),
('E222', 4, 'Washer'),
('F222', 6, 'Washer'),
('G333', 3, 'Nut'),
('H333', 5, 'Nut'),
('I333', 7, 'Nut');

WITH cte_RowNumber AS
(
SELECT  ROW_NUMBER() OVER (PARTITION BY Product ORDER BY ManufactureDay) AS RowNumber,
        *
FROM    Parts
)
SELECT  a.SerialNumber AS Bolt,
        b.SerialNumber AS Washer,
        c.SerialNumber AS Nut
FROM    (SELECT * FROM cte_RowNumber WHERE Product = 'Bolt') a INNER JOIN
        (SELECT * FROM cte_RowNumber WHERE Product = 'Washer') b ON a.RowNumber = b.RowNumber INNER JOIN
        (SELECT * FROM cte_RowNumber WHERE Product = 'Nut') c ON a.RowNumber = c.RowNumber;
