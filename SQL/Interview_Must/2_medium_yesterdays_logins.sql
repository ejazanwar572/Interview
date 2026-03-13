/*
### Problem Description
Find users who logged in yesterday but did not log in today.

### Sample Input and Output
**Input: logins**
| user_id | login_date |
|---|---|
| 1 | CURRENT_DATE - 1 |
... 

**Output:**
| user_id |
|---|
*/

DROP TABLE IF EXISTS logins;
CREATE TABLE logins (user_id INT, login_date DATE);

/*
### Approach
Use EXCEPT to subtract today's login user_ids from yesterday's. Alternatively, a LEFT JOIN filtering for NULLs also works.
*/

SELECT user_id 
FROM logins 
WHERE login_date = CURRENT_DATE - INTERVAL '1 day' 
EXCEPT 
SELECT user_id 
FROM logins 
WHERE login_date = CURRENT_DATE;
