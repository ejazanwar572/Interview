# Interview Question Bank: A/B Testing & Product Sense

This document contains highly tested interview questions focusing on product sense, metric selection, and statistical reasoning, categorized by difficulty.

---

## Level 1: The Fundamentals (Basic Knowledge)

**1. Explain a p-value to a non-technical Product Manager.**

- _Bad Answer:_ "It's the probability that the null hypothesis is true."
- _Good Answer:_ "Assuming that our change had absolutely zero effect (the baseline), the p-value is the probability that we would see a result this extreme just by random luck. If the p-value is 0.03 (3%), it means there's only a 3% chance this jump in conversion was a total fluke. Since that's so low, we confidently conclude our change actually caused the jump."

**2. Why do we need a Control Group? Why not just compare week-over-week (Pre/Post analysis)?**

- _Answer:_ Seasonality and external factors. If you launch a feature on Black Friday and compare it to the week before, conversion will artificially spike. A Control group deployed at the exact same time controls for time-based, environmental, and external marketing changes, isolating the true causal effect of the feature.

**3. What is the difference between Statistical Significance and Practical Significance?**

- _Answer:_ Statistical Significance (p < 0.05) just means the result is highly unlikely to be due to chance. Practical Significance means the effect size is large enough to matter to the business. With a massive sample size (e.g., Google), you might detect a statistically significant 0.001% increase in clicks. But if it took 3 months of engineering time to build the feature, the practical (business) significance is basically zero and not worth launching.

---

## Level 2: Scenario Base (Medium / Product Sense)

**4. We ran an A/B test. The Treatment group showed a statistically significant increase in Click-Through Rate (CTR), but overall Revenue remained flat. Should we launch the feature?**

- _Answer:_ Usually, **no**, unless the specific goal was purely top-of-funnel engagement with no expectation of down-funnel impact.
- _Follow-up Analysis:_ Why did this happen?
  - **Cannibalization:** Users are clicking the new feature _instead_ of a more profitable older feature.
  - **Clickbait / Intent:** The button is larger and gets accidental clicks, but the users lack purchasing intent.
  - **Friction downstream:** The new UI funnel generates clicks, but throws an error or creates confusion on the checkout page.

**5. We tested a new feature for 3 days and got a p-value of 0.01. The PM wants to stop the test and launch immediately. What do you do?**

- _Answer:_ Absolutely not. Three days is not a full business cycle. We suffer from the **Peeking Problem** (checking early inflates false positives) and **Day-of-Week bias** (weekend users behave entirely differently than weekday users). We must run the test for the pre-calculated duration (e.g., 14 days) to capture true baseline variance.

**6. You calculated your required sample size as 100,000 users. After exactly 100,000 users, your p-value is 0.06 (just missing significance). The PM asks you to run it for just two more days to see if it drops below 0.05. Do you?**

- _Answer:_ No. This is "p-hacking" or continuous monitoring. By extending the test solely because you are close to the boundary, you fundamentally break the math of the test and inflate your Type I Error rate above 5%. If you feel the test was underpowered (maybe variance was historically higher than expected), you must design a brand new test with a larger required sample size and start over.

---

## Level 3: Advanced Methods & Trade-offs (Hard)

**7. How would you design an A/B test for a matching algorithm change in a ride-sharing app (Uber/Lyft)?**

- _Answer:_ You cannot use standard user-level randomization due to **Network Effects (Interference / SUTVA violation)**. If Driver A (Treatment) gets an optimized route, they accept a ride faster. That removes a passenger from the open market, meaning Driver B (Control) now has fewer passengers to choose from. Treatment directly harms Control.
- _Methodology:_ I would use **Switchback Testing (Time-based Randomization)** or **Cluster Randomization (City-based)**. In Switchback, I would take a single market (e.g., Austin) and apply the Treatment algorithm for 2 hours, then Control for 2 hours, randomly switching over weeks. This ensures the entire marketplace is operating under the same conditions at any given moment.

**8. You launch an A/B test. After 1 day, the Treatment conversion rate is 90%, and Control is 10%. Is the Treatment amazing?**

- _Answer:_ Highly unlikely. This screams **Sample Ratio Mismatch (SRM)** or a tracking bug. A 90% conversion rate is unheard of. I would first run a Chi-Square test to check if the traffic volume is actually an even 50/50 split. If Control received 10,000 users and Treatment received 1,000 users (instead of 5,500 each), there is an SRM. I would immediately halt the test and investigate the bucketing logic for latency, bugs, or bot interference.

**9. Explain CUPED and how it helps the business.**

- _Answer:_ Controlled-Experiment Using Pre-Experiment Data (CUPED) is a variance reduction technique. In any test, there is natural variance between users (some are high spenders, some are window shoppers). CUPED uses historical data from _before_ the test to "control" for that inherent user variance. By removing the historical noise, the standard error shrinks. A smaller standard error means increased statistical power, which allows the business to reach statistical significance faster (e.g., running a test for 2 weeks instead of 4 weeks) or detect much smaller MDEs.
