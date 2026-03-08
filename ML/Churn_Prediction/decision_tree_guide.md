# Decision Trees & Random Forest in Churn Prediction

This guide provides a medium-level deep dive into how Decision Trees and Random Forests (Ensemble methods) were applied in our Shopping Extension Churn model, along with expected interview questions.

---

## 1. Core Concept Overview

### The Single Decision Tree

A Decision Tree is a supervised algorithm that splits data into smaller and smaller subsets based on simple, sequential rules.

- **How it splits:** At each node, the algorithm looks for the feature and the threshold (e.g., `amount_saved < $5.00`) that creates the "purest" resulting branches. Impurity is usually measured using **Gini Impurity** or **Entropy/Information Gain**. The goal is for the final "leaf" nodes to contain entirely churners or entirely retained users.
- **The Problem:** Single decision trees are incredibly prone to _overfitting_. They easily memorize the training data by creating branches that are too deep and specific, causing them to fail on unseen data.
  - **Example of Overfitting:** Imagine a single tree learning that a user churns _only_ if `amount_saved < $2` AND `cashback_clicks == 3` AND `user_id ends in 7`. It memorized a specific person in the training data rather than learning the general pattern. When a new user arrives with the exact same behavior but an ID ending in 8, the tree fails to predict churn.

### The Random Forest Solution

A Random Forest solves the overfitting problem of single trees by creating an "ensemble" (a large collection) of many decision trees. It relies on two powerful forms of randomness:

1.  **Bootstrapping (Bagging):** Every individual tree is trained on a random sample of the data (with replacement), meaning no two trees see the exact same training dataset.
2.  **Feature Randomness:** At every single node split, the algorithm is restricted to only evaluating a random subset of the available features.

By averaging the predictions of hundreds of these diverse, uncorrelated trees (a process called _Bootstrap Aggregating_ or _Bagging_), Random Forest drastically reduces the model's variance and prevents overfitting.

---

## 2. Application in Our Churn Project

In our shopping extension project, the Random Forest Classifier served as our primary, optimized predictive engine.

- **The Goal:** We needed a model that could capture conditional "friction" states. For example, a user who attempts 20 coupons and gets 0 successes is highly likely to churn due to annoyance. A linear model struggles with this, but a Decision Tree easily creates a branch checking `IF coupon_attempts > 15 AND IF coupon_success_rate < 0.1 THEN Churn = 1`.
- **Performance:** The Random Forest achieved roughly 69% accuracy and a stronger Recall/F1-score than Logistic Regression.
- **Feature Importance:** By analyzing how often features like `cashback_earned` and `amount_saved` successfully reduced impurity across the forest, we natively generated a Feature Importance chart to provide actionable insights back to the Product team.

---

## 3. Medium-Level Interview & Counter Questions

> If you present this project, expect variations of the following questions from a senior data scientist or hiring manager.

### Q1: "How does a Random Forest actually prevent the overfitting we see in a standard Decision Tree?"

**Answer:**
A standard Decision Tree has high variance; slight changes in the training data can completely alter the tree's structure. Random Forest solves this through **Bagging** (Bootstrap Aggregating) and **Feature Randomness**. By training hundreds of trees on different random bootstrapped samples of the data, and forcing them to split on different random subsets of features, the trees become decorrelated. When you average the predictions of hundreds of decorrelated, high-variance trees, the overarching variance collapses, resulting in a highly robust model that generalizes well to unseen data.

### Q2: "You mentioned measuring 'Impurity' to split nodes using Gini or Entropy. What is the difference between them?"

**Answer:**
Both are metrics used to calculate the heterogeneity of a node.

- **Gini Impurity** calculates the probability of incorrectly classifying a randomly chosen element in the node. It is computationally faster because it doesn't require computing logarithmic functions, which is why algorithms like Scikit-Learn's CART use it by default.
- **Entropy** originates from information theory and measures the degree of disorganization in a system using logarithms. The split that provides the highest "Information Gain" (greatest reduction in Entropy) is chosen.
  In practical applications, they yield very similar trees, but Gini is slightly faster to compute for massive forests.

### Q3: "How does a Random Forest natively calculate the Feature Importance plot you generated?"

**Answer:**
Scikit-learn implements Mean Decrease Impurity (MDI). Every time a feature (like `cashback_earned`) is chosen to split a node across the hundreds of trees in the forest, the algorithm tracks how much that split mathematically decreased the Gini impurity. The total decrease in impurity attributed to a specific feature across the entire forest is averaged, giving us the relative Native Feature Importance score.

### Q4: "Are there any known biases or flaws with Native Feature Importance in Random Forests?"

**Answer:**
Yes. Impurity-based feature importance is significantly biased toward features with **high cardinality** (continuous variables with many unique values, like dollar amounts) over categorical variables (like a binary `clicked_popup` feature). To get a mathematically unbiased view of which features actually drive the model's predictions, we should ideally use **Permutation Importance** or compute **SHAP (SHapley Additive exPlanations)** values instead.

### Q5: "If your Random Forest was taking too long to train or required too much memory, what hyperparameters would you tune to fix it?"

**Answer:**
I would first adjust `n_jobs=-1` to ensure it is parallelizing across all CPU cores. To physically reduce the computational footprint, I would limit the maximum depth of the trees (`max_depth`), increase the minimum samples required to split a node (`min_samples_split`), or decrease the total number of trees in the forest (`n_estimators`).

### Q6: "How does Random Forest compare to a Gradient Boosting model like XGBoost?"

**Answer:**
Both are tree-based ensembles, but they build trees fundamentally differently.
Random Forest uses **Bagging**: It builds all trees deeply and independently in parallel, and averages them to reduce variance.
Gradient Boosting uses **Boosting**: It builds shallow trees sequentially. Every new tree specifically targets and attempts to correct the residual errors made by the previous trees. Boosting models generally achieve slightly higher accuracy than Random Forests but are far more susceptible to overfitting and require much more delicate hyperparameter tuning.
