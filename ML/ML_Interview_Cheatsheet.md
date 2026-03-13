# 📋 ML Interview Concepts Cheat Sheet

---

## 1. 🧠 Foundations

| Concept                      | Key Point                                                                             |
| ---------------------------- | ------------------------------------------------------------------------------------- | ----------------------------------- | ---------------------------- |
| Parametric vs Non-Parametric | Parametric = fixed params (LR, NB); Non-param = grows with data (KNN, DTree)          |
| Bias-Variance Tradeoff       | Bias² + Variance + Noise = Total Error. Underfit = high bias; Overfit = high variance |
| No Free Lunch Theorem        | No single algorithm wins on all problems. Always validate empirically                 |
| Curse of Dimensionality      | In high-d: data is sparse, distances lose meaning, exponential data needed            |
| Probability vs Likelihood    | P(X                                                                                   | θ) = data varies, params fixed. L(θ | X) = params vary, data fixed |

---

## 2. 📐 Linear Models

| Concept                                       | Key Point                                                                                          |
| --------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| Linear Regression Assumptions                 | LINE: Linearity, Independence, Normality of residuals, Equal variance (homoscedasticity)           |
| Why Logistic Regression is called Regression? | Models probability (continuous output) via log-odds; classification is a threshold on top          |
| L1 (Lasso)                                    | Sparse coefficients (→ zero), automatic feature selection                                          |
| L2 (Ridge)                                    | Shrinks coefficients, handles multicollinearity, called "ridge" due to ridge trace geometry        |
| Elastic Net                                   | Combines L1 + L2; best for correlated features                                                     |
| R² vs Adjusted R²                             | R² always increases with more features; Adjusted R² penalizes unnecessary features                 |
| Drawbacks of linear models                    | Assumes linearity, sensitive to outliers, requires scaling, strict distributional assumptions      |
| Interpreting weights                          | w_i = change in y per unit increase in x_i, _ceteris paribus_. Scale features first for comparison |

---

## 3. 🌲 Tree-Based Models

| Concept                 | Key Point                                                                                               |
| ----------------------- | ------------------------------------------------------------------------------------------------------- |
| Gini vs Entropy         | Both measure impurity. Gini is faster (no log). Results rarely differ meaningfully                      |
| Pruning                 | Pre-pruning: stop early (max_depth). Post-pruning: grow then cut (ccp_alpha)                            |
| DTree vs Random Forest  | DTree preferred when interpretability or speed needed; RF for accuracy                                  |
| Bagging (RF)            | Parallel, reduces variance, bootstrap sampling, OOB for free CV estimate                                |
| Boosting (XGBoost)      | Sequential, reduces bias, corrects prior errors, prone to noisy data overfit                            |
| OOB Error               | ~37% samples not in each bootstrap bag → free leave-one-out CV estimate                                 |
| XGBoost Key Hyperparams | n_estimators, learning_rate, max_depth, subsample, colsample_bytree, reg_alpha/lambda, scale_pos_weight |

---

## 4. 📊 Evaluation Metrics

| Concept                | Key Point                                                                                      |
| ---------------------- | ---------------------------------------------------------------------------------------------- |
| Classification metrics | Accuracy (balanced only), Precision (FP cost), Recall (FN cost), F1, ROC-AUC, PR-AUC, Log Loss |
| FP vs FN tradeoff      | Spam filter → Precision. Cancer screening / Fraud → Recall. F-beta balances the two            |
| ROC-AUC                | Threshold-invariant, scale-invariant. AUC=0.5 = random; =1.0 = perfect                         |
| PR-AUC                 | Preferred for heavy class imbalance (ROC-AUC can be misleadingly optimistic)                   |
| Regression metrics     | MAE (robust), MSE (penalizes large errors), RMSE (same units as y), R², Adjusted R², MAPE      |

---

## 5. ⚖️ Regularization & Overfitting

| Concept              | Key Point                                                                                                |
| -------------------- | -------------------------------------------------------------------------------------------------------- |
| Overfitting models   | Deep NNs, unpruned DTrees, high-degree polynomials, KNN (K=1)                                            |
| Reducing overfitting | More data, regularization, simpler model, cross-validation, early stopping, feature selection, ensembles |
| High variance        | Large train-val gap → more data, regularization, bagging                                                 |
| High bias            | Low train + val accuracy → more complex model, better features                                           |

---

## 6. 🔬 Statistical Concepts

| Concept                   | Key Point                                                                                         |
| ------------------------- | ------------------------------------------------------------------------------------------------- |
| p-value                   | P(observed data \| H₀ is true). NOT P(H₀ is true). p < 0.05 → reject H₀                           |
| Type 1 vs Type 2 error    | Type 1 = FP (false alarm). Type 2 = FN (missed detection)                                         |
| Correlation vs Causality  | Correlation = association. Causality requires: temporal precedence + association + no confounders |
| Covariance vs Correlation | Covariance = direction only, scale-dependent. Correlation = standardized [-1, 1]                  |
| Cat vs Cat correlation    | Chi-Square (significance) + Cramér's V (strength)                                                 |
| Cat vs Continuous         | Point-Biserial (binary), ANOVA / Eta-squared (multiclass)                                         |
| Frequentist vs Bayesian   | Frequentist: params are fixed, p-values. Bayesian: params have distributions, prior → posterior   |

---

## 7. 🏗️ Model Selection & Process

| Concept                       | Key Point                                                                                 |
| ----------------------------- | ----------------------------------------------------------------------------------------- |
| When to use Deep Learning     | Large data + unstructured (image/text/audio). NOT the first choice for tabular data       |
| Choosing algorithm            | Tabular → XGBoost. Text → Transformers. Images → CNN. Interpretability needed → LR        |
| DS Project Lifecycle          | Problem → Data → EDA → Preprocessing → Feature Eng → Model → Eval → Deploy → Monitor      |
| Good model properties         | Accurate, generalizable, interpretable, fast, robust, calibrated, fair                    |
| Hyperparameter tuning         | Grid Search → Random Search → Bayesian (Optuna). Start broad, then narrow                 |
| Feature importance            | SHAP (best), Permutation Importance, tree Feature Importance, Lasso coef\_, RFE           |
| Stratified vs Random Sampling | Always use Stratified for classification — preserves class proportions across folds       |
| Cross-validation              | K-Fold (k=5/10), Stratified K-Fold (imbalanced), TimeSeriesSplit (no data leakage for TS) |
