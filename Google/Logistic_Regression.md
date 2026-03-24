# Logistic Regression — Interview Cheat Sheet

---

## 1. Definition & Intuition
- A **supervised classification** algorithm that predicts the **probability** of a binary outcome.
- Uses a **linear combination of features**, then squashes the output to `[0, 1]` via the **sigmoid function**.
- Despite the name, it is a **classifier**, not a regressor.

---

## 2. Mathematical Formulation

**Linear combination:**
$$z = \mathbf{w}^T \mathbf{x} + b$$

**Predicted probability:**
$$\hat{y} = \sigma(z) = \frac{1}{1 + e^{-z}}$$

**Decision rule:**
$$\hat{y} \geq 0.5 \Rightarrow \text{Class 1}, \quad \hat{y} < 0.5 \Rightarrow \text{Class 0}$$

**Variable breakdown:**

| Symbol | Name | Meaning |
|---|---|---|
| `z` | Logit (raw score) | Unbounded real number output before squashing; can be −∞ to +∞ |
| `w` | Weight vector | Learned parameters — one per feature; how much each feature contributes |
| `wᵀ` | Transposed weight | Dot product with x: multiply each weight × its feature, then sum |
| `x` | Feature vector | Input data for one sample, e.g. `[age=30, income=60k]` |
| `b` | Bias (intercept) | Learned constant that shifts the output; allows fit even when all x = 0 |
| `σ` | Sigmoid function | S-shaped squasher that maps any real number → (0, 1) |
| `e` | Euler's number | Mathematical constant ≈ 2.718; base of natural log |
| `ŷ` | Predicted probability | Model's confidence that sample = Class 1; always ∈ (0, 1) |
| `0.5` | Decision threshold | Default cutoff; tune lower (e.g. 0.3) for higher recall in imbalanced problems |

**Flow:**
```
x (features) → dot product with w + b → z (raw score) → σ(z) → ŷ (probability) → threshold → class label
```

---

## 3. Sigmoid Function
$$\sigma(z) = \frac{1}{1 + e^{-z}}$$
- Output range: **(0, 1)** — never exactly 0 or 1.
- At `z = 0`: output = `0.5`
- Differentiable everywhere → enables gradient-based optimization.

---

## 4. Log-Odds & Interpretation
$$\log\left(\frac{p}{1-p}\right) = \mathbf{w}^T \mathbf{x} + b$$
- The model is **linear in log-odds space**.
- A unit increase in feature $x_j$ changes the **log-odds by $w_j$**.
- Exponentiated coefficient $e^{w_j}$ = **odds ratio**: how much the odds multiply per unit change in $x_j$.

---

## 5. Cost Function — Log Loss (Binary Cross-Entropy)
$$\mathcal{L} = -\frac{1}{n}\sum_{i=1}^{n}\left[y_i \log(\hat{y}_i) + (1 - y_i)\log(1 - \hat{y}_i)\right]$$
- Convex for logistic regression → guaranteed global minimum.
- **Why not MSE?** MSE with sigmoid creates a non-convex surface with local minima.

---

## 6. Optimization — Gradient Descent
$$w_j \leftarrow w_j - \alpha \frac{\partial \mathcal{L}}{\partial w_j}$$

**Gradient of log loss:**
$$\frac{\partial \mathcal{L}}{\partial w_j} = \frac{1}{n}\sum_{i=1}^{n}(\hat{y}_i - y_i) x_{ij}$$
- Variants: **Batch GD**, **SGD**, **Mini-batch GD**.
- Can also use second-order methods: **Newton's Method**, **L-BFGS**.

---

## 7. Decision Boundary
- The boundary is a **hyperplane** where $\mathbf{w}^T \mathbf{x} + b = 0$ (i.e., $\hat{y} = 0.5$).
- Logistic regression is a **linear classifier** — cannot learn non-linear boundaries unless features are engineered (e.g., polynomial features).

---

## 8. Regularization

| | **L1 (Lasso)** | **L2 (Ridge)** |
|---|---|---|
| **Penalty** | $\lambda \sum |w_j|$ | $\lambda \sum w_j^2$ |
| **Effect** | Sparse weights (some → 0) | Shrinks all weights |
| **Feature Selection** | ✅ Yes | ❌ No |
| **sklearn param** | `penalty='l1'` | `penalty='l2'` (default) |
| **When to use** | High-dim, many irrelevant features | Correlated features, multicollinearity |

---

## 9. Assumptions
1. **Binary / ordinal outcome** (or multi-class for multinomial LR).
2. **Linearity** in log-odds (not in probability).
3. **No multicollinearity** among features.
4. **Independence of observations** — no repeated-measures or autocorrelation.
5. **Large sample size** — MLE requires enough data to converge.
6. **No extreme outliers** — sensitive to leverage points.

