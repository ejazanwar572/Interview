-- Advanced SQL Challenge: Unpivot Monthly Revenue Data
-- Difficulty: Senior

/*
Problem Statement:
You receive a messy, wide dataset where monthly revenue is stored in separate 
columns (e.g., `jan_rev`, `feb_rev`, `mar_rev`). 

Write a query to 'unpivot' or normalize this data into a long, analytical format 
with exactly 3 columns:
`store_id`, `month_name`, `revenue`

Note: Only some databases natively support the UNPIVOT command. You should know 
how to solve this universally using a standard SQL approach (UNION ALL or CROSS JOIN).

Schema & DML Data:
*/
USE practice_sql_db;

DROP TABLE IF EXISTS MessyRevenue;

CREATE TABLE MessyRevenue (
    store_id INT,
    jan_rev DECIMAL(10, 2),
    feb_rev DECIMAL(10, 2),
    mar_rev DECIMAL(10, 2)
);

INSERT INTO
    MessyRevenue (
        store_id,
        jan_rev,
        feb_rev,
        mar_rev
    )
VALUES (
        101,
        15000.00,
        16000.00,
        15500.00
    ),
    (
        102,
        8000.00,
        8100.00,
        7500.00
    ),
    (
        103,
        20000.00,
        22000.00,
        25000.00
    );

-- ==========================================
-- Your Sol
-- ==========================================

-- ==========================================
-- Solutions Provided
-- ==========================================

/*
-- Universal Standard Approach (Compatible with MySQL, PostgreSQL, etc)
SELECT store_id, 'Jan' AS month_name, jan_rev AS revenue FROM MessyRevenue
UNION ALL
SELECT store_id, 'Feb' AS month_name, feb_rev AS revenue FROM MessyRevenue
UNION ALL
SELECT store_id, 'Mar' AS month_name, mar_rev AS revenue FROM MessyRevenue
ORDER BY store_id, month_name;


-- Alternative: Native UNPIVOT (works in SQL Server, Snowflake, Oracle)
-- SELECT 
--     store_id, 
--     month_name, 
--     revenue
-- FROM MessyRevenue
-- UNPIVOT (
--     revenue 
--     FOR month_name IN (jan_rev AS 'Jan', feb_rev AS 'Feb', mar_rev AS 'Mar')
-- ) AS UnpivotedTable;
*/