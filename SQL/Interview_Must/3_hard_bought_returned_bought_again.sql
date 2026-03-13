/*
### Problem Description
Given a table of customer `Transactions`, find users who exhibited the following sequence: they bought an item (action = 'purchase'), then returned it (action = 'return'), and then bought the exact same item again (action = 'purchase') in that exact chronological order.

### Sample Input and Output
**Input: Transactions**
| user_id | item_id | action | transaction_date |
|---|---|---|---|
| 1 | 101 | 'purchase' | '2024-01-01' |
| 1 | 101 | 'return' | '2024-01-05' |
| 1 | 101 | 'purchase' | '2024-01-10' |
| 2 | 102 | 'purchase' | '2024-01-02' |
| 2 | 102 | 'purchase' | '2024-01-08' |
| 3 | 103 | 'purchase' | '2024-01-01' |

**Output:**
| user_id | item_id |
|---|---|
| 1 | 101 |
*/

-- DDL and DML commands
DROP TABLE IF EXISTS Transactions;
CREATE TABLE Transactions (
    user_id INT,
    item_id INT,
    action VARCHAR(20),
    transaction_date DATE
);

INSERT INTO Transactions (user_id, item_id, action, transaction_date) VALUES
(1, 101, 'purchase', '2024-01-01'),
(1, 101, 'return', '2024-01-05'),
(1, 101, 'purchase', '2024-01-10'),
(2, 102, 'purchase', '2024-01-02'),
(2, 102, 'purchase', '2024-01-08'),
(3, 103, 'purchase', '2024-01-01');


/*
### Approach
To find sequential patterns in events data for identical entities, we utilize the `LEAD` window function.
1. Partition the data by both `user_id` and `item_id`, ordering chronologically by `transaction_date`.
2. Extract the action of the NEXT row (`LEAD(action, 1)`) and the action of the row AFTER that (`LEAD(action, 2)`).
3. Filter where the current action is 'purchase', next is 'return', and the one after is 'purchase'.
*/










-- Optimized Solution
WITH EventSequences AS (
    SELECT 
        user_id,
        item_id,
        action AS current_action,
        LEAD(action, 1) OVER (PARTITION BY user_id, item_id ORDER BY transaction_date ASC) AS next_action,
        LEAD(action, 2) OVER (PARTITION BY user_id, item_id ORDER BY transaction_date ASC) AS consecutive_action
    FROM Transactions
)
-- Because a user could do this multiple times, we DISTINCT the result
SELECT DISTINCT user_id, item_id
FROM EventSequences
WHERE current_action = 'purchase'
  AND next_action = 'return'
  AND consecutive_action = 'purchase';
