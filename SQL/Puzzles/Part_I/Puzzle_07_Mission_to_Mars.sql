-- Puzzle 7 - Mission to Mars
--

-- You are given the following tables: one listing the requirements for a space mission and another listing potential candidates.  

-- Write an SQL statement to identify which candidates meet the mission's requirements.  

-- Candidates
/*
| Candidate ID | Description |
|--------------|-------------|
| 1001         | Geologist   |
| 1001         | Astrogator  |
| 1001         | Biochemist  |
| 1001         | Technician  |
| 2002         | Surgeon     |
| 2002         | Machinist   |
| 2002         | Geologist   |
| 3003         | Geologist   |
| 3003         | Astrogator  |
| 4004         | Selenologist|
*/

-- Requirements

/*
| Description  |
|--------------|
| Geologist    |
| Astrogator   |
| Technician   |
*/

-- Here is the expected output.

/*
| Candidate ID |
|--------------|
| 1001         |
*/

-- - The expected output would be `Candidate ID` `1001`, as this candidate has all the necessary skills for the space mission.  
-- - `Candidate ID` `2002` and `3003` would not be in the output as they have some but not all the required skills.  
-- - `Candidate ID` `4004` has none of the needed requirements.


-- Solution
-- Solution for Puzzle 7: Mission to Mars
SELECT CandidateID
FROM Candidates
WHERE Description IN (SELECT Description FROM Requirements)
GROUP BY CandidateID
HAVING COUNT(DISTINCT Description) = (SELECT COUNT(*) FROM Requirements);


-- ==================================================
-- Solution for Puzzle 7
-- ==================================================

DROP TABLE IF EXISTS Candidates;
DROP TABLE IF EXISTS Requirements;

CREATE TABLE Candidates
(
CandidateID  INTEGER,
Occupation   VARCHAR(100),
PRIMARY KEY (CandidateID, Occupation)
);

INSERT INTO Candidates (CandidateID, Occupation) VALUES
(1001,'Geologist'),(1001,'Astrogator'),(1001,'Biochemist'),
(1001,'Technician'),(2002,'Surgeon'),(2002,'Machinist'),(2002,'Geologist'),
(3003,'Geologist'),(3003,'Astrogator'),(4004,'Selenologist');

CREATE TABLE Requirements
(
Requirement  VARCHAR(100) PRIMARY KEY
);

INSERT INTO Requirements (Requirement) VALUES
('Geologist'),('Astrogator'),('Technician');

SELECT  CandidateID
FROM    Candidates
WHERE   Occupation IN (SELECT Requirement FROM Requirements)
GROUP BY CandidateID
HAVING COUNT(*) = (SELECT COUNT(*) FROM Requirements);
