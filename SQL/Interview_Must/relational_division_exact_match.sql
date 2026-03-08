/*
================================================================================
Problem: Relational Division (Exact Category Match)
================================================================================
Difficulty: Hard
Pattern: Relational Division, Aggregation, HAVING COUNT(DISTINCT)

Description:
You operate an e-commerce store with tables for `products` and `purchases`.
Write a query to find the `user_id` of all customers who have purchased 
EVERY single product available within the 'Electronics' category.

Customers who bought only *some* electronics should not be included.
Customers who bought electronics AND other categories should be included, 
as long as they bought ALL available electronics.

Return the result sorted by `user_id` in ascending order.

================================================================================
Input constraints / Data examples:
================================================================================
Table: products
+------------+--------------+-------------+
| product_id | product_name | category    |
+------------+--------------+-------------+
| 101        | Laptop       | Electronics |
| 102        | Smartphone   | Electronics |
| 103        | Headphones   | Electronics |
| 104        | Desk Chair   | Furniture   |
| 105        | Coffee Mug   | Kitchen     |
+------------+--------------+-------------+

Table: purchases
+-------------+---------+------------+
| purchase_id | user_id | product_id |
+-------------+---------+------------+
| 1           | 1       | 101        | -- User 1 bought Laptop
| 2           | 1       | 102        | -- User 1 bought Smartphone
| 3           | 1       | 103        | -- User 1 bought Headphones (Got all 3!)
| 4           | 1       | 104        | -- User 1 bought Furniture (Doesn't matter)
| 5           | 2       | 101        | -- User 2 only bought Laptop
| 6           | 2       | 104        | 
| 7           | 3       | 101        | 
| 8           | 3       | 102        | 
+-------------+---------+------------+

Expected Output:
+---------+
| user_id |
+---------+
| 1       |
+---------+
*/

/*
================================================================================
DDL & DML (For Testing)
================================================================================

CREATE TABLE products_rd (
    product_id INT,
    product_name VARCHAR(50),
    category VARCHAR(50)
);

CREATE TABLE purchases_rd (
    purchase_id INT,
    user_id INT,
    product_id INT
);

INSERT INTO products_rd (product_id, product_name, category) VALUES
(101, 'Laptop', 'Electronics'),
(102, 'Smartphone', 'Electronics'),
(103, 'Headphones', 'Electronics'),
(104, 'Desk Chair', 'Furniture'),
(105, 'Coffee Mug', 'Kitchen'),
(106, 'Monitor', 'Electronics'); -- Added a 4th electronic to make it harder

INSERT INTO purchases_rd (purchase_id, user_id, product_id) VALUES
(1, 1, 101),
(2, 1, 102),
(3, 1, 103),
(4, 1, 106),  -- User 1 has all 4 Electronics
(5, 1, 104),  
(6, 2, 101),
(7, 2, 104),
(8, 3, 101),
(9, 3, 102),
(10, 3, 103), -- User 3 has 3/4 Electronics
(11, 4, 101),
(12, 4, 102),
(13, 4, 103),
(14, 4, 106), -- User 4 has all 4 Electronics
(15, 5, 105), -- User 5 only bought Kitchen stuff
(16, 6, 106);
*/

-- ==========================================
-- Your Solution Here
-- ==========================================





-- ==========================================
-- Provided Solution
-- ==========================================
/*
-- Solution 1: Using HAVING COUNT(DISTINCT)
SELECT 
    p.user_id
FROM purchases p
JOIN products pr 
    ON p.product_id = pr.product_id
WHERE pr.category = 'Electronics'
GROUP BY p.user_id
HAVING COUNT(DISTINCT p.product_id) = (
    SELECT COUNT(*) 
    FROM products 
    WHERE category = 'Electronics'
)
ORDER BY p.user_id;

-- Solution 2: Standard Relational Division (Not Exists approach)
-- "Find users where there does NOT exist an Electronics product 
-- that the user has NOT purchased."
SELECT DISTINCT u.user_id
FROM purchases u
WHERE NOT EXISTS (
    SELECT product_id 
    FROM products 
    WHERE category = 'Electronics'
    
    EXCEPT
    
    SELECT product_id 
    FROM purchases p 
    WHERE p.user_id = u.user_id
)
ORDER BY u.user_id;
*/
