/*
3054. Binary Tree Nodes
Difficulty: Medium
Table Names: Tree
Description:
    - Database

## Description


| N           | int  |
| P           | int  |
N is the column of unique values for this table.
Each row includes N and P, where N represents the value of a node in Binary Tree, and P is the parent of N.

Write a solution to find the node type of the Binary Tree. Output one of the following for each node:

	- Root: if the node is the root node.
	- Leaf: if the node is the leaf node.
	- Inner: if the node is neither root nor leaf node.

Return the result table ordered by node value in ascending order.

The result format is in the following example.

Example 1:

Input:
Tree table:
+---+------+
| N | P    |
+---+------+
| 1 | 2    |
| 3 | 2    |
| 6 | 8    |
| 9 | 8    |
| 2 | 5    |
| 8 | 5    |
| 5 | null |
+---+------+
Output:
+---+-------+
| N | Type  |
+---+-------+
| 1 | Leaf  |
| 2 | Inner |
| 3 | Leaf  |
| 5 | Root  |
| 6 | Leaf  |
| 8 | Inner |
| 9 | Leaf  |
+---+-------+
Explanation:
- Node 5 is the root node since it has no parent node.
- Nodes 1, 3, 6, and 9 are leaf nodes because they don't have any child nodes.
- Nodes 2, and 8 are inner nodes as they serve as parents to some of the nodes in the structure.

Note: This question is the same as <a href="https://leetcode.com/problems/tree-node/description/" target="_blank"> 608: Tree Node.</a>
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT DISTINCT
    t1.N AS N,
    IF(t1.P IS NULL, 'Root', IF(t2.P IS NULL, 'Leaf', 'Inner')) AS Type
FROM
    Tree AS t1
    LEFT JOIN Tree AS t2 ON t1.N = t2.p
ORDER BY 1;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Tree;

DROP TABLE IF EXISTS Tree;
CREATE TABLE Tree (N int, P int);

INSERT INTO
    Tree (N, P)
VALUES (1, 2),
    (3, 2),
    (6, 8),
    (9, 8),
    (2, 5),
    (8, 5),
    (5, NULL);

SET FOREIGN_KEY_CHECKS = 1;
*/
