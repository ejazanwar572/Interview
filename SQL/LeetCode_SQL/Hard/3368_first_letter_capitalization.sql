-- 3368. First Letter Capitalization
-- Difficulty: Hard
-- Description:
--     - Database
-- 
-- ## Description
-- 
-- Table: user_content
-- 
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | content_id  | int     |
-- | content_text| varchar |
-- +-------------+---------+
-- content_id is the unique key for this table.
-- Each row contains a unique ID and the corresponding text content.
-- 
-- Write a solution to transform the text in the content_text column by applying the following rules:
-- 
-- 	- Convert the first letter of each word to uppercase
-- 	- Keep all other letters in lowercase
-- 	- Preserve all existing spaces
-- 
-- Note: There will be no special character in content_text.
-- 
-- Return the result table that includes both the original content_text and the modified text where each word starts with a capital letter.
-- 
-- The result format is in the following example.
-- 
-- Example:
-- 
-- Input:
-- 
-- user_content table:
-- 
-- +------------+-----------------------------------+
-- | content_id | content_text                      |
-- +------------+-----------------------------------+
-- | 1          | hello world of SQL                |
-- | 2          | the QUICK brown fox               |
-- | 3          | data science AND machine learning |
-- | 4          | TOP rated programming BOOKS       |
-- +------------+-----------------------------------+
-- 
-- Output:
-- 
-- +------------+-----------------------------------+-----------------------------------+
-- | content_id | original_text                     | converted_text                    |
-- +------------+-----------------------------------+-----------------------------------+
-- | 1          | hello world of SQL                | Hello World Of Sql                |
-- | 2          | the QUICK brown fox               | The Quick Brown Fox               |
-- | 3          | data science AND machine learning | Data Science And Machine Learning |
-- | 4          | TOP rated programming BOOKS       | Top Rated Programming Books       |
-- +------------+-----------------------------------+-----------------------------------+
-- 
-- Explanation:
-- 
-- 	- For content_id = 1:
-- 		- Each word's first letter is capitalized: Hello World Of Sql
-- 	- For content_id = 2:
-- 		- Original mixed-case text is transformed to title case: The Quick Brown Fox
-- 	- For content_id = 3:
-- 		- The word AND is converted to &quot;And&quot;: &quot;Data Science And Machine Learning&quot;
-- 	- For content_id = 4:
-- 		- Handles word TOP rated correctly: Top Rated
-- 		- Converts BOOKS from all caps to title case: Books
-- 
-- Solution:
WITH RECURSIVE
    capitalized_words AS (
        SELECT
            content_id,
            content_text,
            SUBSTRING_INDEX(content_text, ' ', 1) AS word,
            SUBSTRING(
                content_text,
                LENGTH(SUBSTRING_INDEX(content_text, ' ', 1)) + 2
            ) AS remaining_text,
            CONCAT(
                UPPER(LEFT(SUBSTRING_INDEX(content_text, ' ', 1), 1)),
                LOWER(SUBSTRING(SUBSTRING_INDEX(content_text, ' ', 1), 2))
            ) AS processed_word
        FROM user_content
        UNION ALL
        SELECT
            c.content_id,
            c.content_text,
            SUBSTRING_INDEX(c.remaining_text, ' ', 1),
            SUBSTRING(c.remaining_text, LENGTH(SUBSTRING_INDEX(c.remaining_text, ' ', 1)) + 2),
            CONCAT(
                c.processed_word,
                ' ',
                CONCAT(
                    UPPER(LEFT(SUBSTRING_INDEX(c.remaining_text, ' ', 1), 1)),
                    LOWER(SUBSTRING(SUBSTRING_INDEX(c.remaining_text, ' ', 1), 2))
                )
            )
        FROM capitalized_words c
        WHERE c.remaining_text != ''
    )
SELECT
    content_id,
    content_text AS original_text,
    MAX(processed_word) AS converted_text
FROM capitalized_words
GROUP BY 1, 2;
