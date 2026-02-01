-- 1364. Number of Trusted Contacts of a Customer
-- Difficulty: Medium
-- Description:
-- Write an SQL query to find the following for each invoice_id:
-- - customer_name
-- - price
-- - contacts_cnt: the number of contacts of the customer associated with the invoice.
-- - trusted_contacts_cnt: the number of contacts of the customer associated with the invoice that are also customers (i.e., their email exists in the Customers table).
-- Return the result table ordered by invoice_id.
-- Schema:
-- Table: Customers
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | customer_id   | int     |
-- | customer_name | varchar |
-- | email         | varchar |
-- +---------------+---------+
-- customer_id is the primary key for this table.
-- 
-- Table: Contacts
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | user_id       | int     |
-- | contact_name  | varchar |
-- | contact_email | varchar |
-- +---------------+---------+
-- (user_id, contact_email) is the primary key for this table.
-- 
-- Table: Invoices
-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | invoice_id   | int     |
-- | price        | int     |
-- | user_id      | int     |
-- +--------------+---------+
-- invoice_id is the primary key for this table.
-- Example Input/Output:
-- Customers table:
-- +-------------+---------------+------------------+
-- | customer_id | customer_name | email            |
-- +-------------+---------------+------------------+
-- | 1           | Alice         | alice@leetcode.com |
-- | 2           | Bob           | bob@leetcode.com   |
-- | 13          | John          | john@leetcode.com  |
-- | 6           | Alex          | alex@leetcode.com  |
-- +-------------+---------------+------------------+
-- Contacts table:
-- +---------+--------------+------------------+
-- | user_id | contact_name | contact_email    |
-- +---------+--------------+------------------+
-- | 1       | Bob          | bob@leetcode.com   |
-- | 1       | John         | john@leetcode.com  |
-- | 1       | Jal          | jal@leetcode.com   |
-- | 2       | Omar         | omar@leetcode.com  |
-- | 2       | Meghan       | meghan@leetcode.com|
-- | 6       | Bob          | bob@leetcode.com   |
-- +---------+--------------+------------------+
-- Invoices table:
-- +------------+-------+---------+
-- | invoice_id | price | user_id |
-- +------------+-------+---------+
-- | 77         | 100   | 1       |
-- | 88         | 200   | 1       |
-- | 99         | 300   | 2       |
-- | 66         | 400   | 6       |
-- | 55         | 500   | 13      |
-- +------------+-------+---------+
-- Result table:
-- +------------+---------------+-------+--------------+----------------------+
-- | invoice_id | customer_name | price | contacts_cnt | trusted_contacts_cnt |
-- +------------+---------------+-------+--------------+----------------------+
-- | 55         | John          | 500   | 0            | 0                    |
-- | 66         | Alex          | 400   | 1            | 1                    |
-- | 77         | Alice         | 100   | 3            | 2                    |
-- | 88         | Alice         | 200   | 3            | 2                    |
-- | 99         | Bob           | 300   | 2            | 0                    |
-- +------------+---------------+-------+--------------+----------------------+
-- Solution:
SELECT
    i.invoice_id,
    c.customer_name,
    i.price,
    COUNT(con.contact_name) AS contacts_cnt,
    SUM(CASE WHEN cus_trusted.email IS NOT NULL THEN 1 ELSE 0 END) AS trusted_contacts_cnt
FROM
    Invoices i
    JOIN Customers c ON i.user_id = c.customer_id
    LEFT JOIN Contacts con ON c.customer_id = con.user_id
    LEFT JOIN Customers cus_trusted ON con.contact_email = cus_trusted.email
GROUP BY
    i.invoice_id,
    c.customer_name,
    i.price
ORDER BY
    i.invoice_id;
