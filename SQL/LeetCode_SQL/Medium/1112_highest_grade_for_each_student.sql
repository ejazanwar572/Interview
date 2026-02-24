/*
1112. Highest Grade For Each Student
Difficulty: Medium
Table Names: Enrollments
Table: Enrollments
| student_id    | int     |
| course_id     | int     |
| grade         | int     |
Write an SQL query to find the highest grade with its corresponding course for each student. In case of a tie, you should find the course with the smallest course_id. The output must be sorted by student_id in ascending order.
Example:
Input:
Enrollments table:
+------------+-----------+-------+
| student_id | course_id | grade |
+------------+-----------+-------+
| 2          | 2         | 95    |
| 2          | 3         | 95    |
| 1          | 1         | 90    |
| 1          | 2         | 99    |
| 3          | 1         | 80    |
| 3          | 2         | 75    |
| 3          | 3         | 82    |
+------------+-----------+-------+
Output:
+------------+-----------+-------+
| student_id | course_id | grade |
+------------+-----------+-------+
| 1          | 2         | 99    |
| 2          | 2         | 95    |
| 3          | 3         | 82    |
+------------+-----------+-------+
*/

-- Write your MySQL query statement below:













-- Solution:
/*
WITH RankedGrades AS (
    SELECT
        student_id,
        course_id,
        grade,
        ROW_NUMBER() OVER (
            PARTITION BY student_id 
            ORDER BY grade DESC, course_id ASC
        ) AS rn
    FROM
        Enrollments
)
SELECT
    student_id,
    course_id,
    grade
FROM
    RankedGrades
WHERE
    rn = 1
ORDER BY
    student_id;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Enrollments;
CREATE TABLE Enrollments (
    student_id int,
    course_id int,
    grade int
);

INSERT INTO Enrollments (student_id, course_id, grade) VALUES
    (2, 2, 95),
    (2, 3, 95),
    (1, 1, 90),
    (1, 2, 99),
    (3, 1, 80),
    (3, 2, 75),
    (3, 3, 82),
    (1, 2, 99),
    (2, 2, 95),
    (3, 3, 82);

SET FOREIGN_KEY_CHECKS = 1;
*/
