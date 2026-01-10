-- Solution for "Last Person to Fit in the Bus"
-- Objective: Find the last person (ordered by turn) who can board without the total weight exceeding 1000.

SELECT person_name
FROM (
    SELECT 
        person_name, 
        turn,
        -- Calculate running total of weight ordered by turn
        SUM(weight) OVER (ORDER BY turn) as total_weight
    FROM 
        `interview_practice.Queue`
)
WHERE 
    total_weight <= 1000
ORDER BY 
    total_weight DESC -- Get the max weight <= 1000 (which corresponds to the last person)
LIMIT 1;
