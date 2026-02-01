-- Puzzle 67 - Matching Birthdays
--

-- Given the following dataset, find the students who share the same birthday.

/*
| Student  | Birthday  |
|----------|------------|
| Susan    | 04/15/2015 |
| Tim      | 04/15/2015 |
| Jacob    | 04/15/2015 |
| Earl     | 02/05/2015 |
| Mike     | 05/23/2015 |
| Angie    | 05/23/2015 |
| Jenny    | 11/19/2015 |
| Michelle | 12/12/2015 |
| Aaron    | 12/18/2015 |
*/

-- Here is the expected output.

/*
|  Birthday  |     Students      |
|------------|-------------------|
| 04/15/2015 | Susan, Tim, Jacob |
| 05/23/2015 | Mike, Angie       |
*/


-- ==================================================
-- Solution for Puzzle 67
-- ==================================================

DROP TABLE IF EXISTS Students;

CREATE TABLE Students
(
StudentName  VARCHAR(50) PRIMARY KEY,
Birthday     DATE
);

INSERT INTO Students (StudentName, Birthday) VALUES
('Susan', '2015-04-15'),
('Tim', '2015-04-15'),
('Jacob', '2015-04-15'),
('Earl', '2015-02-05'),
('Mike', '2015-05-23'),
('Angie', '2015-05-23'),
('Jenny', '2015-11-19'),
('Michelle', '2015-12-12'),
('Aaron', '2015-12-18');

SELECT  Birthday, GROUP_CONCAT(StudentName SEPARATOR ', ') AS Students
FROM    Students
GROUP BY Birthday
HAVING  COUNT(*) > 1;
