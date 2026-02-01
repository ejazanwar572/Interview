-- Solution for LeetCode 196: Delete Duplicate Emails

-- Approach: DELETE with Self-Join
-- We confirm that p1 is the duplicate we want to remove if there exists another row p2
-- with the same email but a smaller ID.
DELETE p1
FROM Person p1, Person p2
WHERE p1.Email = p2.Email AND p1.Id > p2.Id;

-- Alternative: Using a subquery (if the database allows deleting from the same table in subquery without wrapper)
DELETE FROM Person
WHERE Id NOT IN (
SELECT * FROM (
SELECT MIN(Id) FROM Person GROUP BY Email
) p
);
