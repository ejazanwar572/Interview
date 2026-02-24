/*
574. Winning Candidate
Difficulty: Medium
Table Names: Candidate, Vote

Table: Candidate
| id          | int      |
| name        | varchar  |
Each row of this table contains information about the id and the name of a candidate.

Table: Vote
| id          | int     |
| candidateId | int     |
candidateId is a foreign key (reference column) to id from the Candidate table.
Each row of this table determines the candidate who got the ith vote in the elections.

Write a solution to report the name of the winning candidate (i.e., the candidate who got the largest number of votes).
You may assume that there is exactly one winning candidate.
Example 1:
Input:
Candidate table:
+----+------+
| id | name |
+----+------+
| 1  | A    |
| 2  | B    |
| 3  | C    |
| 4  | D    |
| 5  | E    |
+----+------+
Vote table:
+----+-------------+
| id | candidateId |
+----+-------------+
| 1  | 2           |
| 2  | 4           |
| 3  | 3           |
| 4  | 2           |
| 5  | 5           |
+----+-------------+
Output:
+------+
| name |
+------+
| B    |
+------+
Solution
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT c.name
FROM Candidate c
JOIN (
    SELECT candidateId, COUNT(*) AS votes
    FROM Vote
    GROUP BY candidateId
    ORDER BY votes DESC
    LIMIT 1
) v ON c.id = v.candidateId;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Candidate;
DROP TABLE IF EXISTS Candidate;
CREATE TABLE Candidate (
    id int,
    name VARCHAR(255)
);

INSERT INTO Candidate (id, name) VALUES
    (1, 'A'),
    (2, 'B'),
    (3, 'C'),
    (4, 'D'),
    (5, 'E');
INSERT INTO Candidate (name) VALUES
    ('B');

DROP TABLE IF EXISTS Vote;
DROP TABLE IF EXISTS Vote;
CREATE TABLE Vote (
    id int,
    candidateId int
);

INSERT INTO Vote (id, candidateId) VALUES
    (1, 2),
    (2, 4),
    (3, 3),
    (4, 2),
    (5, 5);

SET FOREIGN_KEY_CHECKS = 1;
*/
