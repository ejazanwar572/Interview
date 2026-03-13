# Churn Prediction for Shopping Extension - Project Plan

## Problem Statement

Evaluate the impact of extension feature usage (Price Comparison, Auto Apply Coupons, Cashback) during the first 90 days post-install on user churn.

## 1. Project Scoping & Data Definition

- [ ] Define the exact metric for "Churn" (e.g., uninstallation vs. inactivity).
- [ ] Identify the data cohort (e.g., users who installed 120+ days ago to allow for a 90-day observation window + churn window).
- [ ] Finalize the exact features to extract for the first 90 days (e.g., coupon success count, savings, price comparison interactions, cashback value).

## 2. Data Collection & Preparation

- [ ] Gather dataset (CSV, SQL queries, or simulated dummy data).
- [ ] Perform data cleaning (handle missing values, outliers in savings/cashback).
- [ ] Feature Engineering: Create aggregated features for the 90-day window per user.

## 3. Exploratory Data Analysis (EDA)

- [ ] Analyze the correlation between feature usage (like coupon success rate) and churn.
- [ ] Visualize churn rates across different user segments.

## 4. Modeling (Baseline)

- [ ] Split data into Training and Testing sets.
- [ ] Implement a baseline Logistic Regression model to understand feature direction and interpretability.
- [ ] Implement a Random Forest classifier to capture non-linear relationships.

## 5. Evaluation & Verification

- [ ] Evaluate models using imbalanced data metrics (Precision, Recall, ROC-AUC).
- [ ] Interpret the model: Explain how coupon success/failure impacts churn probability.
- [ ] Document final review.

## Review Section

_To be filled out upon project completion_

## 6. Interview Preparation Guides
- [x] Create `logistic_regression_guide.md` detailing how Logistic Regression was applied in the Churn model and medium-level counter questions.
- [x] Create `decision_tree_guide.md` detailing how Decision Trees/Random Forests were applied in the Churn model and medium-level counter questions.
