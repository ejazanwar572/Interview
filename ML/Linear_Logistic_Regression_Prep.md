# Linear & Logistic Regression: Comprehensive Interview Guide

## Part 1: Linear Regression

**Objective:** Predict a continuous numerical outcome based on one or more independent variables by fitting a linear equation to observed data.

### 1. The Core Equation (Statistical vs. ML Terminology)

**Statistical Terminology:**
The hypothesis function is:
$$ y = \beta_0 + \beta_1x_1 + \beta_2x_2 + ... + \beta_nx_n + \epsilon $$

- $y$: Dependent variable (target).
- $\beta_0$: Intercept (value of $y$ when all $x$ are 0).
- $\beta_i$: Coefficients (impact of a 1-unit change in $x_i$ on $y$).
- $\epsilon$: Error term (unexplained variance/noise).

**Machine Learning Terminology (via Google ML Crash Course):**
$$ y' = b + w_1x_1 + w_2x_2 + ... + w_nx_n $$

- $y'$: Predicted **label** (the output).
- $b$: **Bias** (same as the y-intercept / $\beta_0$).
- $w_i$: **Weights** (same as the slope / coefficients / $\beta_i$). calculated during training.
- $x_i$: **Feature** (the input).

_Note: In ML, training a model means calculating the optimal weights ($w$) and bias ($b$) that minimize a loss function._

### 2. Cost Function & Optimization

- **Cost Function:** Mean Squared Error (MSE) or Sum of Squared Errors (SSE). The goal is to minimize the difference between predicted and actual values.
- **Ordinary Least Squares (OLS):** A closed-form mathematically exact solution to find the coefficients that minimize SSE.
- **Gradient Descent:** An iterative optimization algorithm used when the dataset is too large for OLS, adjusting coefficients step-by-step using a learning rate.

### 3. The 5 Key Assumptions (L.I.N.E.M)

_Interviewers frequently ask about these and how to verify them._

1. **[L]inearity:** The relationship between independent variables and the mean of the dependent variable is linear. (Check: Scatter plots).
2. **[I]ndependence:** Observations are independent of each other (no autocorrelation). Important in time-series. (Check: Durbin-Watson test).
3. **[N]ormality of Residuals:** The residuals (errors) follow a normal distribution. (Check: Q-Q Plot, Shapiro-Wilk test).
4. **[E]qual Variance (Homoscedasticity):** The variance of residuals is constant across all predicted values. (Check: Residuals vs. Fitted plot - look for a funnel shape if violated, meaning heteroscedasticity).
5. **[M]ulticollinearity (Absence of):** Independent variables are not highly correlated with each other. (Check: Correlation matrix, Variance Inflation Factor (VIF > 5 or 10 indicates an issue)).

### 4. Evaluation Metrics

- **R-squared ($R^2$):** Proportion of variance in the dependent variable explained by the model (0 to 1). Problem: Increases even if you add junk variables.
- **Adjusted $R^2$:** Adjusts for the number of predictors. It penalizes adding useless variables. Always use this over standard $R^2$ for multiple regression.
- **RMSE (Root Mean Squared Error):** Interpretable in the same units as the target variable. Penalizes large errors heavily.
- **MAE (Mean Absolute Error):** Less sensitive to outliers than RMSE.

### 5. Regularization (Ridge vs. Lasso)

Used to prevent overfitting by adding a penalty to the loss function based on the magnitude of the coefficients.

- **L1 / Lasso (Least Absolute Shrinkage and Selection Operator):** Adds the absolute value of coefficients as a penalty. Can shrink coefficients to exactly zero (performs **feature selection**).
- **L2 / Ridge:** Adds the squared value of coefficients as a penalty. Shrinks them close to zero, but rarely exactly zero. Good when you have many correlated features (handles multicollinearity).
- **Elastic Net:** Combines both L1 and L2 penalties.

---

## Part 2: Logistic Regression

**Objective:** Predict a categorical dependent variable (usually binary, e.g., 0/1, Yes/No, Churn/Not Churn) by estimating the probability of an event occurring.

### 1. The Core Mechanism

Logistic regression applies a **Sigmoid (or Logistic) function** to the linear equation to squeeze the output between 0 and 1.
$$ p = \frac{1}{1 + e^{-(\beta_0 + \beta_1x_1 + ...)}} $$

- Maps any real continuous number to a probability $p \in [0, 1]$.
- Default threshold is 0.5 (if $p \ge 0.5$, class 1; else class 0).

### 2. Log-Odds

By algebraically rearranging the sigmoid equation, we get the Logit function:
$$ \ln\left(\frac{p}{1-p}\right) = \beta_0 + \beta_1x_1 + ... + \beta_nx_n $$

- $\frac{p}{1-p}$: The **Odds** of the event occurring.
- The coefficients represent the change in **log-odds** for a 1-unit increase in $X$.

### 3. Cost Function & Optimization

- **Log Loss (Binary Cross-Entropy):** We cannot use MSE for logistic regression because applying the sigmoid function makes the MSE loss function non-convex (multiple local minima). Log Loss is strictly convex.
- **Maximum Likelihood Estimation (MLE):** The statistical method used to estimate coefficients. It finds the parameters that maximize the likelihood of the observed data.

