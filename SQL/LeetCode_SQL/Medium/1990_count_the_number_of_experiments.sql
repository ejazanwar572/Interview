-- 1990. Count the Number of Experiments
-- Difficulty: Medium
-- Description:
-- Write an SQL query to report the number of experiments done on each of the three platforms for each of the three experiment names. Notice that even if a valid pair (platform, experiment) has no experiments done, you should still report it with a count of 0.
-- Platforms: Android, IOS, Web.
-- Experiments: Reading, Sports, Programming.
-- Schema:
-- Table: Experiments
-- +-----------------+------+
-- | Column Name     | Type |
-- +-----------------+------+
-- | experiment_id   | int  |
-- | platform        | ENUM |
-- | experiment_name | ENUM |
-- +-----------------+------+
-- experiment_id is the primary key for this table.
-- Example Input/Output:
-- Output:
-- +----------+-----------------+-----------------+
-- | platform | experiment_name | num_experiments |
-- +----------+-----------------+-----------------+
-- | Android  | Reading         | 1               |
-- ...
-- +----------+-----------------+-----------------+
-- Solution:
WITH Platforms AS (
    SELECT 'Android' AS platform UNION ALL
    SELECT 'IOS' UNION ALL
    SELECT 'Web'
),
ExpNames AS (
    SELECT 'Reading' AS experiment_name UNION ALL
    SELECT 'Sports' UNION ALL
    SELECT 'Programming'
),
AllPairs AS (
    SELECT p.platform, e.experiment_name
    FROM Platforms p CROSS JOIN ExpNames e
)
SELECT
    ap.platform,
    ap.experiment_name,
    COUNT(e.experiment_id) AS num_experiments
FROM
    AllPairs ap
    LEFT JOIN Experiments e ON ap.platform = e.platform AND ap.experiment_name = e.experiment_name
GROUP BY
    ap.platform,
    ap.experiment_name
ORDER BY
    ap.platform,
    ap.experiment_name;
