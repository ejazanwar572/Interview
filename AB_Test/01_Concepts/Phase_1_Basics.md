# Phase 1: The Basics (Foundations of Inference)

## 1. Probability Distributions

A **Probability Distribution** is a mathematical function that provides the probabilities of occurrence of different possible outcomes for an experiment.

### Key Concepts

- **Random Variable:** A variable whose values depend on outcomes of a random phenomenon.
  - **Discrete:** Countable outcomes (e.g., number of heads in 10 coin flips).
  - **Continuous:** Infinite possible values within a range (e.g., height, time).
- **PMF (Probability Mass Function):** Used for **Discrete** variables. Gives the probability that a discrete random variable is exactly equal to some value.
- **PDF (Probability Density Function):** Used for **Continuous** variables. The probability of the variable falling within a particular range of values is given by the integral of the variable's density over that range. **Note:** The probability of a continuous random variable taking exactly any single value is 0.
- **CDF (Cumulative Distribution Function):** The probability that the variable takes a value less than or equal to $x$. Works for both discrete and continuous.

### Common Distributions in Data Science

| Distribution          | Type       | Description                                                                              | Interview Use Case                                                                       |
| :-------------------- | :--------- | :--------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------- |
| **Normal (Gaussian)** | Continuous | Bell-shaped, symmetric. Defined by Mean ($\mu$) and Std Dev ($\sigma$). 68-95-99.7 Rule. | Modeling natural phenomena (height, errors). Assumption for many tests (t-test, Z-test). |
| **Bernoulli**         | Discrete   | Single trial with 2 outcomes (Success/Failure). $p$ = prob of success.                   | Modeling a single user click (Click/No Click).                                           |
| **Binomial**          | Discrete   | Number of successes in $n$ independent Bernoulli trials.                                 | Predicting number of users who convert out of 1000 visitors.                             |
| **Poisson**           | Discrete   | Number of events in a fixed interval of time/space. Constant mean rate $\lambda$.        | Modeling arrival of tickets in a support queue or server requests per minute.            |
| **Exponential**       | Continuous | Time _between_ events in a Poisson process. Memoryless property.                         | Predicting time until the next customer purchase or server failure.                      |
| **Uniform**           | Continuous | All values in range $[a, b]$ are equally likely.                                         | Random number generation; null model where no outcome is preferred.                      |

---

## 2. The Central Limit Theorem (CLT)

**The Holy Grail of Statistics.**

### Definition

The CLT states that the **sampling distribution of the sample mean** will be approximately **normally distributed**, regardless of the population's distribution, provided the sample size is sufficiently large (usually $n \ge 30$).

### Why it matters for Data Science?

- **Inference on Non-Normal Data:** Even if your user data is skewed (e.g., LTV or session duration is exponential/log-normal), if you take the mean of enough users, that mean follows a normal distribution.
- **A/B Testing:** This allows us to use parametric tests (like t-tests) on metrics like Average Revenue Per User (ARPU) even if the underlying revenue data is non-normal.

### Law of Large Numbers (LLN)

As the sample size ($n$) grows, the sample mean ($\bar{x}$) gets closer and closer to the true population mean ($\mu$).

- **Difference from CLT:** LLN tells you _where_ the center is going (accuracy); CLT tells you about the _shape_ of the distribution around that center (precision/normality).

---

## 3. Hypothesis Testing Fundamentals

The formal procedure to accept or reject statistical statements.

### Core Terminology

- **Null Hypothesis ($H_0$):** The default state. "There is no difference," "The coin is fair," "The new feature changed nothing."
- **Alternative Hypothesis ($H_1$ or $H_a$):** The claim you want to test. "There is a difference," "The coin is biased."
- **Significance Level ($\alpha$):** The probability of rejecting $H_0$ when it is actually true. Usually set to 0.05 (5%).
- **Power ($1 - \beta$):** The probability of correctly rejecting $H_0$ when it is false. Usually aim for 0.80 (80%).
- **P-value:** The probability of observing a test statistic as extreme as, or more extreme than, the one observed, **assuming $H_0$ is true**.
  - _Interview Tip:_ Never say "Probability that $H_0$ is true." Say "Probability of data given $H_0$."
  - If $p < \alpha$: Reject $H_0$ (Statistically Significant).
  - If $p \ge \alpha$: Fail to reject $H_0$.

### Errors

| Decision                 | $H_0$ is True                                     | $H_0$ is False                                    |
| :----------------------- | :------------------------------------------------ | :------------------------------------------------ |
| **Reject $H_0$**         | **Type I Error** ($\alpha$) <br> "False Positive" | Correct Decision <br> (Power)                     |
| **Fail to Reject $H_0$** | Correct Decision                                  | **Type II Error** ($\beta$) <br> "False Negative" |

---

