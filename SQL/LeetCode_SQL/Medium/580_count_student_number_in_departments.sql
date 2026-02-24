/*
580. Count Student Number in Departments
Difficulty: Medium
Table Names: Student, Department

Table: Student
| student_id   | int     |
| student_name | varchar |
| gender       | varchar |
| dept_id      | int     |
dept_id is a foreign key (reference column) to dept_id in the Department tables.
Each row of this table indicates the name of a student, their gender, and the id of their department.

Table: Department
| dept_id     | int     |
| dept_name   | varchar |
Each row of this table contains the id and the name of a department.

Write a solution to report the respective department name and number of students majoring in each department for all departments in the Department table (even ones with no current students).
Return the result table ordered by student_number in descending order. In case of a tie, order them by dept_name in alphabetical order.
Example 1:
Input:
Student table:
+------------+--------------+--------+---------+
| student_id | student_name | gender | dept_id |
+------------+--------------+--------+---------+
| 1          | Jack         | M      | 1       |
| 2          | Jane         | F      | 1       |
| 3          | Mark         | M      | 2       |
+------------+--------------+--------+---------+
Department table:
+---------+-------------+
| dept_id | dept_name   |
+---------+-------------+
| 1       | Engineering |
| 2       | Science     |
| 3       | Law         |
+---------+-------------+
Output:
+-------------+----------------+
| dept_name   | student_number |
+-------------+----------------+
| Engineering | 2              |
| Science     | 1              |
| Law         | 0              |
+-------------+----------------+
Solution
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT 
    d.dept_name,
    COUNT(s.student_id) AS student_number
FROM Department d
LEFT JOIN Student s ON d.dept_id = s.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY student_number DESC, d.dept_name ASC;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Student;
CREATE TABLE Student (
    student_id int,
    student_name VARCHAR(255),
    gender VARCHAR(255),
    dept_id int
);

INSERT INTO Student (student_id, student_name, gender, dept_id) VALUES
    (1, 'Jack', 'M', 1),
    (2, 'Jane', 'F', 1),
    (3, 'Mark', 'M', 2);

DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS Department;
CREATE TABLE Department (
    dept_id int,
    dept_name VARCHAR(255)
);

INSERT INTO Department (dept_id, dept_name) VALUES
    (1, 'Engineering'),
    (2, 'Science'),
    (3, 'Law');

SET FOREIGN_KEY_CHECKS = 1;
*/
