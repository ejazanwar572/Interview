# Advanced Statistics and Machine Learning
*Detailed Interview Questions, Mathematical Deep Dives, and Solutions for Google Product DS*

Google Product DS interviews often start high-level and then drill very deep into the underlying math, assumptions, and edge cases. This guide provides those deep dives.

---

## 1. Probability & Combinatorics (Deep Dive)
Interviewers test if you can translate business logic into probability math.

### Scenario 1.1: Bayes' Theorem & the Base Rate Fallacy
**Question**: "We deployed a new algorithm to ban fake accounts. The model has a True Positive Rate (Sensitivity) of $99\%$ and a False Positive Rate of $5\%$. We know historically that only $1\%$ of our daily active users (DAUs) are actually fake accounts. If the algorithm flags a user, what is the exact probability that the user is actually fake?"

**Solution Breakdown**:
1.  **Define the Events**:
    *   $P(Fake)$ = Base rate of fake accounts = $0.01$
    *   $P(Real)$ = $1 - 0.01 = 0.99$
    *   $P(Flag | Fake)$ = True Positive Rate = $0.99$
    *   $P(Flag | Real)$ = False Positive Rate = $0.05$
2.  **Apply Bayes' Theorem**:
    We want $P(Fake | Flag) = \frac{P(Flag | Fake) \cdot P(Fake)}{P(Flag)}$
3.  **Calculate the Law of Total Probability ($P(Flag)$)**:
    $P(Flag) = P(Flag | Fake)P(Fake) + P(Flag | Real)P(Real)$
    $P(Flag) = (0.99 \times 0.01) + (0.05 \times 0.99)$
    $P(Flag) = 0.0099 + 0.0495 = 0.0594$
4.  **Final Calculation**:
    $P(Fake | Flag) = \frac{0.0099}{0.0594} \approx 0.166$ or **16.6%**
**Interview Pivot**: The interviewer asks, "So 5 out of 6 banned users are real humans. This is unacceptable. How do you fix this?"
**Your Response**: I would raise the classification threshold of the model to decrease the False Positive Rate, accepting a lower True Positive Rate, because the cost of banning a real user (churn, bad PR, support tickets) heavily outweighs the cost of missing a fake account. I would also feed flagged users into a secondary verification step (like CAPTCHA or SMS verification) rather than an instant ban.

---

## 2. Advanced A/B Testing & Experimentation
Testing is rarely as simple as a basic T-test. You will be tested on SUTVA violations, network effects, and test duration.

### Scenario 2.1: SUTVA Violations & Network Effects
**Question**: "Google Maps wants to test a new routing algorithm that diverts users around traffic differently. If we randomize users into Control and Treatment, we see Treatment users arrive 10% faster. Should we launch?"

**Solution Breakdown**:
1.  **Identify the Flaw**: A standard user-level randomized A/B test fails here due to **interference** (a violation of SUTVA - Stable Unit Treatment Value Assumption). 
2.  **Explain the Network Effect**: If the Treatment group is heavily diverted to "back roads," it clears up the main highway for the Control group. Both groups affect each other. If we launch to 100% of users, the "back roads" will become instantly congested, and the 10% speed gain will vanish.
3.  **Propose the Correct Solution**:
    *   **Switchback Testing (Time-based serialization)**: Alternate the algorithm globally in time windows (e.g., Algorithm A for 1 hour, Algorithm B for the next hour). This controls for geo-interference but requires rigorous smoothing for time-of-day effects.
    *   **Geo-Experimentation**: Randomize by isolated geographical clusters (e.g., test in Seattle, hold out Portland). Compare the treatment cities against synthetic control cities weighted over historical data (CausalImpact / Difference-in-Differences).

### Scenario 2.2: Sample Size & Peeking
**Question**: "An A/B test has been running for 3 days. The PM looks at the dashboard and sees a P-value of 0.02. They want to stop the test and launch immediately. What do you say?"

