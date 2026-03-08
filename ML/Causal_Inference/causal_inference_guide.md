# Causal inference and Uplift Modeling Interview Guide

## 1. Introduction & Problem Framing

### Correlation vs. Causation

In traditional machine learning, models are trained to find patterns and correlations in data. For instance, a model might predict that customers who buy diapers also buy beer. However, correlation does not imply causation—buying diapers doesn't _cause_ people to buy beer.

### What is Causal Inference?

Causal inference goes beyond prediction by asking _what-if_ questions. It aims to estimate the effect of an intervention (a cause) on an outcome.

- **Predictive ML asks:** "What will happen?" (e.g., Will this customer churn?).
- **Causal ML asks:** "What will happen _if we do X_?" (e.g., Will giving this customer a $10 discount stop them from churning?).

### What is Uplift Modeling?

Uplift modeling is a specific causal inference application that estimates the individual treatment effect (ITE) or conditional average treatment effect (CATE). The goal is to predict how much _better_ (the "uplift") an outcome will be if an action is taken compared to if no action is taken.

- **Business Scenario:** E-commerce promotions.
- **Target Population:** Customers.
- **Interventions (Treatments):** Sending a 20%, 40%, or 60% discount email (vs. sending no email, the Control).
- **Outcome:** Average Order Value (AOV), Conversion Rate, or Revenue.

The primary objective is to target those customers for whom the treatment provides the maximum positive uplift, avoiding unnecessary discounting for customers who would have bought anyway (the "Sure Things") or those who would never buy (the "Lost Causes").

---

## 2. Causal Inference Foundations

### The Potential Outcomes Framework (Rubin Causal Model)

To understand causation, we consider _potential outcomes_. For each individual $i$, let:

- $Y_i(1)$ be the outcome if treated ($T_i = 1$).
- $Y_i(0)$ be the outcome if not treated (Control, $T_i = 0$).

The **Individual Treatment Effect (ITE)** is $Y_i(1) - Y_i(0)$.
_The Fundamental Problem of Causal Inference:_ We can only observe one of these outcomes for any given individual. We cannot simultaneously treat and not treat the same person.

### Key Metrics

1.  **Average Treatment Effect (ATE):** The difference in mean outcomes between the treated and control groups across the entire population.
    - $ATE = E[Y_i(1) - Y_i(0)]$
2.  **Conditional Average Treatment Effect (CATE):** The average treatment effect conditioned on user features $X$. This is what Uplift Modeling estimates.
    - $CATE(x) = E[Y_i(1) - Y_i(0) | X_i = x]$

### Core Assumptions in Causal ML

For causal estimates to be valid, several assumptions must hold:

1.  **SUTVA (Stable Unit Treatment Value Assumption):** The treatment of one unit doesn't affect the outcome of another unit (no network effects), and there are no hidden variations of treatments.
    - _Example:_ If an e-commerce platform gives a discount code to User A, and User A shares it with User B (interference), or if "treated" means sending either a 10% or 50% discount without distinguishing them (hidden variations), SUTVA is violated. SUTVA holds if each user's purchasing behavior depends solely on whether they individually received a specific promotion.
2.  **Ignorability (Unconfoundedness):** Treatment assignment must be independent of the potential outcomes, given the observed covariates $X$. Randomized Controlled Trials (RCTs) naturally satisfy this.
    - _Example:_ In assessing the effect of an ad on sales, if the ad is disproportionately shown to past high-spenders, "past spending" confounds the effect. Ignorability requires that once we control for $X$ (like past spending), assignment to seeing the ad acts as if it were completely random for users with the same covariates.
3.  **Positivity (Overlap):** Every individual has a non-zero probability of receiving any of the treatments. $0 < P(T=1 | X) < 1$.
    - _Example:_ If a marketing email is never sent to users older than 65 due to a system rule, $P(T=1 | \text{Age} > 65) = 0$. This violates positivity. We cannot estimate the email's effect on this age group because there are no treated examples to learn from. Counterfactual estimation requires overlapping treated and control units across all subgroups.

---

## 3. Meta-Learners Deep Dive

