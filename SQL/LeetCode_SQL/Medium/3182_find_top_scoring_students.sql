/*
3182. Find Top Scoring Students
Difficulty: Medium
Table Names: students, courses, enrollments
Description:
    - Database

## Description

Table: students

| student_id  | int      |
| name        | varchar  |
| major       | varchar  |
Each row of this table contains the student ID, student name, and their major.

Table: courses

| course_id   | int      |
| name        | varchar  |
| credits     | int      |
| major       | varchar  |
Each row of this table contains the course ID, course name, the number of credits for the course, and the major it belongs to.

Table: enrollments

| student_id  | int      |
| course_id   | int      |
| semester    | varchar  |
| grade       | varchar  |
Each row of this table contains the student ID, course ID, semester, and grade received.

Write a solution to find the students who have taken all courses offered in their major and have achieved a grade of A in all these courses.

Return the result table ordered by student_id in ascending order.

The result format is in the following example.

Example:

Input:

students table:

+------------+------------------+------------------+
| student_id | name             | major            |
+------------+------------------+------------------+
| 1          | Alice            | Computer Science |
| 2          | Bob              | Computer Science |
| 3          | Charlie          | Mathematics      |
| 4          | David            | Mathematics      |
+------------+------------------+------------------+

courses table:

+-----------+-----------------+---------+------------------+
| course_id | name            | credits | major            |
+-----------+-----------------+---------+------------------+
| 101       | Algorithms      | 3       | Computer Science |
| 102       | Data Structures | 3       | Computer Science |
| 103       | Calculus        | 4       | Mathematics      |
| 104       | Linear Algebra  | 4       | Mathematics      |
+-----------+-----------------+---------+------------------+

enrollments table:

+------------+-----------+----------+-------+
| student_id | course_id | semester | grade |
+------------+-----------+----------+-------+
| 1          | 101       | Fall 2023| A     |
| 1          | 102       | Fall 2023| A     |
| 2          | 101       | Fall 2023| B     |
| 2          | 102       | Fall 2023| A     |
| 3          | 103       | Fall 2023| A     |
| 3          | 104       | Fall 2023| A     |
| 4          | 103       | Fall 2023| A     |
| 4          | 104       | Fall 2023| B     |
+------------+-----------+----------+-------+

Output:

+------------+
| student_id |
+------------+
| 1          |
| 3          |
+------------+

Explanation:

	- Alice (student_id 1) is a Computer Science major and has taken both &quot;Algorithms&quot; and &quot;Data Structures&quot;, receiving an 'A' in both.
	- Bob (student_id 2) is a Computer Science major but did not receive an 'A' in all required courses.
	- Charlie (student_id 3) is a Mathematics major and has taken both &quot;Calculus&quot; and &quot;Linear Algebra&quot;, receiving an 'A' in both.
	- David (student_id 4) is a Mathematics major but did not receive an 'A' in all required courses.

<b>Note:</b> Output table is ordered by student_id in ascending order.
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT student_id
FROM
    students
    JOIN courses USING (major)
    LEFT JOIN enrollments USING (student_id, course_id)
GROUP BY 1
HAVING SUM(grade = 'A') = COUNT(major)
ORDER BY 1;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS students;
CREATE TABLE students (
    student_id int,
    name VARCHAR(255),
    major VARCHAR(255)
);

INSERT INTO students (student_id, name, major) VALUES
    (1, 'Alice', 'Computer Science'),
    (2, 'Bob', 'Computer Science'),
    (3, 'Charlie', 'Mathematics'),
    (4, 'David', 'Mathematics');
INSERT INTO students (student_id) VALUES
    (1),
    (3);

DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS courses;
CREATE TABLE courses (
    course_id int,
    name VARCHAR(255),
    credits int,
    major VARCHAR(255)
);

INSERT INTO courses (course_id, name, credits, major) VALUES
    (101, 'Algorithms', 3, 'Computer Science'),
    (102, 'Data Structures', 3, 'Computer Science'),
    (103, 'Calculus', 4, 'Mathematics'),
    (104, 'Linear Algebra', 4, 'Mathematics');

DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS enrollments;
CREATE TABLE enrollments (
    student_id int,
    course_id int,
    semester VARCHAR(255),
    grade VARCHAR(255)
);

INSERT INTO enrollments (student_id, course_id, semester, grade) VALUES
    (1, 101, 'Fall 2023', 'A'),
    (1, 102, 'Fall 2023', 'A'),
    (2, 101, 'Fall 2023', 'B'),
    (2, 102, 'Fall 2023', 'A'),
    (3, 103, 'Fall 2023', 'A'),
    (3, 104, 'Fall 2023', 'A'),
    (4, 103, 'Fall 2023', 'A'),
    (4, 104, 'Fall 2023', 'B');

SET FOREIGN_KEY_CHECKS = 1;
*/