**Solution Breakdown**:
1.  **Stop them (The "Peeking" Problem)**: Explain that checking a test continuously inflates the Type 1 Error ($\alpha$). If you check a test every day, the chance of seeing a false positive skyrockets beyond your set $5\%$ limit.
2.  **Explain the Math (Sample Size)**: Remind them of the strict sample size requirements. 
    *   Standard formula per variant: $n = \frac{(Z_{1-\alpha/2} + Z_{1-\beta})^2 \cdot 2\sigma^2}{\delta^2}$
    *   Where $Z$ values dictate power and significance, $\sigma^2$ is baseline variance, and $\delta$ is the Minimum Detectable Effect. 
3.  **Solutions for Peeking**: If the PM insists on stopping tests early to save resources, propose implementing **Sequential Testing** (like SPRT - Sequential Probability Ratio Test or Bayesian A/B testing approaches with Expected Loss limits) which are mathematically designed to allow early stopping.

---

## 3. Regression & Statistical Modeling
You need to explain exactly how models behave under the hood.

### Scenario 3.1: Interpreting Logistic Regression
**Question**: "We ran a logistic regression to predict whether a user will upgrade to YouTube Premium. The coefficient ($\beta$) for the feature `days_active_last_month` is 0.4. What exactly does 0.4 mean?"

**Solution Breakdown**:
1.  **Define the output**: Logistic regression models the **log-odds** of an event. 
    Equation: $\ln(\frac{p}{1-p}) = \beta_0 + \beta_1X_1$
2.  **Interpret the Coefficient**: A 1-unit increase in $X$ results in a $\beta$ increase in the *log-odds*. To understand the real-world impact, we exponentiate it: $e^{0.4} \approx 1.49$.
3.  **Final Business Answer**: "For every additional day a user is active in the last month, the **odds** of them upgrading to Premium increase by 49%, holding all other variables constant." (Ensure you say *odds*, not *probability*).

### Scenario 3.2: Multicollinearity in Linear Models
**Question**: "You build a regression model to predict LTV. You include both `total_clicks` and `total_impressions` as features. The model's $R^2$ is high, but the coefficient for `total_clicks` is surprisingly negative. Why?"

**Solution Breakdown**:
1.  **Diagnose**: This is classic **Multicollinearity**. `Clicks` and `Impressions` are highly correlated. 
2.  **Explain the Math**: In OLS (Ordinary Least Squares), highly correlated features cause the variance of their coefficient estimates to blow up. The matrix $(X^TX)^{-1}$ becomes nearly singular, making the individual $\beta$ weights unstable and uninterpretable, even if the overall model predicts well.
3.  **Fix**: 
    1.  Feature engineering: Combine them into a single feature like `Click-Through-Rate (CTR)`.
    2.  Regularization: Apply **Ridge Regression (L2)** or **Lasso (L1)**, which adds a penalty term $(\lambda \sum \beta^2$ or $\lambda \sum |\beta|)$ to shrink weights or drop degenerate features.

---

## 4. Applied Machine Learning (Product DS)
Algorithms in the context of business deployments.

### Scenario 4.1: The Imbalanced Dataset Problem
**Question**: "You are building a model to predict fraudulent transactions on Google Pay. Fraud accounts for 0.05% of all transactions. You build a Random Forest that achieves 99.9% accuracy. Should we deploy this model?"

**Solution Breakdown**:
1.  **Reject Accuracy as a Metric**: Explain the **Accuracy Paradox**. A naive model that simply predicts "Not Fraud" for every single transaction will be $99.95\%$ accurate, but entirely useless.
2.  **Propose Better Metrics**:
    *   **Precision**: Of the transactions we flagged as fraud, how many were actually fraud? (Crucial to avoid falsely blocking legitimate users from spending money).
    *   **Recall**: Of all the actual fraudulent transactions, how many did we catch? (Crucial to stop financial loss).
    *   **F1-Score / PR-AUC**: Use the Area Under the Precision-Recall Curve instead of ROC-AUC, because ROC curves are highly deceptive when the negative class massively outweighs the positive class (the False Positive Rate stays artificially low).
3.  **Propose Model Fixes**:
    *   Loss Function: Use weighted cross-entropy to severely penalize the model for missing the minority class.
    *   Sampling: Down-sample the majority class or use SMOTE (Synthetic Minority Over-sampling Technique) before training.
