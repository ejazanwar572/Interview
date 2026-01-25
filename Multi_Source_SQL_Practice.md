# Multi-Platform Senior SQL Practice Guide (6+ Years Experience)

This guide curates the highest-signal SQL problems from diverse platforms, ensuring you aren't just "LeetCode good" but "Interview ready" for any company.

## 1. StrataScratch (Real FAANG Interview Questions)
*Focus: Real business scenarios and messy data.*

*   **[Highest Energy Consumption](https://platform.stratascratch.com/coding/10064-highest-energy-consumption)** (Meta/Facebook)
    *   *Concept:* `UNION ALL` + Aggregation. You receive data from multiple data centers (tables) and need to combine them to find the highest consumption.
*   **[Activity Rank](https://platform.stratascratch.com/coding/10351-activity-rank)** (Google)
    *   *Concept:* `ROW_NUMBER` vs `RANK`. Ranking users by email activity. Simple but strict on window function syntax.
*   **[Rank Variance Per Country](https://platform.stratascratch.com/coding/2007-rank-variance-per-country)** (Meta/Facebook)
    *   *Concept:* Complex windowing. Comparing the rank of a country's comments in Dec 2019 vs Jan 2020. Requires calculating rank *twice* and finding the delta.
*   **[Growth of Airbnb](https://platform.stratascratch.com/coding/9637-growth-of-airbnb)** (Airbnb)
    *   *Concept:* `LAG()` for Year-over-Year growth. Calculating the annual growth of hosts.
*   **[Top Percentile Fraud](https://platform.stratascratch.com/coding/10303-top-percentile-fraud)** (Netflix)
    *   *Concept:* `NTILE` or `PERCENT_RANK`. Identifying the top X% of fraudulent claims per state.
*   **[Premium vs Freemium](https://platform.stratascratch.com/coding/10300-premium-vs-freemium)** (Microsoft)
    *   *Concept:* Conditional Aggregation + Windowing. Comparing download counts of paying vs non-paying users by date.

## 2. HackerRank (Complex Logic Puzzles)
*Focus: Long, multi-step constraints.*

*   **[15 Days of Learning SQL](https://www.hackerrank.com/challenges/15-days-of-learning-sql/problem)** (The "Boss" Level)
    *   *Concept:* **Resurrected User Retention**. You need to find (1) the unique count of hackers who submitted *every day* since the start, and (2) the top hacker for the current day. This brings together recursive logic (or clever set math) and window functions.
*   **[Interviews](https://www.hackerrank.com/challenges/interviews/problem)**
    *   *Concept:* Analyzing a hierarchy of Contests -> Colleges -> Challenges -> Submissions. Tests your ability to `JOIN` 4-5 tables correctly without exploding row counts (handling 1:Many relationships).

## 3. DataLemur (Modern Tech Stack)
*Focus: Uber/Stripe/Fintech style questions.*

*   **[Active User Retention](https://datalemur.com/questions/active-user-retention)** (Facebook)
    *   *Concept:* Calculating Monthly Active Users (MAU) who were *also* active last month. Classic self-join or `lag()` problem.
*   **[Y-on-Y Growth Rate](https://datalemur.com/questions/yoy-growth-rate)** (Wayfair)
    *   *Concept:* Calculating Year-over-Year growth using `LAG()` to get the previous year's spend and handling division by zero/nulls.
*   **[Card Launch Success](https://datalemur.com/questions/card-launch-success)** (JPMorgan Chase)
    *   *Concept:* `FIRST_VALUE()` or `RANK()`. Finding the *first* month a credit card was issued and its total spend.
*   **[Repeated Payments](https://datalemur.com/questions/repeated-payments)** (Stripe)
    *   *Concept:* Fraud Detection logic. Finding transactions with the *same* amount, *same* merchant, and *same* card within a 10-minute window (Timestamp difference).
*   **[Rolling 3 Day Earnings](https://datalemur.com/questions/rolling-3-day-earnings)** (Fintech)
    *   *Concept:* `ROWS BETWEEN 2 PRECEDING AND CURRENT ROW`. Calculating a moving average/sum over a specific time window.

## 4. InterviewQuery (Data Science Focus)
*Focus: Analytics, Metrics, and Business Logic.*

*   **[Employee Retention](https://www.interviewquery.com/questions/employee-retention)**
    *   *Concept:* `CASE WHEN` to track employee status (Joined vs Left). Calculating retention rate over time.
*   **[Upsell Transactions](https://www.interviewquery.com/questions/upsell-transactions)**
    *   *Concept:* Identifying customers who bought a specific product pattern (e.g., A then B).
*   **[User Streaks](https://www.interviewquery.com/questions/user-streaks)**
    *   *Concept:* **Gaps and Islands** (The hard version). Finding the longest continuous streak of daily logins.

## 5. System Design & Data Modeling (The "Senior" Differentiator)
*Focus: How you structure data before querying it.*

*   **Scenario:** Design a database for a "Ride Sharing App" (like Uber).
    *   *Tables:* `Users`, `Drivers`, `Rides`, `Payments`.
    *   *Hard Question:* "How would you design the schema to efficiently store and query the *live location* of drivers for the request matching algorithm? Would you store it in the main SQL DB?" (Hint: No, usually Redis/Geo-spatial index).
*   **Scenario:** Managing a "History" table for Audit.
    *   *Question:* "We need to track every change to a user's profile. Design the `UserHistory` table. How do you query 'What was the user's email on Jan 1st' efficiently?" (Hint: Slowly Changing Dimensions Type 2).

## Recommended Practice Path:
1.  **Warm-up:** StrataScratch "Highest Energy Consumption" (Meta).
2.  **Core Project:** DataLemur "Active User Retention" (The most common real-world metric).
3.  **The Challenge:** HackerRank "15 Days of Learning SQL" (If you can solve this, you can solve anything).
