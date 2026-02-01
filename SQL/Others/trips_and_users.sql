-- Solution for LeetCode 262: Trips and Users

-- Goal: Find the cancellation rate of requests with unbanned users (both client and driver must not be banned) 
-- each day between "2013-10-01" and "2013-10-03".

SELECT 
    request_at AS Day,
    ROUND(
        SUM(CASE WHEN status != 'completed' THEN 1 ELSE 0 END) / COUNT(*), 
        2
    ) AS "Cancellation Rate"
FROM Trips t
JOIN Users c ON t.client_id = c.users_id
JOIN Users d ON t.driver_id = d.users_id
WHERE 
    c.banned = 'No' 
    AND d.banned = 'No'
    AND request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY request_at
ORDER BY request_at;
