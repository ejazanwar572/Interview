/*
### Problem Description
Find all missing dates in a continuous date range. You are given a `Sales` table. Find every date between the minimum and maximum dates present in the `Sales` table where no sale occurred.

### Sample Input and Output
**Input: Sales**
| sale_id | sale_date |
|---|---|
| 1 | '2024-01-01' |
| 2 | '2024-01-02' |
| 3 | '2024-01-05' |
| 4 | '2024-01-06' |

**Output:**
| missing_date |
|---|
| '2024-01-03' |
| '2024-01-04' |
*/

-- DDL and DML commands
DROP TABLE IF EXISTS Sales;
CREATE TABLE Sales (
    sale_id INT,
    sale_date DATE
);

INSERT INTO Sales (sale_id, sale_date) VALUES
(1, '2024-01-01'),
(2, '2024-01-02'),
(3, '2024-01-05'),
(4, '2024-01-06');


/*
### Approach
When dealing with "missing" sequences (dates or numbers), the canonical approach is dynamically generating the expected sequence using a Recursive Common Table Expression (CTE) and then using a bounded `LEFT JOIN` (or `EXCEPT` or `NOT IN`) to find what's missing.
1. Find the `MIN` and `MAX` date of the actual dataset.
2. Initialize a Recursive CTE starting at the `MIN` date, adding 1 day recursively until it hits the `MAX` date.
3. Left join this generated full calendar against the `Sales` table on the date column.
4. Filter out any rows where the join returned `NULL`.
*/










-- Optimized Solution
WITH RECURSIVE DateRange AS (
    -- Anchor member
    SELECT MIN(sale_date) AS calendar_date
    FROM Sales
    
    UNION ALL
    
    -- Recursive member
    SELECT DATE_ADD(calendar_date, INTERVAL 1 DAY)
    FROM DateRange
    WHERE calendar_date < (SELECT MAX(sale_date) FROM Sales)
)
-- Selecting only dates from our continuous sequence that are NOT in the original table
SELECT dr.calendar_date AS missing_date
FROM DateRange dr
LEFT JOIN Sales s ON dr.calendar_date = s.sale_date
WHERE s.sale_date IS NULL
ORDER BY dr.calendar_date;

/*
-- Note: 'DATE_ADD' is common in MySQL. For PostgreSQL, it's 'calendar_date + INTERVAL '1 day''.
*/
