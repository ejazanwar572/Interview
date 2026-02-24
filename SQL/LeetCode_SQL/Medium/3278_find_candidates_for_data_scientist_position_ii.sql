/*
3278. Find Candidates for Data Scientist Position II
Difficulty: Medium
Table Names: Candidates, Projects
Description:
    - Database

## Description


| candidate_id | int     |
| skill        | varchar |
| proficiency  | int     |
Each row includes candidate_id, skill, and proficiency level (1-5).


| project_id   | int     |
| skill        | varchar |
| importance   | int     |
Each row includes project_id, required skill, and its importance (1-5) for the project.

Leetcode is staffing for multiple data science projects. Write a solution to find the best candidate for each project based on the following criteria:

<ol>
	- Candidates must have all the skills required for a project.
	- Calculate a score for each candidate-project pair as follows:
		- Start with 100 points
		- Add 10 points for each skill where proficiency > importance
		- Subtract 5 points for each skill where proficiency < importance
		- If the candidate's skill proficiency equal to the project's skill importance, the score remains unchanged
</ol>

Include only the top candidate (highest score) for each project. If there&rsquo;s a tie, choose the candidate with the lower candidate_id. If there is no suitable candidate for a project, do not return that project.

Return a result table ordered by project_id in ascending order.

The result format is in the following example.

Example:

Input:

Candidates table:

+--------------+-----------+-------------+
| candidate_id | skill     | proficiency |
+--------------+-----------+-------------+
| 101          | Python    | 5           |
| 101          | Tableau   | 3           |
| 101          | PostgreSQL| 4           |
| 101          | TensorFlow| 2           |
| 102          | Python    | 4           |
| 102          | Tableau   | 5           |
| 102          | PostgreSQL| 4           |
| 102          | R         | 4           |
| 103          | Python    | 3           |
| 103          | Tableau   | 5           |
| 103          | PostgreSQL| 5           |
| 103          | Spark     | 4           |
+--------------+-----------+-------------+

Projects table:

+-------------+-----------+------------+
| project_id  | skill     | importance |
+-------------+-----------+------------+
| 501         | Python    | 4          |
| 501         | Tableau   | 3          |
| 501         | PostgreSQL| 5          |
| 502         | Python    | 3          |
| 502         | Tableau   | 4          |
| 502         | R         | 2          |
+-------------+-----------+------------+

Output:

+-------------+--------------+-------+
| project_id  | candidate_id | score |
+-------------+--------------+-------+
| 501         | 101          | 105   |
| 502         | 102          | 130   |
+-------------+--------------+-------+

Explanation:

	- For Project 501, Candidate 101 has the highest score of 105. All other candidates have the same score but Candidate 101 has the lowest candidate_id among them.
	- For Project 502, Candidate 102 has the highest score of 130.

The output table is ordered by project_id in ascending order.
*/

-- Write your MySQL query statement below:













-- Solution:
/*
WITH
    S AS (
        SELECT
            candidate_id,
            project_id,
            COUNT(*) matched_skills,
            SUM(
                CASE
                    WHEN proficiency > importance THEN 10
                    WHEN proficiency < importance THEN -5
                    ELSE 0
                END
            ) + 100 AS score
        FROM
            Candidates
            JOIN Projects USING (skill)
        GROUP BY 1, 2
    ),
    T AS (
        SELECT project_id, COUNT(1) required_skills
        FROM Projects
        GROUP BY 1
    ),
    P AS (
        SELECT
            project_id,
            candidate_id,
            score,
            RANK() OVER (
                PARTITION BY project_id
                ORDER BY score DESC, candidate_id
            ) rk
        FROM
            S
            JOIN T USING (project_id)
        WHERE matched_skills = required_skills
    )
SELECT project_id, candidate_id, score
FROM P
WHERE rk = 1
ORDER BY 1;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Candidates;

DROP TABLE IF EXISTS Candidates;
CREATE TABLE Candidates (
    candidate_id int,
    skill VARCHAR(255),
    proficiency int
);

INSERT INTO
    Candidates (
        candidate_id,
        skill,
        proficiency
    )
VALUES (101, 'Python', 5),
    (101, 'Tableau', 3),
    (101, 'PostgreSQL', 4),
    (101, 'TensorFlow', 2),
    (102, 'Python', 4),
    (102, 'Tableau', 5),
    (102, 'PostgreSQL', 4),
    (102, 'R', 4),
    (103, 'Python', 3),
    (103, 'Tableau', 5),
    (103, 'PostgreSQL', 5),
    (103, 'Spark', 4);

DROP TABLE IF EXISTS Projects;

DROP TABLE IF EXISTS Projects;
CREATE TABLE Projects (
    project_id int,
    skill VARCHAR(255),
    importance int
);

INSERT INTO
    Projects (project_id, skill, importance)
VALUES (501, 'Python', 4),
    (501, 'Tableau', 3),
    (501, 'PostgreSQL', 5),
    (502, 'Python', 3),
    (502, 'Tableau', 4),
    (502, 'R', 2);

SET FOREIGN_KEY_CHECKS = 1;
*/