---

## 10. Binary vs. Multiclass

| | **Binary** | **One-vs-Rest (OvR)** | **Softmax (Multinomial)** |
|---|---|---|---|
| **Classes** | 2 | K (K binary classifiers) | K (joint) |
| **Output** | Single sigmoid | K probabilities (not summing to 1) | K probabilities (sum to 1) |
| **Loss** | Binary cross-entropy | K binary cross-entropies | Categorical cross-entropy |
| **sklearn** | `multi_class='ovr'` | `multi_class='ovr'` | `multi_class='multinomial'` |

---

## 11. Quick Comparison Table

| Concept | Value |
|---|---|
| **Output** | Probability ∈ (0, 1) |
| **Activation** | Sigmoid |
| **Loss** | Log Loss (Binary Cross-Entropy) |
| **Optimizer** | Gradient Descent / L-BFGS |
| **Decision Boundary** | Linear hyperplane |
| **Regularization** | L1, L2 (C = 1/λ in sklearn) |
| **Interpretability** | High — coefficients = log-odds |
| **Handles non-linearity?** | ❌ Not natively |

---

## 12. Interview Questions & Answers

**Q1: Why use log loss instead of MSE for logistic regression?**
> MSE with sigmoid produces a non-convex loss surface with local minima. Log loss is convex, guaranteeing convergence to a global minimum.

**Q2: What does the coefficient $w_j$ represent?**
> It is the change in **log-odds** per unit increase in $x_j$. Exponentiating it gives the **odds ratio**.

**Q3: Can logistic regression handle multicollinearity?**
> Not well. Correlated features inflate variance of coefficients. Use **L2 regularization** or drop/combine correlated features.

**Q4: What is the `C` parameter in sklearn's LogisticRegression?**
> `C = 1/λ`. A **small C** = strong regularization (simpler model). A **large C** = weak regularization (fits training data closely).

**Q5: How do you handle class imbalance in logistic regression?**
> Use `class_weight='balanced'`, resample (SMOTE/undersample), tune the decision threshold, or optimize for F1/AUC instead of accuracy.

**Q6: What is the difference between logistic regression and a single-layer neural network?**
> Structurally identical. Logistic regression = a single neuron with a sigmoid activation and log loss. A neural network stacks multiple such layers.

**Q7: Why does logistic regression assume linearity in log-odds, not in probability?**
> Probabilities must stay in [0,1], which the linear equation violates. The log-odds (logit) can range over $(-\infty, +\infty)$, so linearity is a valid assumption there.

**Q8: When would you prefer logistic regression over a tree-based model?**
> When interpretability is required, data is linearly separable, the dataset is small, or training speed and simplicity matter more than raw accuracy.

---

## 13. Practical Example — Churn Prediction

**Problem**: Predict if a telecom customer will churn (1) or not (0).

**Features**: `tenure`, `monthly_charges`, `contract_type`, `num_support_calls`

**Workflow**:
1. EDA → check class balance (e.g., 80% no-churn, 20% churn → imbalanced).
2. Encode categoricals (`contract_type`), scale numerics (`StandardScaler`).
3. Fit logistic regression with `class_weight='balanced'`.
4. Interpret: high `monthly_charges` coefficient → higher log-odds of churn.
5. Evaluate: **AUC-ROC, Precision-Recall**, not just accuracy.
6. Tune decision threshold based on business cost (FP vs FN trade-off).

---

## 14. Python Implementation (scikit-learn)

```python
from sklearn.linear_model import LogisticRegression
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report, roc_auc_score
import pandas as pd

# Assume X (features), y (binary target) are ready
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Scale features (important for LR!)
scaler = StandardScaler()
X_train_sc = scaler.fit_transform(X_train)
X_test_sc  = scaler.transform(X_test)

# Fit model
model = LogisticRegression(
    penalty='l2',           # Regularization type
    C=1.0,                  # Inverse of lambda; smaller = stronger reg
    class_weight='balanced',# Handle imbalance
    solver='lbfgs',         # Good for small-medium datasets
    max_iter=1000
)
model.fit(X_train_sc, y_train)

# Evaluate
y_pred  = model.predict(X_test_sc)
y_proba = model.predict_proba(X_test_sc)[:, 1]

print(classification_report(y_test, y_pred))
print("AUC-ROC:", roc_auc_score(y_test, y_proba))

# Inspect coefficients (log-odds)
coef_df = pd.DataFrame({'feature': X.columns, 'log_odds': model.coef_[0]})
coef_df['odds_ratio'] = coef_df['log_odds'].apply(lambda x: round(__import__('math').exp(x), 3))
print(coef_df.sort_values('log_odds', ascending=False))
```

---

*Last updated: March 2026 | For interview prep use only*
