-- Advanced SQL Challenge: Time to First Purchase (Xometry Interview)
-- Difficulty: Senior

/*
Problem Statement:
You are tasked with analyzing the journey from registration to a user's first purchase. 
The business wants to understand how this journey differs across product categories to 
better target marketing efforts.

Your final goal is to write a single query that produces a summary report showing, 
for each product category:
1. the average time (in days) it takes for a user from registration to make their first purchase in that category.
2. how many distinct users made their first-ever purchase in that category.

Example Input (users):
| user_id | registration_date | country |
|---------|-------------------|---------|
| 101     | 2025-01-15        | USA     |
| 102     | 2025-02-20        | USA     |
| 103     | 2025-03-01        | Canada  |

Example Input (products):
| product_id | product_name     | category    | price  |
|------------|------------------|-------------|--------|
| 1          | Quantum Keyboard | Electronics | 150.00 |
| 2          | Photon Mouse     | Electronics | 75.50  |
| 3          | Gravity Chair    | Furniture   | 350.00 |
| 4          | Tesseract Desk   | Furniture   | 800.00 |

Example Input (events - simplified):
User 101 buys Electronics on Jan 22, buys Furniture on May 11
User 103 buys Furniture on Mar 01

Expected Output:
| category    | users | avg_day_to_first_purchase |
|-------------|-------|---------------------------|
| Electronics | 1     | 7.0000                    |
| Furniture   | 2     | 58.0000                   |

Schema & DML Data:
*/
USE practice_sql_db;

DROP TABLE IF EXISTS events;

DROP TABLE IF EXISTS products;

DROP TABLE IF EXISTS users;

-- User information table
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    registration_date DATE,
    country VARCHAR(50)
);

-- Product catalog table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);

-- Core events table, linking users and products
CREATE TABLE events (
    event_id INT PRIMARY KEY,
    user_id INT,
    event_name VARCHAR(50),
    event_time TIMESTAMP,
    product_id INT -- Can be NULL for non-product events like 'page_view'
);

-- Insert sample data
INSERT INTO
    users (
        user_id,
        registration_date,
        country
    )
VALUES (101, '2025-01-15', 'USA'),
    (102, '2025-02-20', 'USA'),
    (103, '2025-03-01', 'Canada');

INSERT INTO
    products (
        product_id,
        product_name,
        category,
        price
    )
VALUES (
        1,
        'Quantum Keyboard',
        'Electronics',
        150.00
    ),
    (
        2,
        'Photon Mouse',
        'Electronics',
        75.50
    ),
    (
        3,
        'Gravity Chair',
        'Furniture',
        350.00
    ),
    (
        4,
        'Tesseract Desk',
        'Furniture',
        800.00
    );

INSERT INTO
    events (
        event_id,
        user_id,
        event_name,
        event_time,
        product_id
    )
VALUES
    -- User 101's journey: browses, then first purchase is Electronics
    (
        1,
        101,
        'page_view',
        '2025-01-20 10:00:00',
        NULL
    ),
    (
        2,
        101,
        'view_product',
        '2025-01-20 10:05:00',
        1
    ),
    (
        3,
        101,
        'add_to_cart',
        '2025-01-20 10:06:00',
        1
    ),
    (
        4,
        101,
        'purchase',
        '2025-01-22 11:00:00',
        1
    ), -- First purchase in Electronics
    (
        5,
        101,
        'view_product',
        '2025-03-10 12:00:00',
        2
    ),
    (
        6,
        101,
        'purchase',
        '2025-03-11 09:30:00',
        2
    ), -- Second purchase in Electronics
    (
        7,
        101,
        'view_product',
        '2025-05-10 12:00:00',
        3
    ),
    (
        8,
        101,
        'add_to_cart',
        '2025-05-11 10:06:00',
        3
    ),
    (
        9,
        101,
        'purchase',
        '2025-05-11 10:30:00',
        3
    ), -- First purchase in Furniture
    -- User 102's journey: browses, no purchase yet
    (
        10,
        102,
        'page_view',
        '2025-02-25 14:00:00',
        NULL
    ),
    (
        11,
        102,
        'view_product',
        '2025-02-25 14:05:00',
        3
    ),
    -- User 103's journey: quick first purchase of Furniture
    (
        12,
        103,
        'view_product',
        '2025-03-01 18:00:00',
        4
    ),
    (
        13,
        103,
        'purchase',
        '2025-03-01 18:05:00',
        4
    );
-- First purchase in Furniture

-- ==========================================
-- Your Sol
-- ==========================================

with
    base as (
        SELECT a.*, p.category, b.registration_date, ROW_NUMBER() OVER (
                PARTITION BY
                    category, user_id
                ORDER BY event_time
            ) as user_p_rank
        FROM events a
            LEFT JOIN users b using (user_id)
            LEFT JOIN products p using (product_id)
        WHERE
            event_name = 'purchase'
    )
    --
SELECT
    category,
    Avg(
        DATEDIFF(
            DATE(event_time),
            registration_date
        )
    ) Avg_purchase_days,
    COUNT(DISTINCT user_id) users
FROM base
WHERE
    user_p_rank = 1
GROUP BY 1

-- ==========================================
-- Solutions Provided
-- ==========================================

WITH
    purchase AS (
        SELECT u.user_id, u.registration_date, p.category, e.event_time, ROW_NUMBER() OVER (
                PARTITION BY
                    p.category, u.user_id
                ORDER BY e.event_time ASC
            ) as rn
        FROM
            events e
            LEFT JOIN users u ON e.user_id = u.user_id
            LEFT JOIN products p ON e.product_id = p.product_id
        WHERE
            e.event_name = 'purchase'
    ),
    first_purchase AS (
        SELECT *,
            -- Calculate diff in days. Note: Original solution used PG syntax (e.event_time::date - registration_date::date)
            DATEDIFF(
                DATE(event_time), registration_date
            ) AS days_diff
        FROM purchase
        WHERE
            rn = 1
    )
SELECT
    category,
    COUNT(DISTINCT user_id) AS users,
    AVG(days_diff) AS avg_day_to_first_purchase
FROM first_purchase
GROUP BY
    category;