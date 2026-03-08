# Phase 3: Advanced Concepts & Pitfalls

Senior and Lead Data Science interviews focus heavily on what can go wrong during a test and how to test in complex environments like 2-sided marketplaces.

---

## 1. Common Pitfalls and Biases

Trusting a flawed test is worse than running no test at all.

### The Peeking Problem (Continuous Monitoring)

- **The Issue:** Product Managers love checking dashboards daily. If you check the p-value every day and stop the test the moment it dips below 0.05, you massively inflate your Type I Error (False Positive rate). You are capitalizing on random chance.
- **The Solution:**
  - Define the sample size upfront and do not look until the end.
  - Use **Sequential Testing** (e.g., SPRT), which mathematically adjusts the significance bounds to allow for continuous monitoring.

### Novelty and Primacy Effects

- **Novelty Effect:** Users interact with a new feature simply because it's new, causing a short-term spike in metrics (e.g., clicks). Over time, the effect wears off, and metrics drop back to baseline.
- **Primacy Effect:** The opposite. Users hate change. Metrics tank initially because users are confused, but over time they learn the new feature and metrics improve.
- **How to detect/solve:** Look at the metric over time. If the treatment effect converges with control over weeks, it was a novelty effect. You mitigate it by running the test longer (waiting for it to stabilize or "burn in").

### The Multiple Comparisons Problem

- **The Issue:** If you test 20 different metrics with $\alpha = 0.05$, the probability of getting at least one false positive is $1 - (1 - 0.05)^{20} \approx 64\%$. So, you are practically guaranteed to find _something_ "significant" just by chance.
- **The Solutions:**
  1.  Pick a single North Star metric upfront.
  2.  Use **Bonferroni Correction:** Divide alpha by the number of metrics (e.g., $\frac{0.05}{20} = 0.0025$). Very strict.
  3.  Use **FDR (False Discovery Rate) / Benjamini-Hochberg:** Controls the expected proportion of false discoveries in the rejected hypotheses. Less strict, better for exploratory testing.

---

## 2. Advanced Methodologies

### CUPED (Variance Reduction)

_Controlled-Experiment Using Pre-Experiment Data_

- **The Business Problem:** You want to detect a very small lift in a metric (small MDE). Mathematically, detecting small changes requires massive sample sizes, which means tests take weeks or months. The business wants to move faster.
- **The Core Idea:** In any group of users, there is huge natural variance (noise). Some users naturally spend $1,000/month, others spend $0. It is hard to see a $2 increase (the signal) over all that noise. CUPED uses historical data from _before_ the experiment to explain away that noise.
- **Intuitive Analogy 1 (The Weight Loss Pill):**
  - Imagine you are testing a new diet pill. If you give it to Group A and a placebo to Group B, and simply measure everyone's absolute weight after 30 days, your data will be incredibly noisy. Some people naturally weigh 120 lbs, others weigh 250 lbs. Finding a 2 lb difference caused by the pill is almost impossible amidst that natural human variance.
  - **The CUPED approach:** What if you measured everyone's weight _before_ the experiment started? You use their pre-experiment weight to predict 99% of their post-experiment weight. Instead of analyzing absolute weights, you subtract the pre-weight and only analyze the _residual difference_ (e.g., User A lost 2 lbs, User B gained 1 lb).
- **Intuitive Analogy 2 (The E-Commerce Store):**
  - Imagine you are testing a new checkout button. Control Group users spend an average of $50, Treatment Group users spend $52. Is the button working, or did Treatment just happen to randomly get more "whale" users who naturally spend $500?
  - **The CUPED approach:** You look at the users' purchase history from the 3 months _before_ the test. You realize the Treatment group naturally spends $2 more than the Control group anyway! By subtracting their historical spend (the covariate) from their current spend, you "control" for the whale users. Now you clearly see the button actually had $0 impact.
- **The Mathematical Result:** The variance of the _residual difference_ is massively smaller than the variance of the absolute metric. In statistics, shrinking the variance (Standard Error) directly increases your Statistical Power. More power means you can reach statistical significance with far fewer users, allowing you to cut a 4-week test down to 2 weeks.

### Network Effects (Interference)

The core assumption of standard A/B testing is SUTVA (Stable Unit Treatment Value Assumption): that the treatment of User A does not affect the outcome of User B.

- **The Problem:** In social networks (Meta/LinkedIn) or marketplaces (Uber/Airbnb), SUTVA is violated. If Uber gives User A a coupon, they take more rides. This depletes the supply of available drivers in that city, causing prices/wait times to rise for User B (in the Control group). Treatment negatively affects Control.
- **Solutions:**
  - **Cluster Randomization:** Instead of randomizing by user, randomize isolated clusters (e.g., Austin gets Treatment, Dallas gets Control).
  - **Switchback Testing (Crossover):** For ride-sharing. In a single city, turn the treatment ON for 2 hours, then OFF for 2 hours, alternating randomly.

---

## 3. Simpson's Paradox

A trend appears in different groups of data but disappears or reverses when these groups are combined.

- **A/B Test Context:** Your overall Conversion Rate drops in Treatment. You investigate and find that Conversion Rate actually _increased_ for Mobile users, and _increased_ for Desktop users. How is the total lower?
- **The Cause:** The treatment variant drastically shifted the _mix_ of traffic (e.g., maybe the treatment page loaded so fast on Mobile that suddenly Mobile users made up 90% of your traffic, but Mobile inherently has a lower baseline conversion rate than Desktop).
- **Takeaway:** Always check for shifting segment proportions between Control and Treatment.
