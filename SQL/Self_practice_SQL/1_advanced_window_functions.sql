USE practice_sql_db;

-- =============================================
-- SECTION 1: Advanced Window Functions
-- =============================================
/*
OBJECTIVE:
Master ranking, frame specifications (moving averages), and Lead/Lag for growth calculations.

PROBLEMS:
1. Top N per Group (Dense Rank):
- Find the top 2 highest paid employees in EACH department.
- Use DENSE_RANK() so ties are handled and no ranks are skipped.

2. Moving Average (Frame Spec):
- Calculate a 3-day moving average of 'daily_revenue' for the company.
- Use 'ROWS BETWEEN 2 PRECEDING AND CURRENT ROW'.

3. Year-over-Year Growth (Lag):
- Calculate the percentage growth of revenue compared to the previous year.
- Formula: ((Current - Previous) / Previous) * 100
*/

-- ---------------------------------------------
-- Write your queries below:
-- ---------------------------------------------

-- 1. Top 2 Employees per Dept

-- 2. 3-Day Moving Average Revenue

-- 3. YoY Revenue Growth

-- =============================================
-- DDL: RESTORE TABLES (Run this block first)
-- =============================================
DROP TABLE IF EXISTS employees;

DROP TABLE IF EXISTS daily_revenue;

DROP TABLE IF EXISTS yearly_revenue;

-- 1. Employees Table
CREATE TABLE employees (
    emp_id INT,
    emp_name VARCHAR(50),
    dept_id INT,
    salary INT
);

INSERT INTO
    employees
VALUES (1, 'Alice', 101, 80000),
    (2, 'Bob', 101, 75000),
    (3, 'Charlie', 101, 80000), -- Tie with Alice
    (4, 'David', 101, 60000),
    (5, 'Eve', 102, 90000),
    (6, 'Frank', 102, 85000),
    (7, 'Grace', 102, 95000);

-- 2. Daily Revenue Table
CREATE TABLE daily_revenue (
    date DATE,
    revenue DECIMAL(10, 2)
);

INSERT INTO
    daily_revenue
VALUES ('2023-01-01', 100.00),
    ('2023-01-02', 120.00),
    ('2023-01-03', 110.00),
    ('2023-01-04', 130.00),
    ('2023-01-05', 140.00),
    ('2023-01-06', 150.00);

-- 3. Yearly Revenue Table
CREATE TABLE yearly_revenue (
    year INT,
    revenue DECIMAL(15, 2)
);

INSERT INTO
    yearly_revenue
VALUES (2020, 500000.00),
    (2021, 550000.00),
    (2022, 600000.00),
    (2023, 580000.00);
-- Dip in revenue