/*
2020. Number of Accounts That Did Not Stream
Difficulty: Medium
Table Names: Subscriptions, Streams
Description:
    - Database

## Description

Table: Subscriptions

| account_id  | int  |
| start_date  | date |
| end_date    | date |
Each row of this table indicates the start and end dates of an account's subscription.
Note that always start_date < end_date.

Table: Streams

| session_id  | int  |
| account_id  | int  |
| stream_date | date |
account_id is a foreign key from the Subscriptions table.
Each row of this table contains information about the account and the date associated with a stream session.

Write an SQL query to report the number of accounts that bought a subscription in 2021 but did not have any stream session.

The query result format is in the following example.

Example 1:

Input:
Subscriptions table:
+------------+------------+------------+
| account_id | start_date | end_date   |
+------------+------------+------------+
| 9          | 2020-02-18 | 2021-10-30 |
| 3          | 2021-09-21 | 2021-11-13 |
| 11         | 2020-02-28 | 2020-08-18 |
| 13         | 2021-04-20 | 2021-09-22 |
| 4          | 2020-10-26 | 2021-05-08 |
| 5          | 2020-09-11 | 2021-01-17 |
+------------+------------+------------+
Streams table:
+------------+------------+-------------+
| session_id | account_id | stream_date |
+------------+------------+-------------+
| 14         | 9          | 2020-05-16  |
| 16         | 3          | 2021-10-27  |
| 18         | 11         | 2020-04-29  |
| 17         | 13         | 2021-08-08  |
| 19         | 4          | 2020-12-31  |
| 13         | 5          | 2021-01-05  |
+------------+------------+-------------+
Output:
+----------------+
| accounts_count |
+----------------+
| 2              |
+----------------+
Explanation: Users 4 and 9 did not stream in 2021.
User 11 did not subscribe in 2021.
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT COUNT(sub.account_id) AS accounts_count
FROM
    Subscriptions AS sub
    LEFT JOIN Streams USING (account_id)
WHERE
    YEAR(start_date) <= 2021
    AND YEAR(end_date) >= 2021
    AND (YEAR(stream_date) != 2021 OR stream_date > end_date);

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Subscriptions;
DROP TABLE IF EXISTS Subscriptions;
CREATE TABLE Subscriptions (
    account_id int,
    start_date date,
    end_date date
);

INSERT INTO Subscriptions (account_id, start_date, end_date) VALUES
    (9, '2020-02-18', '2021-10-30'),
    (3, '2021-09-21', '2021-11-13'),
    (11, '2020-02-28', '2020-08-18'),
    (13, '2021-04-20', '2021-09-22'),
    (4, '2020-10-26', '2021-05-08'),
    (5, '2020-09-11', '2021-01-17');

DROP TABLE IF EXISTS Streams;
DROP TABLE IF EXISTS Streams;
CREATE TABLE Streams (
    session_id int,
    account_id int,
    stream_date date
);

INSERT INTO Streams (session_id, account_id, stream_date) VALUES
    (14, 9, '2020-05-16'),
    (16, 3, '2021-10-27'),
    (18, 11, '2020-04-29'),
    (17, 13, '2021-08-08'),
    (19, 4, '2020-12-31'),
    (13, 5, '2021-01-05');

SET FOREIGN_KEY_CHECKS = 1;
*/