### 4. Evaluation Metrics

- **Confusion Matrix:** Shows True Positives, True Negatives, False Positives, and False Negatives.
- **Precision:** $TP / (TP + FP)$. Out of all positive predictions, how many were correctly positive? (Crucial when False Positives are costly, e.g., spam filtering).
- **Recall (Sensitivity):** $TP / (TP + FN)$. Out of all actual positives, how many did we identify? (Crucial when False Negatives are costly, e.g., cancer detection).
- **F1-Score:** Harmonic mean of Precision and Recall. Great for imbalanced datasets.
- **ROC-AUC:** Measures the model's ability to distinguish between classes across all classification thresholds. 0.5 is random guessing, 1.0 is perfect.

---

## Part 3: Expected Interview Questions & Answers

### Q1: Why can't we use Linear Regression for Classification problems?

**Answer:**

1. **Range of Output:** Linear regression outputs continuous values falling outside the [0, 1] range, making them nonsensical as probabilities.
2. **Sensitivity to Outliers:** A large outlier can drastically shift the linear fit, altering the decision boundary and misclassifying formerly correct points.
3. **Distribution of Errors:** Classification violates the linear regression assumption of normally distributed residuals with constant variance.

### Q2: How do you interpret the coefficient of a categorical vs. continuous variable in Logistic Regression?

**Answer:**
For a continuous variable $X_1$, a 1-unit increase in $X_1$ results in a $\beta_1$ increase in the _log-odds_ of the target event occurring, assuming all else is held constant. Alternatively, the odds multiply by $e^{\beta_1}$.
For a categorical variable (one-hot encoded), $\beta$ represents the difference in the log-odds between that specific category and the baseline (dropped) reference category.

### Q3: How does multicollinearity affect Logistic Regression, and how do you fix it?

**Answer:**
It makes coefficients highly unstable, dramatically inflating their standard errors. This ruins interpretability (you might see signs flip unreasonably) but doesn't necessarily degrade the overall predictive accuracy on the training set.
_Fix:_ Remove highly correlated features, use PCA, or apply L1/L2 regularization (Ridge/Lasso).

### Q4: If you have a highly imbalanced dataset (99% Class 0, 1% Class 1), how would you evaluate and approach modeling?

**Answer:**
_Evaluation:_ Never use accuracy (a dumb model predicting all 0s has 99% accuracy). Use F1-Score, Precision-Recall AUC, or visually inspect the confusion matrix.
_Approach:_

- Resampling: SMOTE (Synthetic Minority Over-sampling Technique) or random undersampling.
- Adjusting class weights in the algorithm to penalize minority class errors more heavily (e.g., `class_weight='balanced'` in sklearn).
- Adjusting the decision threshold (e.g., from 0.5 to 0.1) based on the business trade-off between Precision and Recall.

### Q5: What does it mean if your ROC-AUC score is 0.5? What if it's 0.2?

**Answer:**
An AUC of 0.5 means the model has zero discriminatory power—it's no better than randomly flipping a coin.
An AUC of 0.2 means the model is actively predicting the reverse of what it should. You could simply flip the model's predictions (1-p) to achieve an excellent AUC of 0.8.

---

## Part 4: Practical Code Examples / Snippets

### Python Sklearn Refresher

```python
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression, LogisticRegression
from sklearn.metrics import mean_squared_error, r2_score, classification_report, roc_auc_score

# 1. Linear Regression
X_train, X_test, y_train, y_test = train_test_split(X, y_continuous)
lin_reg = LinearRegression()
lin_reg.fit(X_train, y_train)
y_pred_lin = lin_reg.predict(X_test)
print("RMSE:", mean_squared_error(y_test, y_pred_lin, squared=False))
print("R2:", r2_score(y_test, y_pred_lin))

# 2. Logistic Regression
X_train, X_test, y_train, y_test = train_test_split(X, y_binary)
log_reg = LogisticRegression(class_weight='balanced', penalty='l2') # Handles imbalance + L2 Regularization
log_reg.fit(X_train, y_train)
y_pred_log = log_reg.predict(X_test)
y_proba = log_reg.predict_proba(X_test)[:, 1] # Get probabilities for ROC-AUC
print(classification_report(y_test, y_pred_log))
print("ROC-AUC:", roc_auc_score(y_test, y_proba))
```

---

## Part 5: References & Further Reading

1. [Assumptions of Linear Regression - Analytics Vidhya](https://www.analyticsvidhya.com/blog/2016/07/deeper-regression-analysis-assumptions-plots-solutions/)
2. [Logistic Regression Concepts and Sigmoid - Towards Data Science](https://towardsdatascience.com/logistic-regression-detailed-overview-46c4da4303bc)
3. [Linear vs Logistic Regression Differences - InterviewBit](https://www.interviewbit.com/machine-learning-interview-questions/)
4. [Google ML Crash Course: Linear Regression](https://developers.google.com/machine-learning/crash-course/linear-regression)
