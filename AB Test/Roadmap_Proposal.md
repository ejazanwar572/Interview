# Comprehensive Guide to Interview Testing Concepts
*Focus: Statistical Testing, A/B Testing, and Data Quality Testing for Analytics/Data Science*

This roadmap is designed to cover "every test basic, medium, and advanced concept" relevant to Data Analyst and Data Science interviews.

## Phase 1: The Basics (Foundations of Inference)
**Goal:** deeply understand *why* we test and the mathematical ground rules.

### 1. Probability & Distributions (The Prerequisite)
- [ ] **Random Variables:** Discrete vs Continuous.
- [ ] **Distributions:** Normal (Gaussian), Binomial, Bernoulli, Poisson, Exponential.
- [ ] **Central Limit Theorem (CLT):** Why everything converges to Normal.
- [ ] **Law of Large Numbers:** Convergence of sample mean to population mean.
- [ ] **Standard Error (SE) vs Standard Deviation (SD):** Critical interview distinction.

### 2. Hypothesis Testing Fundamentals
- [ ] **Null vs Alternative Hypothesis ($H_0$ vs $H_1$).**
- [ ] **Type I Error ($\alpha$) vs Type II Error ($\beta$).**
- [ ] **Significance Level ($\alpha$):** usually 0.05.
- [ ] **Statistical Power ($1 - \beta$):** usually 0.80.
- [ ] **P-value:** Accurate definition (NOT "probability that H0 is true").
- [ ] **Confidence Intervals:** Construction and interpretation.

### 3. Basic Parametric Tests
- [ ] **Z-test:** One-sample, Two-sample. When to use (known $\sigma$, $n > 30$).
- [ ] **T-test:** One-sample, Two-sample Independent, Paired T-test. (Student’s t-distribution).
- [ ] **ANOVA (Analysis of Variance):** Testing means across >2 groups.
- [ ] **Assumptions:** Normality, Homogeneity of Variance (Homoscedasticity), Independence.

---

## Phase 2: Medium Concepts (The Core of A/B Testing)
**Goal:** Master the practical application of experimentation in a business context.

### 1. Designing an Experiment (The Lifecycle)
- [ ] **Metric Selection:**
    - **OEC (Overall Evaluation Criterion) / North Star Metric.**
    - **Guardrail Metrics:** (e.g., Latency, Crash rate).
    - **Secondary/Debug Metrics.**
- [ ] **Sample Size Calculation:**
    - Inputs: MDE (Minimum Detectable Effect), Baseline Conversion Rate, Power, Alpha.
    - Impact of Variance on Sample Size.
- [ ] **Randomization (Bucketing):**
    - User-level vs Session-level randomization.
    - Hashing algorithms (md5 + salt).

### 2. Non-Parametric Tests (When assumptions fail)
- [ ] **Mann-Whitney U Test:** Comparing medians/distributions (skewed data like revenue).
- [ ] **Wilcoxon Signed-Rank Test:** Paired non-parametric.
- [ ] **Chi-Square Tests:**
    - Test of Independence (A/B conversion rates).
    - Goodness of Fit (Checking distribution).
- [ ] **Bootstrapping:** Resampling methods to estimate standard error/CIs without formulas.

### 3. Business Context & Validity
- [ ] **Duration estimation:** Why you shouldn't run a test for 4 hours.
- [ ] **Seasonality:** Day-of-week effects.
- [ ] **SRM (Sample Ratio Mismatch):** The #1 debugging check. If 50/50 split becomes 49/51, why?

---

## Phase 3: Advanced Concepts (Interview Differentiators)
**Goal:** Handle complex scenarios, platform challenges, and bias reduction.

### 1. Common Pitfalls & Biases
- [ ] **Peeking (Continuous Monitoring):** Why checking p-values daily increases Type I error. (Solution: Sequential Testing).
- [ ] **Novelty Effect:** Users clicking because it's new. & **Primacy Effect.**
- [ ] **Network Effects / Interference:** In 2-sided marketplaces (Uber/Lyft), Treatment affects Control.
- [ ] **Multiple Comparison Problem:** Testing 10 metrics increases false positive rate. (Corrections: Bonferroni, FDR/Benjamini-Hochberg).

### 2. Advanced Methods
- [ ] **CUPED (Controlled-Experiment Using Pre-Experiment Data):** Variance reduction technique to shorten tests.
- [ ] **Switchback / Crossover Experiments:** For marketplaces (Time-based splitting).
- [ ] **Cluster Randomization:** Randomizing by city or school instead of user.
- [ ] **Bayesian A/B Testing:**
    - Beta-Binomial conjugate pairs.
    - Expected Loss / Risk.
    - "Probability B is better than A" (intuitive interpretation).

### 3. Data Quality & Pipeline Testing (Engineering side)
*Increasingly asked in "Technical Analyst" interviews.*
- [ ] **Data Quality Tests:** Null checks, uniqueness checks, referential integrity (Tools: dbt tests, Great Expectations).
- [ ] **Unit Testing SQL/Python:** Mocking data frames to verify complex logic.

---

## Suggested Plan of Attack
1.  **Refine this list:** Delete irrelevant topics.
2.  **Resource gathering:** Assign 1-2 key readings/videos per topic.
3.  **Mock specific questions:** "How would you design a test for..."
