/*
### Problem Description
Write a query to swap the seat `id` of every two consecutive students. If the number of students is odd, the `id` of the last student is not swapped.
Return the result table ordered by `id` in ascending order.

### Sample Input and Output
**Input: Seat**
| id | student |
|---|---|
| 1 | Abbot |
| 2 | Doris |
| 3 | Emerson |
| 4 | Green |
| 5 | Jeames |

**Output:**
| id | student |
|---|---|
| 1 | Doris |
| 2 | Abbot |
| 3 | Green |
| 4 | Emerson |
| 5 | Jeames |

*Hint: Notice how id=1 maps to Doris (originally id=2), while id=5 maps to Jeames (originally id=5, not swapped).*
*/

-- DDL and DML commands
DROP TABLE IF EXISTS Seat;
CREATE TABLE Seat (
    id INT,
    student VARCHAR(50)
);

INSERT INTO Seat (id, student) VALUES
(1, 'Abbot'),
(2, 'Doris'),
(3, 'Emerson'),
(4, 'Green'),
(5, 'Jeames');


/*
### Approach
To swap IDs mathematically, you don't need window functions or joins.
You use the modulo operator `%` to determine parity.
- If an `id` is Odd (e.g. 1), it needs to swap with `id` + 1 (e.g. 2).
- If an `id` is Even (e.g. 2), it needs to swap with `id` - 1 (e.g. 1).
- The edge case is the final Odd `id` in a database with an odd number of items, which can be found by extracting the `MAX(id)`. It stays the same.

We generate new IDs dynamically via a `CASE WHEN` statement on the existing IDs, and `ORDER BY` the newly generated IDs.
*/

SELECT * FROM seat








-- Optimized Solution
SELECT 
    CASE 
        -- Edge Case: Last odd item
        WHEN id % 2 = 1 AND id = (SELECT MAX(id) FROM Seat) THEN id
        -- Standard Odd id
        WHEN id % 2 = 1 THEN id + 1
        -- Standard Even id
        ELSE id - 1
    END AS id,
    student
FROM Seat
ORDER BY id ASC;