## 4. Standard Error (SE) vs Standard Deviation (SD)

_The most common "gotcha" question._

### Standard Deviation (SD)

- **Measures:** Variability of the **data points** themselves.
- **Context:** Descriptive statistics. "How spread out are the heights of people in this room?"
- **Formula:** $\sigma = \sqrt{\frac{\sum(x - \mu)^2}{N}}$

### Standard Error (SE)

- **Measures:** Variability of the **sample mean** (or other statistic).
- **Context:** Inferential statistics. "If I took 100 different samples of people, how much would the average height vary across those samples?"
- **Formula (Continuous Means):** $SE = \frac{\sigma}{\sqrt{n}}$
- **Key Insight:** SE decreases as sample size ($n$) increases (because dividing by $\sqrt{n}$). SD does _not_ decrease with $n$ (it stabilizes).

### Standard Error in A/B Testing (Proportions)

In A/B testing, the **Z-value is directly defined using the Standard Error (SE)**.
Conceptually:

> **Z-score = (Observed difference) ÷ (Standard error of that difference)**

This connects hypothesis testing with sampling variability.

#### 1. Relationship Between Z-Value and Standard Error

$$
Z = \frac{\text{Observed Difference} - \text{Expected Difference}}{\text{Standard Error}}
$$

In most A/B tests, the **expected difference under the null hypothesis is 0**, so:

$$
Z = \frac{p_A - p_B}{SE}
$$

where:

- $p_A$ = conversion rate of group A
- $p_B$ = conversion rate of group B
- $SE$ = **standard error of the difference in proportions**

#### 2. Standard Error Formula

For proportions, the **standard error** is:

$$
SE = \sqrt{p(1-p)\left(\frac{1}{n_A} + \frac{1}{n_B}\right)}
$$

where:

- $p$ = pooled conversion rate
- $n_A, n_B$ = sample sizes

**Calculating the Pooled Conversion Rate ($p$):**

$$
p = \frac{\text{Total Conversions}}{\text{Total Users}} = \frac{X_A + X_B}{n_A + n_B} = \frac{p_A n_A + p_B n_B}{n_A + n_B}
$$

_(where $X_A$ and $X_B$ are the absolute number of conversions in each group)._

_(Note: The pooled probability $p$ appears in the SE formula because under the null hypothesis, we assume there is no difference between the two groups. Therefore, pooling all successes together provides the most accurate estimate of the true underlying probability)._

#### 3. Why Standard Error Appears in the Z Formula

Standard error measures **how much the estimated difference would vary if we repeated the experiment many times**.

**Interpretation:**

| Component   | Meaning                       |
| ----------- | ----------------------------- |
| $p_A - p_B$ | observed effect               |
| $SE$        | expected random variation     |
| $Z$         | effect size relative to noise |

So the Z-score answers:

> **How large is the observed effect compared to the random variability of the estimate?**

#### 4. Intuition Example

Suppose:

- Difference in conversion = **0.03**
- Standard error = **0.01**

$$
Z = 0.03 / 0.01 = 3
$$

**Meaning:** The effect is **3 standard errors away from zero**, which is statistically significant ($Z > 1.96$ corresponds to a p-value of $< 0.05$).

#### 5. Why Larger Samples Reduce Standard Error

Standard error depends on sample size:

$$
SE \propto \frac{1}{\sqrt{n}}
$$

So when **sample size increases**:

- $SE$ becomes smaller
- $Z$ becomes larger for the same effect

This is precisely why **large experiments can detect smaller effects** (Minimum Detectable Effect decreases as $n$ increases).

#### 6. Conceptual Summary

A/B testing significance essentially follows this structured narrative:

| Step                 | Concept                  |
| -------------------- | ------------------------ |
| Estimate effect      | $p_A - p_B$              |
| Estimate uncertainty | Standard Error           |
| Standardize effect   | Z-score                  |
| Compare to threshold | Statistical Significance |

---

## 5. Z-test vs T-test (Parametric Tests)

| Feature                              | Z-test                         | T-test                                                              |
| :----------------------------------- | :----------------------------- | :------------------------------------------------------------------ |
| **Population Variance ($\sigma^2$)** | **Known**                      | **Unknown** (Estimated by sample $s^2$)                             |
| **Sample Size ($n$)**                | Generally Large ($n > 30$)     | Small ($n < 30$) (though often used for large $n$ too via software) |
| **Distribution**                     | Standard Normal Z-distribution | Student's t-distribution (Heavier tails than Normal)                |
| **Degrees of Freedom**               | N/A                            | $df = n - 1$ (flatter tails for lower $df$)                         |

**Interview Rule of Thumb:** In the real world, we rarely know $\sigma$, so we almost always use **T-tests** (or Welch's T-test for unequal variances), even for large samples, because the T-distribution converges to Normal as $n \to \infty$.
