/*
Problem Description:
Find the longest consecutive purchase streak (in days) for each user. If a user purchased items on '2023-10-01', '2023-10-02', and '2023-10-03', their streak is 3.

Sample Input:
user_purchases table:
+---------+---------------+
| user_id | purchase_date |
+---------+---------------+
| 1       | 2023-10-01    |
| 1       | 2023-10-02    |
| 1       | 2023-10-03    |
| 1       | 2023-10-06    |
| 1       | 2023-10-07    |
| 2       | 2023-10-05    |
| 2       | 2023-10-06    |
+---------+---------------+

Sample Output:
+---------+----------------+
| user_id | longest_streak |
+---------+----------------+
| 1       | 3              |
| 2       | 2              |
+---------+----------------+
*/

-- DDL and DML
DROP TABLE IF EXISTS user_purchases;
CREATE TABLE user_purchases (
    user_id INT,
    purchase_date DATE
);

INSERT INTO user_purchases (user_id, purchase_date) VALUES
(1, '2023-10-01'),
(1, '2023-10-02'),
(1, '2023-10-03'),
(1, '2023-10-06'),
(1, '2023-10-07'),
(2, '2023-10-05'),
(2, '2023-10-06');

/*
Problem Solving Approach:
1. Ensure distinct purchases to avoid duplicate dates for the same user on the same day.
2. Filter grouping: create an island group using `DATE_SUB(purchase_date, INTERVAL ROW_NUMBER() OVER(...) DAY)`.
3. Count the number of days in each island group per user.
4. Calculate the maximum streak length per user using `MAX(COUNT(*))`.
*/

-- Optimized Solution
WITH DistinctPurchases AS (
    SELECT DISTINCT user_id, purchase_date
    FROM user_purchases
),
GroupedStreaks AS (
    SELECT 
        user_id,
        purchase_date,
        DATE_SUB(purchase_date, INTERVAL ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY purchase_date) DAY) as grp_date
    FROM DistinctPurchases
),
StreakLengths AS (
    SELECT 
        user_id, 
        grp_date, 
        COUNT(*) as streak_length
    FROM GroupedStreaks
    GROUP BY user_id, grp_date
)
SELECT 
    user_id,
    MAX(streak_length) as longest_streak
FROM StreakLengths
GROUP BY user_id;
