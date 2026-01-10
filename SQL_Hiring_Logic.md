# SQL Problem: Hiring Optimization (Candidates)

This dataset corresponds to a popular SQL interview question (often attributed to companies like Uber/Google) known as the "Candidates" or "Hiring Budget" problem.

## 1. Dataset Setup (The Logic for the Data)

Use this SQL to recreate the table shown in your image:

```sql
CREATE TABLE candidates (
    emp_id INTEGER PRIMARY KEY,
    experience VARCHAR(50),
    salary INTEGER
);

INSERT INTO candidates (emp_id, experience, salary) VALUES
(1, 'Junior', 10000),
(2, 'Junior', 15000),
(3, 'Junior', 4000),
(4, 'Senior', 16000),
(5, 'Senior', 20000),
(6, 'Senior', 50000);
```

## 2. The Problem Statement
**"Hire as many Seniors as possible with a budget of $70,000. Then, use any remaining budget to hire as many Juniors as possible."**

*(Note: The $70k budget is standard for this problem, but the logic works for any amount.)*

## 3. The Logic (Step-by-Step)

1.  **Seniors First:** Calculate the running total of Senior salaries. Stop before exceeding $70,000.
2.  **Calculate Remaining Budget:** (Total Budget $70,000) - (Cost of Hired Seniors).
3.  **Juniors Next:** Use the remaining budget to hire Juniors, finding the max count possible.
4.  **Combine:** Union the results.

## 4. The SQL Solution

Here is the robust query to solve this:

```sql
WITH Senior_Hires AS (
    SELECT 
        COUNT(*) as senior_count,
        ISNULL(SUM(salary), 0) as senior_cost
    FROM (
        SELECT salary, SUM(salary) OVER(ORDER BY salary) as running_cost
        FROM candidates
        WHERE experience = 'Senior'
    ) s
    WHERE running_cost <= 70000 -- Max Budget for Seniors
),
Junior_Hires AS (
    SELECT 
        COUNT(*) as junior_count
    FROM (
        SELECT salary, SUM(salary) OVER(ORDER BY salary) as running_cost
        FROM candidates
        WHERE experience = 'Junior'
    ) j
    WHERE running_cost <= (70000 - (SELECT senior_cost FROM Senior_Hires)) -- Remaining Budget
)
SELECT 'Senior' as experience, senior_count as hires FROM Senior_Hires
UNION ALL
SELECT 'Junior' as experience, junior_count as hires FROM Junior_Hires;
```

### Result on your Data:
*   **Seniors:** 2 Hires (Cost: 16k + 20k = 36k)
*   **Juniors:** 3 Hires (Cost: 4k + 10k + 15k = 29k < 34k Remaining)
*   **Total Hires:** 5
