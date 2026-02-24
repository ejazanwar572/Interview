/*
3204. Bitwise User Permissions Analysis
Difficulty: Medium
Table Names: user_permissions
Description:
    - Database

## Description

Table: user_permissions

| user_id     | int     |
| permissions | int     |
user_id is the primary key.
Each row of this table contains the user ID and their permissions encoded as an integer.

Consider that each bit in the permissions integer represents a different access level or feature that a user has.

Write a solution to calculate the following:

	- common_perms: The access level granted to all users. This is computed using a bitwise AND operation on the permissions column.
	- any_perms: The access level granted to any user. This is computed using a bitwise OR operation on the permissions column.

Return the result table in any order.

The result format is shown in the following example.

Example:

Input:

user_permissions table:

+---------+-------------+
| user_id | permissions |
+---------+-------------+
| 1       | 5           |
| 2       | 12          |
| 3       | 7           |
| 4       | 3           |
+---------+-------------+

Output:

+-------------+--------------+
| common_perms | any_perms   |
+--------------+-------------+
| 0            | 15          |
+--------------+-------------+

Explanation:

	- common_perms: Represents the bitwise AND result of all permissions:

    	- For user 1 (5): 5 (binary 0101)
    	- For user 2 (12): 12 (binary 1100)
    	- For user 3 (7): 7 (binary 0111)
    	- For user 4 (3): 3 (binary 0011)
    	- Bitwise AND: 5 &amp; 12 &amp; 7 &amp; 3 = 0 (binary 0000)
    - any_perms: Represents the bitwise OR result of all permissions:
    	- Bitwise OR: 5 | 12 | 7 | 3 = 15 (binary 1111)
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT
    BIT_AND(permissions) AS common_perms,
    BIT_OR(permissions) AS any_perms
FROM user_permissions;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS user_permissions;
DROP TABLE IF EXISTS user_permissions;
CREATE TABLE user_permissions (
    user_id int,
    permissions int
);

INSERT INTO user_permissions (user_id, permissions) VALUES
    (1, 5),
    (2, 12),
    (3, 7),
    (4, 3);

SET FOREIGN_KEY_CHECKS = 1;
*/
