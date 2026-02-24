/*
1098. Unpopular Books
Difficulty: Medium
Table Names: Books, Orders
Table: Books
| book_id        | int     |
| name           | varchar |
| available_from | date    |
Table: Orders
| order_id       | int     |
| book_id        | int     |
| quantity       | int     |
| dispatch_date  | date    |
book_id is a foreign key to the Books table.
Write an SQL query that reports the books that have sold less than 10 copies in the last year, excluding books that have been available for less than one month from today. Assume today is 2019-06-23.
Example:
Input:
Books table:
+---------+--------------------+----------------+
| book_id | name               | available_from |
+---------+--------------------+----------------+
| 1       | Kalila And Demna   | 2010-01-01     |
| 2       | 28 Letters         | 2012-05-12     |
| 3       | The Prophet        | 2019-06-01     |
| 4       | Tale of Two Cities | 2019-05-12     |
| 5       | The Twelve Chairs  | 2019-06-01     |
+---------+--------------------+----------------+
Orders table:
+----------+---------+----------+---------------+
| order_id | book_id | quantity | dispatch_date |
+----------+---------+----------+---------------+
| 1        | 1       | 2        | 2018-07-26    |
| 2        | 1       | 1        | 2018-11-05    |
| 3        | 2       | 8        | 2018-06-11    |
| 4        | 3       | 8        | 2019-06-05    |
| 5        | 4       | 8        | 2019-06-20    |
| 6        | 5       | 9        | 2009-02-02    |
| 7        | 5       | 8        | 2010-04-13    |
+----------+---------+----------+---------------+
Output:
+---------+--------------------+
| book_id | name               |
+---------+--------------------+
| 1       | Kalila And Demna   |
| 2       | 28 Letters         |
| 5       | The Twelve Chairs  |
+---------+--------------------+
Note: The last year is defined as the period from 2018-06-23 to 2019-06-23.
Books available for less than one month means available_from > '2019-05-23'.
We need to include books with NO sales in the last year (sales = 0).
*/

-- Write your MySQL query statement below:













-- Solution:
/*
SELECT
    b.book_id,
    b.name
FROM
    Books b
    LEFT JOIN Orders o ON b.book_id = o.book_id
    AND o.dispatch_date BETWEEN '2018-06-23' AND '2019-06-23'
WHERE
    b.available_from < '2019-05-23'
GROUP BY
    b.book_id,
    b.name
HAVING
    IFNULL(SUM(o.quantity), 0) < 10;

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    book_id int,
    name VARCHAR(255),
    available_from date
);

INSERT INTO Books (book_id, name, available_from) VALUES
    (1, 'Kalila And Demna', '2010-01-01'),
    (2, '28 Letters', '2012-05-12'),
    (3, 'The Prophet', '2019-06-01'),
    (4, 'Tale of Two Cities', '2019-05-12'),
    (5, 'The Twelve Chairs', '2019-06-01');
INSERT INTO Books (book_id, name) VALUES
    (1, 'Kalila And Demna'),
    (2, '28 Letters'),
    (5, 'The Twelve Chairs');

DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
    order_id int,
    book_id int,
    quantity int,
    dispatch_date date
);

INSERT INTO Orders (order_id, book_id, quantity, dispatch_date) VALUES
    (1, 1, 2, '2018-07-26'),
    (2, 1, 1, '2018-11-05'),
    (3, 2, 8, '2018-06-11'),
    (4, 3, 8, '2019-06-05'),
    (5, 4, 8, '2019-06-20'),
    (6, 5, 9, '2009-02-02'),
    (7, 5, 8, '2010-04-13');

SET FOREIGN_KEY_CHECKS = 1;
*/
