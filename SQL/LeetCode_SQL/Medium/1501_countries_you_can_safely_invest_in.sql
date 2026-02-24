/*
1501. Countries You Can Safely Invest In
Difficulty: Medium
Table Names: Person, Country, Calls
Description:
A country is considered safe to invest in if the average call duration of the calls from that country is strictly greater than the global average call duration.
Find all such countries.
Schema:
Table: Person
| id            | int     |
| name          | varchar |
| phone_number  | varchar |

Table: Country
| name          | varchar |
| country_code  | varchar |

Table: Calls
| caller_id     | int     |
| callee_id     | int     |
| duration      | int     |
No primary key.
Example Input/Output:
Person table:
+----+-------+--------------+
| id | name  | phone_number |
+----+-------+--------------+
| 1  | Jonathan | 051-1234567 |
| 2  | Elvis    | 051-7654321 |
+----+-------+--------------+
Country table:
+----------+--------------+
| name     | country_code |
+----------+--------------+
| Peru     | 051          |
+----------+--------------+
Output:
+---------+
| country |
+---------+
| Peru    |
+---------+
*/

-- Write your MySQL query statement below:













-- Solution:
/*
WITH GlobalAvg AS (
    SELECT AVG(duration) AS avg_duration FROM Calls
),
PersonCountry AS (
    SELECT
        p.id,
        c.name AS country_name
    FROM
        Person p
        JOIN Country c ON LEFT(p.phone_number, 3) = c.country_code
),
CountryDuration AS (
    SELECT
        pc.country_name,
        AVG(c.duration) AS country_avg
    FROM
        Calls c
        JOIN PersonCountry pc ON c.caller_id = pc.id OR c.callee_id = pc.id
    GROUP BY
        pc.country_name
)
SELECT
    cd.country_name AS country
FROM
    CountryDuration cd
    JOIN GlobalAvg ga
WHERE
    cd.country_avg > ga.avg_duration;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Person;
DROP TABLE IF EXISTS Person;
CREATE TABLE Person (
    id int,
    name VARCHAR(255),
    phone_number VARCHAR(255)
);

INSERT INTO Person (id, name, phone_number) VALUES
    (1, 'Jonathan', '051-1234567'),
    (2, 'Elvis', '051-7654321');

DROP TABLE IF EXISTS Country;
DROP TABLE IF EXISTS Country;
CREATE TABLE Country (
    name VARCHAR(255),
    country_code VARCHAR(255)
);

INSERT INTO Country (name, country_code) VALUES
    ('Peru', '051');

DROP TABLE IF EXISTS Calls;
DROP TABLE IF EXISTS Calls;
CREATE TABLE Calls (
    caller_id int,
    callee_id int,
    duration int
);

SET FOREIGN_KEY_CHECKS = 1;
*/
