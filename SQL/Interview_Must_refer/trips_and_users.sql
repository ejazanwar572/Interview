-- Solution for LeetCode 262: Trips and Users
-- Difficulty: Hard

/*
Problem: Find the cancellation rate of requests with unbanned users 
(both client and driver must not be banned) 
each day between "2013-10-01" and "2013-10-03".

The cancellation rate is computed by dividing the number of canceled 
(by client or driver) requests with unbanned users by the total number 
of requests with unbanned users on that day.

Schema & DML Data:
*/
USE practice_sql_db;

DROP TABLE IF EXISTS Trips;

DROP TABLE IF EXISTS Users;

CREATE TABLE Users (
    users_id INT,
    banned VARCHAR(50),
    role VARCHAR(50)
);

CREATE TABLE Trips (
    id INT,
    client_id INT,
    driver_id INT,
    city_id INT,
    status VARCHAR(50),
    request_at DATE
);

INSERT INTO
    Users (users_id, banned, role)
VALUES (1, 'No', 'client'),
    (2, 'Yes', 'client'),
    (3, 'No', 'client'),
    (4, 'No', 'client'),
    (10, 'No', 'driver'),
    (11, 'No', 'driver'),
    (12, 'No', 'driver'),
    (13, 'No', 'driver');

INSERT INTO
    Trips (
        id,
        client_id,
        driver_id,
        city_id,
        status,
        request_at
    )
VALUES (
        1,
        1,
        10,
        1,
        'completed',
        '2013-10-01'
    ),
    (
        2,
        2,
        11,
        1,
        'cancelled_by_driver',
        '2013-10-01'
    ),
    (
        3,
        3,
        12,
        6,
        'completed',
        '2013-10-01'
    ),
    (
        4,
        4,
        13,
        6,
        'cancelled_by_client',
        '2013-10-01'
    ),
    (
        5,
        1,
        10,
        1,
        'completed',
        '2013-10-02'
    ),
    (
        6,
        2,
        11,
        6,
        'completed',
        '2013-10-02'
    ),
    (
        7,
        3,
        12,
        6,
        'completed',
        '2013-10-02'
    ),
    (
        8,
        2,
        12,
        12,
        'completed',
        '2013-10-03'
    ),
    (
        9,
        3,
        10,
        12,
        'completed',
        '2013-10-03'
    ),
    (
        10,
        4,
        13,
        12,
        'cancelled_by_driver',
        '2013-10-03'
    );

-- ==========================================
-- Your Sol
-- ==========================================

-- ==========================================
-- Solutions Provided
-- ==========================================

/*
SELECT 
request_at AS Day,
ROUND(
SUM(CASE WHEN status != 'completed' THEN 1 ELSE 0 END) / COUNT(*), 
2
) AS "Cancellation Rate"
FROM Trips t
JOIN Users c ON t.client_id = c.users_id AND c.banned = 'No' 
JOIN Users d ON t.driver_id = d.users_id AND d.banned = 'No'
WHERE 
request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY request_at
ORDER BY request_at;
*/