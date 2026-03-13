/*
### Problem Description
Given a table of `signups` and a table of `purchases`, write a query to find the percentage of users who made a purchase within 7 days of signing up. Round the percentage to 2 decimal places.

### Sample Input and Output
**Input: signups**
| user_id | signup_date |
|---|---|
| 1 | '2024-01-01' |
| 2 | '2024-01-05' |
| 3 | '2024-01-10' |

**Input: purchases**
| purchase_id | user_id | purchase_date |
|---|---|---|
| 100 | 1 | '2024-01-05' |
| 101 | 2 | '2024-01-20' |

**Output:**
| conversion_rate |
|---|
| 33.33 |
*/

-- DDL and DML commands
DROP TABLE IF EXISTS signups;
CREATE TABLE signups (
    user_id INT,
    signup_date DATE
);

DROP TABLE IF EXISTS purchases;
CREATE TABLE purchases (
    purchase_id INT,
    user_id INT,
    purchase_date DATE
);

INSERT INTO signups (user_id, signup_date) VALUES
(1, '2024-01-01'),
(2, '2024-01-05'),
(3, '2024-01-10');

INSERT INTO purchases (purchase_id, user_id, purchase_date) VALUES
(100, 1, '2024-01-05'),
(101, 2, '2024-01-20');


/*
### Approach
We need to calculate two numbers: the total number of signups, and the number of signups that have a purchase within 7 days.
We can `LEFT JOIN` the purchases table to the signups table. 
Then, we can use an aggregation block `COUNT(CASE WHEN ...)` to count valid conversions, divided by the `COUNT(user_id)` of signups, multiplied by 100.
The datediff check ensures the purchase date is <= signup_date + 7 days.
*/










-- Optimized Solution
SELECT 
    ROUND(
        COUNT(DISTINCT CASE WHEN DATEDIFF(p.purchase_date, s.signup_date) BETWEEN 0 AND 7 THEN s.user_id END) * 100.0 
        / COUNT(DISTINCT s.user_id), 
    2) AS conversion_rate
FROM signups s
LEFT JOIN purchases p ON s.user_id = p.user_id;