Meta-learners are algorithms that use base ML models (like XGBoost, LightGBM, Random Forests) to estimate CATE. We will explore four main types: S-Learner, T-Learner, X-Learner, and R-Learner.

### 1. S-Learner (Single-Learner)

- **Concept:** Uses a single machine learning model to predict the outcome. The treatment indicator $T$ is included as just another input feature along with $X$.
- **Process:**
  1.  Train model $\mu(X, T)$ to predict $Y$.
  2.  Predict $CATE(x) = \mu(x, 1) - \mu(x, 0)$.
- **Pros:** Simple, uses more data to train the single model.
- **Cons:** If the treatment effect is small or the base model uses heavy regularization (like tree ensembles), it might completely ignore the $T$ feature, resulting in $CATE = 0$.

### 2. T-Learner (Two-Learner)

- **Concept:** Uses two separate models: one trained only on the control group, and one trained only on the treatment group.
- **Process:**
  1.  Train $\mu_0(X)$ using data where $T = 0$.
  2.  Train $\mu_1(X)$ using data where $T = 1$.
  3.  Predict $CATE(x) = \mu_1(X) - \mu_0(X)$.
- **Pros:** Simple, forces the model to capture differences between treated and control groups.
- **Cons:** If sample sizes are unbalanced (e.g., huge control group, tiny treatment group), $\mu_1(X)$ might overfit or struggle to learn compared to $\mu_0(X)$.

### 3. X-Learner

- **Concept:** An extension of the T-Learner designed specifically to better utilize information when treatment and control sample sizes are imbalanced. It uses information from the control group to derive better estimators for the treatment group, and vice versa.
- **Process:** (Simplified)
  1.  Train $\mu_0(X)$ and $\mu_1(X)$ (same as T-Learner).
  2.  Impute counterfactuals for all data. E.g., for treated units, estimate what they would have done in control: $\hat{D}^1_i = Y^1_i - \mu_0(X^1_i)$. Do opposite for control units.
  3.  Train two new models to predict these imputed effects: $\tau_1(X)$ predicts $\hat{D}^1$, $\tau_0(X)$ predicts $\hat{D}^0$.
  4.  Final CATE is a weighted average of $\tau_1(X)$ and $\tau_0(X)$, often weighted by propensity scores.
- **Pros:** Handles imbalanced datasets very well. Excellent empirical performance.
- **Cons:** Computationally expensive (requires training multiple models).

### 4. R-Learner (Residual-Learner)

- **Concept:** Conceptually elegant, proposed by Robinson (1988) and recently formalized by Nie & Wager (2020). It separates the "baseline effect" from the "treatment effect" by fitting models on _residuals_.
- **Process:**
  1.  **Outcome Model:** Train $m(X)$ to predict $Y$ (ignoring $T$). This captures the baseline expectation.
  2.  **Propensity Model:** Train $e(X)$ to predict $P(T=1 | X)$.
  3.  **Calculate Residuals:**
      - Outcome Residual: $\tilde{Y} = Y - m(X)$
      - Treatment Residual: $\tilde{T} = T - e(X)$
  4.  **Treatment Learner:** Train a model to predict $CATE(\tau(X))$ by minimizing a loss function that relies on the ratio of Outcome Residuals to Treatment Residuals.
- **Pros:** Minimizes confounding bias, isolates the exact causal effect signal better than S/T learners, robust when baseline effects are strong but causal effects are weak.
- **Cons:** Requires estimating propensity scores accurately; slightly complex implementation.

---

## 4. Model Evaluation & Validation

Since we cannot observe counterfactuals, standard metrics like RMSE or AUC can't be computed directly against true CATE values. We use proxy metrics instead.

### 1. Qini Curve & Qini Coefficient

Similar to an ROC/AUC curve but designed for uplift. It plots the cumulative incremental number of positive outcomes against the proportion of the targeted population, ordered by predicted uplift.

- A perfectly random model forms a straight line.
- A good model forms a curve bowed upwards, meaning it captures High-Uplift users first.

### 2. Uplift Curve & Area Under Uplift Curve (AUUC)

Comparable to Qini, but normalizes the treatment and control group sizes differently. It tracks the cumulative uplift per user bucket based on predicted CATE.

### 3. Synthetic Data Validation

