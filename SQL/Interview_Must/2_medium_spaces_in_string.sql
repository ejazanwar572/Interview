/*
### Problem Description
Given a table of `Users` with their full name, return the user_id and the number of spaces contained in their full name.

### Sample Input and Output
**Input: Users**
| user_id | full_name |
|---|---|
| 1 | 'John Doe' |
| 2 | 'Alice Mary Smith' |
| 3 | 'Bob' |

**Output:**
| user_id | space_count |
|---|---|
| 1 | 1 |
| 2 | 2 |
| 3 | 0 |
*/

-- DDL and DML commands
DROP TABLE IF EXISTS Users;
CREATE TABLE Users (
    user_id INT,
    full_name VARCHAR(100)
);

INSERT INTO Users (user_id, full_name) VALUES
(1, 'John Doe'),
(2, 'Alice Mary Smith'),
(3, 'Bob');


/*
### Approach
To count the occurrences of a specific character (like a space) inside a string, we utilize a very common string manipulation trick.
We find the total length of the original string, remove all spaces using the `REPLACE` function, calculate the length of this new string without spaces, and then subtract the two lengths.
Formula: `LENGTH(original) - LENGTH(REPLACE(original, ' ', ''))`
*/










-- Optimized Solution
SELECT 
    user_id,
    LENGTH(full_name) - LENGTH(REPLACE(full_name, ' ', '')) AS space_count
FROM Users;
