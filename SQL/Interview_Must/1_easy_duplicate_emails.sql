/*
### Problem Description
Identify emails that appear more than once in the users table.

### Sample Input and Output
**Input: users**
| email |
|---| 
| a@b.com |
| c@d.com |
| a@b.com |

**Output:**
| email | occurrences |
|---|---|
| a@b.com | 2 |
*/

DROP TABLE IF EXISTS users;
CREATE TABLE users (email VARCHAR(255));
INSERT INTO users (email) VALUES ('a@b.com'), ('c@d.com'), ('a@b.com');

/*
### Approach
Group by the email column and use the HAVING clause to filter groups with a count greater than 1. HAVING is applied after GROUP BY.
*/

SELECT email, COUNT(*) AS occurrences 
FROM users 
GROUP BY email 
HAVING COUNT(*) > 1;
