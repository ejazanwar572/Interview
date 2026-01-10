-- Solution for "Exchange Seats"
-- Objective: Swap the seat id of every two consecutive students.
-- If the number of students is odd, the id of the last student is not swapped.

SELECT 
    CASE 
        -- If ID is odd and it's the last row, keep it as is
        WHEN MOD(id, 2) != 0 AND id = (SELECT COUNT(*) FROM `interview_practice.Seat`) THEN id
        -- If ID is odd and not last, add 1 (swap with next)
        WHEN MOD(id, 2) != 0 THEN id + 1
        -- If ID is even, subtract 1 (swap with previous)
        ELSE id - 1
    END AS id,
    student
FROM 
    `interview_practice.Seat`
ORDER BY 
    id ASC;
