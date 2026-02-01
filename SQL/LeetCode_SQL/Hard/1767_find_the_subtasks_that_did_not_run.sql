-- 1767. Find the Subtasks That Did Not Run
-- Difficulty: Hard
-- Description:
-- Write an SQL query to reported the subtask_id of each task that did not execute for each task_id.
-- Schema:
-- Table: Tasks
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | task_id       | int     |
-- | subtasks_count| int     |
-- +---------------+---------+
-- task_id is the primary key for this table.
-- 
-- Table: Executed
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | task_id       | int     |
-- | subtask_id    | int     |
-- +---------------+---------+
-- (task_id, subtask_id) is the primary key for this table.
-- Example Input/Output:
-- Output:
-- +---------+------------+
-- | task_id | subtask_id |
-- +---------+------------+
-- | 1       | 2          |
-- | 2       | 1          |
-- | 2       | 2          |
-- +---------+------------+
-- Solution:
WITH RECURSIVE AllSubtasks AS (
    SELECT
        task_id,
        subtasks_count,
        1 AS subtask_id
    FROM
        Tasks
    UNION ALL
    SELECT
        task_id,
        subtasks_count,
        subtask_id + 1
    FROM
        AllSubtasks
    WHERE
        subtask_id < subtasks_count
)
SELECT
    a.task_id,
    a.subtask_id
FROM
    AllSubtasks a
    LEFT JOIN Executed e ON a.task_id = e.task_id AND a.subtask_id = e.subtask_id
WHERE
    e.subtask_id IS NULL
ORDER BY
    a.task_id,
    a.subtask_id;