As per the reference article, since true CATE is unknown, the most definitive way to validate architectures is by generating synthetic data where the true CATE _is_ known, generating predictions, and calculating standard regression metrics (RMSE) against the known CATE.

---

## 5. Interview Questions & Answers

**Q1: What is the fundamental difference between Predictive ML and Causal ML?**
_Answer:_ Predictive ML finds correlations to estimate "What will happen" (e.g., predicting churning probability). Causal ML estimates the effect of an intervention to answer "What will happen if we do X" (e.g., how much does offering a 20% discount reduce the probability of churning). Causal ML focuses on counterfactual reasoning.

**Q2: Can you explain the Fundamental Problem of Causal Inference?**
_Answer:_ The fundamental problem is that we can only observe one outcome per individual at a given time. We observe $Y(1)$ (treated) or $Y(0)$ (control), but never both simultaneously for the identical unit. Therefore, estimating individual treatment effect exactly ($Y(1) - Y(0)$) is intrinsically impossible; we must rely on statistical populations and assumptions to overcome missing counterfactuals.

**Q3: In Uplift Modeling, why would you choose an X-Learner over a T-Learner?**
_Answer:_ A T-Learner builds two separate models (control vs. treatment). If the data is highly imbalanced (e.g., 90% control group, 10% treatment group), the treatment model will likely overfit or lack training capability compared to the control model. The X-Learner solves this by cross-pollinating information—it uses the strong control model to impute counterfactuals for the treatment group, creating a much more stable estimator when data sizes dictate imbalance.

**Q4: Explain how an R-Learner works at a high level.**
_Answer:_ The R-Learner works by isolating causal signals using residuals. First, it trains an Outcome Learner to predict the outcome purely based on features, ignoring treatment. Second, it trains a Propensity model to estimate the probability of getting treated based on features. It then computes the residuals—the "unexplained" variance in outcome and treatment. Finally, it fits an Effect Learner on these residuals. By mapping unexplained treatment variance to unexplained outcome variance, it mathematically isolates the pure causal effect.

**Q5: How do you evaluate a Causal Machine Learning model if you don't have the ground truth for counterfactuals?**
_Answer:_ I would use two main techniques over observational/test data: First, Uplift curves and the Qini coefficient, which bucket users by predicted uplift and compare aggregate differences in treatment/control outcomes across quantile buckets to measure targeting efficiency. Second, since real validation is impossible empirically, I would validate the _architecture_ using synthetically generated data where the ground truth CATE is mathematically defined, ensuring my chosen meta-learner structure reliably recaptures the true CATE.

**Q6: What is a confounder, and how do we control for it?**
_Answer:_ A confounder is a variable that influences both the treatment assignment and the outcome variable, creating a spurious correlation that can mask or mimic a causal relationship. For example, "age" might affect both the likelihood of a doctor prescribing a drug (treatment) and the likelihood of patient recovery (outcome). To control for confounders, we must measure them and include them as covariates (features) in our models, or better yet, run a Randomized Controlled Trial (RCT) to break the link between confounders and treatment assignment.

**Q7: Describe a scenario where an S-Learner is a bad choice.**
_Answer:_ An S-Learner is a bad choice when using strong regularization (e.g., LASSO or heavily constrained Decision Trees) and the true treatment effect is very small relative to the baseline feature effects. The model will tend to push the feature weight of the treatment variable to zero, completely ignoring it. This results in the model predicting the exact same outcome for both treated and control counterfactuals, rendering the Conditional Average Treatment Effect essentially zero across the board.

**Q8: If your model predicts that giving a customer a discount increases their revenue by $15, but the discount costs $20, what is the business decision?**
_Answer:_ The business decision is to not give the discount. While there is positive behavioral uplift ($15 more spend), the margin-adjusted outcome is negative (Net Profit = Uplift - Cost = $15 - $20 = -$5). In causal ML for marketing, the final decision layer must always check against margin metrics or profitability formulas.

---

_(This guide serves as both a theoretical review and an interview-prep cheat sheet. A practical implementation of these concepts using the Hillstrom dataset and Scikit-Uplift / CausalML libraries is available in the accompanying Jupyter notebook.)_
