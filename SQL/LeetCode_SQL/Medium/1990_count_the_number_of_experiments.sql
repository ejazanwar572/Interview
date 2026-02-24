/*
1990. Count the Number of Experiments
Difficulty: Medium
Table Names: Experiments
Description:
Write an SQL query to report the number of experiments done on each of the three platforms for each of the three experiment names. Notice that even if a valid pair (platform, experiment) has no experiments done, you should still report it with a count of 0.
Platforms: Android, IOS, Web.
Experiments: Reading, Sports, Programming.
Schema:
Table: Experiments
| experiment_id   | int  |
| platform        | ENUM |
| experiment_name | ENUM |
Example Input/Output:
Output:
+----------+-----------------+-----------------+
| platform | experiment_name | num_experiments |
+----------+-----------------+-----------------+
| Android  | Reading         | 1               |
...
+----------+-----------------+-----------------+
*/

-- Write your MySQL query statement below:













-- Solution:
/*
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

*/


-- Create Table & Insert Data:
/*
USE practice_sql_db;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Experiments;
DROP TABLE IF EXISTS Experiments;
CREATE TABLE Experiments (
    experiment_id int,
    platform VARCHAR(255),
    experiment_name VARCHAR(255)
);

SET FOREIGN_KEY_CHECKS = 1;
*/
