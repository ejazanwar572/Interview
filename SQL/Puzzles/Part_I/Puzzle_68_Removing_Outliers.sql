-- Puzzle 68 - Removing Outliers
--

-- In this puzzle, you have a dataset listing performance scores of different teams by year. Your task involves identifying and removing the most significant outlier from each team's yearly performance score. The outlier is defined as the performance score with the greatest deviation from the team's average score prior to removing any outliers. This outlier could be either the highest or the lowest performance score. Once the outlier is removed, calculate the average score for each team.

/*
| Team     | Year | Score |
|----------|------|-------|
| Cougars  | 2015 | 50    |
| Cougars  | 2016 | 45    |
| Cougars  | 2017 | 65    |
| Cougars  | 2018 | 92    |
| Bulldogs | 2015 | 65    |
| Bulldogs | 2016 | 60    |
| Bulldogs | 2017 | 58    |
| Bulldogs | 2018 | 12    |
*/

-- Here is the expected output.

/*
| Team     | Score |
|----------|-------|
| Cougars  | 53    |
| Bulldogs | 61    |
*/


-- ==================================================
-- Solution for Puzzle 68
-- ==================================================

DROP TABLE IF EXISTS Teams;

CREATE TABLE Teams (
Team    VARCHAR(50),
[Year]  INTEGER,
Score   INTEGER,
PRIMARY KEY (Team, Year)
);

INSERT INTO Teams (Team, [Year], Score) VALUES 
('Cougars', 2015, 50),
('Cougars', 2016, 45),
('Cougars', 2017, 65),
('Cougars', 2018, 92),
('Bulldogs', 2015, 65),
('Bulldogs', 2016, 60),
('Bulldogs', 2017, 58),
('Bulldogs', 2018, 12);

WITH
cte_SummaryStatistics AS
(
SELECT  AVG(Score) OVER (PARTITION BY Team) AS AverageScore
       ,a.*
FROM   Teams a
),
cte_RowNumber AS
(
SELECT  ROW_NUMBER() OVER (PARTITION BY Team ORDER BY ABS(Score - AverageScore) DESC) AS RowNumber,
        *
FROM    cte_SummaryStatistics
)
SELECT Team, AVG(Score) AS Score
FROM   cte_RowNumber
WHERE  RowNumber <> 1
GROUP BY Team;
