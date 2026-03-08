# Phase 2: Medium Concepts & Product Sense

As a Data Scientist, knowing the math is only 50% of the job. The other 50% is **Product Sense**: knowing _what_ to test, _why_ it matters to the business, and accurately interpreting the results in a real-world scenario.

---

## 1. Designing the Experiment (The Lifecycle)

An experiment without a clear business goal is useless. In an interview, always establish the metrics _before_ discussing p-values.

### Metric Selection Hierarchy

- **OEC (Overall Evaluation Criterion) / North Star:** The primary metric that determines the success of the test. You usually only want **one** primary metric to avoid the multiple-testing problem (increasing false positives).
  - _Example:_ Conversion Rate, Average Revenue Per User (ARPU).
- **Guardrail Metrics:** Metrics that you are not actively trying to improve, but you absolutely cannot afford to tank. If the OEC goes up but a guardrail drops significantly, the test is a failure.
  - _Examples:_ Unsubscribe rate, app crash rate, page load latency, customer support ticket volume.
- **Secondary/Debug Metrics:** Metrics used to understand _why_ the OEC moved. Also called surrogate metrics or proxy metrics.
  - _Example:_ If OEC is Purchase Rate, secondary metrics might be "Add to Cart Rate" or "Time Spent on Page."

### Sample Size & Test Duration (Business Impact)

Data Scientists must balance statistical certainty with business velocity. Calculating sample size upfront is crucial to avoid "peeking" and stopping the test early.

#### 1. The Sample Size Formula

For comparing two proportions (like Conversion Rate), the required sample size **per variant** ($n$) is:

$$
n = \frac{2 \bar{p}(1-\bar{p}) (Z_{1-\alpha/2} + Z_{1-\beta})^2}{\text{MDE}^2}
$$

**Where:**

- $\bar{p}$ = The baseline conversion rate.
- $Z_{1-\alpha/2}$ = The Z-score for your chosen Significance Level (e.g., 1.96 for $\alpha = 0.05$).
- $Z_{1-\beta}$ = The Z-score for your chosen Statistical Power (e.g., 0.84 for $80\%$ power).
- $\text{MDE}$ = Minimum Detectable Effect (absolute difference, e.g., $0.02$).

#### 2. The Intuition (How levers affect Sample Size)

- **Smaller MDE $\rightarrow$ Massive Sample Size:** Because $\text{MDE}^2$ is in the denominator, trying to detect a 1% change requires _exponentially_ more users than detecting a 5% change.
- **Higher Power / Lower Alpha $\rightarrow$ Larger Sample Size:** If you want to be more certain (e.g., 90% power instead of 80%), the numerator grows, requiring more users.
- **Variance ($2\bar{p}(1-\bar{p})$):** The closer your baseline conversion rate is to 50%, the higher the natural variance, meaning you need more users to cut through the noise.

#### 3. Test Duration (The Business Check)

- **Why Calculate MDE?** The business doesn't care about a 0.0001% increase in conversion. It costs engineering resources to implement changes. MDE represents the smallest effect size that justifies the cost of the change.
- **Duration:** Never run a test for 4 hours just because you hit sample size. You must capture full business cycles.
  - _Rule of Thumb:_ Run tests in increments of full weeks (e.g., 7 days or 14 days) to account for **Day-of-Week Seasonality** (users behave differently on Tuesdays vs. Saturdays).

---

## 2. Sample Ratio Mismatch (SRM)

**The #1 sanity check in A/B testing.** SRM occurs when the actual traffic split differs significantly from the planned traffic split.

- **The Scenario:** You set up a 50/50 split between Control and Treatment. After a week, you see Control has 51,000 visitors and Treatment has 49,000 visitors.
- **How to test for it:** Use a **Chi-Square Goodness of Fit** test. If the p-value is < 0.001 (usually a very strict threshold is used for SRM), you have an SRM issue.
- **Why does it happen? (Interview Goldmine):**
  - _Latency:_ The Treatment variant takes longer to load, so users bounce before logging into the Treatment bucket.
  - _Bot traffic:_ Bots are skewing the randomization.
  - _Hashing algorithm bugs:_ The hash function (e.g., MD5) isn't distributing IDs evenly.
  - _Survivorship bias:_ You are tracking users deep in the funnel instead of at the point of randomization.
- **What to do:** Never analyze a test with SRM. You cannot trust the results. Stop the test, find the bug, fix it, and restart.

---

## 3. Non-Parametric Tests (When Math Fails Us)

Sometimes, business data violates the core assumptions of parametric tests like the T-test (specifically the assumption of normality, even with the Central Limit Theorem).

### When to use them:

- When data is heavily skewed and contains massive outliers, and your sample size isn't large enough to let the CLT save you.
- When evaluating medians or ranks instead of means.

### The Tests:

- **Mann-Whitney U Test (Wilcoxon Rank-Sum):** Compares the _distributions_ (often medians) of two independent groups. Useful when you have crazy outliers in revenue and want to see if one group consistently ranks higher than the other.
- **Chi-Square Test of Independence:** Used specifically for categorical variables (proportions). For example, finding if the proportion of users who clicked "Buy" (Yes/No) is independent of the group they are in (Control/Treatment).

### Bootstrapping

When standard formulas break down, we use computation.

- **Concept:** Resampling your existing data _with replacement_ thousands of times to estimate the sampling distribution.
- **Business use case:** Calculating confidence intervals for complex, non-standard metrics like ratio percentiles (e.g., the 99th percentile query latency).
