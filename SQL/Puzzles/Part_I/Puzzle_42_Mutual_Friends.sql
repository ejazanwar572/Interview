-- Puzzle 42 - Mutual Friends
--

-- The following table shows a cyclic data structure.

-- Given the following list of friend connections, determine the number of mutual connections between the friends.

/*
| Friend 1 | Friend 2 |
|----------|----------|
| Jason    | Mary     |
| Mike     | Mary     |
| Mike     | Jason    |
| Susan    | Jason    |
| John     | Mary     |
| Susan    | Mary     |
*/

-- Here is the expected output.

/*
| Friend 1 | Friend 2 | Mutual Friends |
|----------|----------|----------------|
| Jason    | Mary     | 2              |
| John     | Mary     | 0              |
| Jason    | Mike     | 1              |
| Mary     | Mike     | 1              |
| Jason    | Susan    | 1              |
| Mary     | Susan    | 1              |
*/

-- - Jason and Mary have 2 mutual friends: Mike and Susan.
-- - John and Mary have 0 mutual friends.
-- - Jason and Mike have 1 mutual friend: Mary.
-- - etc........


-- ==================================================
-- Solution for Puzzle 42
-- ==================================================

DROP TABLE IF EXISTS Friends;
DROP TABLE IF EXISTS Nodes;
DROP TABLE IF EXISTS Edges;
DROP TABLE IF EXISTS Nodes_Edges_To_Evaluate;

CREATE TABLE Friends
(
Friend1  VARCHAR(100),
Friend2  VARCHAR(100),
PRIMARY KEY (Friend1, Friend2)
);

INSERT INTO Friends (Friend1, Friend2) VALUES
('Jason','Mary'),('Mike','Mary'),('Mike','Jason'),
('Susan','Jason'),('John','Mary'),('Susan','Mary');

--Create reciprocals (Edges)
SELECT  Friend1, Friend2
INTO    Edges
FROM    Friends
UNION
SELECT  Friend2, Friend1
FROM Friends;

--Created Nodes
SELECT Friend1 AS Person
INTO   Nodes
FROM   Friends
UNION
SELECT  Friend2
FROM    Friends;

--Cross join all Edges and Nodes
SELECT  a.Friend1, a.Friend2, b.Person
INTO    Nodes_Edges_To_Evaluate
FROM    Edges a CROSS JOIN
        Nodes b
ORDER BY 1,2,3;

--Evaluates the cross join to the edges
WITH cte_JoinLogic AS
(
SELECT  a.Friend1
        ,a.Friend2
        ,'---' AS Id1
        ,b.Friend2 AS MutualFriend1
        ,'----' AS Id2
        ,c.Friend2 AS MutualFriend2
FROM   Nodes_Edges_To_Evaluate a LEFT OUTER JOIN
       Edges b ON a.Friend1 = b.Friend1 and a.Person = b.Friend2 LEFT OUTER JOIN
       Edges c ON a.Friend2 = c.Friend1 and a.Person = c.Friend2
),
cte_Predicate AS
(
--Apply predicate logic
SELECT  Friend1, Friend2, MutualFriend1 AS MutualFriend
FROM    cte_JoinLogic
WHERE   MutualFriend1 = MutualFriend2 AND MutualFriend1 IS NOT NULL AND MutualFriend2 IS NOT NULL
),
cte_Count AS
(
SELECT  Friend1, Friend2, COUNT(*) AS CountMutualFriends
FROM    cte_Predicate
GROUP BY Friend1, Friend2
)
SELECT  DISTINCT
        (CASE WHEN Friend1 < Friend2 THEN Friend1 ELSE Friend2 END) AS Friend1,
        (CASE WHEN Friend1 < Friend2 THEN Friend2 ELSE Friend1 END) AS Friend2,
        CountMutualFriends
FROM    cte_Count
ORDER BY 1,2;
