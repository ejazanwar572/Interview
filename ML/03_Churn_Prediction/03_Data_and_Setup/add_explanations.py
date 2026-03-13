import nbformat as nbf

file_path = '/Users/ejazanwar/Downloads/Interview/ML/Churn_Prediction/churn_model.ipynb'

try:
    with open(file_path, 'r') as f:
        nb = nbf.read(f, as_version=4)
except Exception as e:
    print(f"Error reading notebook: {e}")
    exit(1)

new_cells = []
for idx, cell in enumerate(nb['cells']):
    new_cells.append(cell)
    if cell.cell_type == 'code':
        source = cell.source
        
        explanation = ""
        
        if "pd.read_csv" in source:
            explanation = """**What & Why we did this**: 
We loaded the dataset into a Pandas DataFrame and inspected the first few rows (`head()`). This is the foundational step in any data science problem. It helps verify that the dataset structure, column names, and data types match our expectations before we begin deep analysis.

**Interviewer Questions**:
- *"How would you handle reading this file if the dataset was 50GB and couldn't fit into memory using pandas?"* 
  - **Answer**: I would use `chunksize` in pandas to read the file in smaller batches, or transition to a distributed processing framework like Dask or PySpark.
- *"What is the main difference between a DataFrame and a Series in pandas?"*
  - **Answer**: A Series is a one-dimensional array representing a single column, whereas a DataFrame is a two-dimensional, tabular data structure composed of multiple Series."""
            
        elif "coupon_success_rate" in source:
            explanation = """**What & Why we did this**: 
We engineered a new feature: `coupon_success_rate`. Raw metrics (like `coupon_attempts`) don't tell the full story. A user failing 9 out of 10 times signals high frustration, which directly impacts churn. Explicitly engineering this ratio provides a clearer, more direct signal to the model. We also plotted a correlation matrix to observe linear relationships and check for multicollinearity among inputs.

**Interviewer Questions**:
- *"Why engineer the success rate instead of just letting the model figure it out from attempts and successes?"* 
  - **Answer**: While advanced tree models can sometimes infer complex interactions, explicitly computing mathematical ratios offers a stronger, more direct signal. Linear models like Logistic Regression mathematically cannot infer division/ratios on their own.
- *"What is multicollinearity, and why is it a problem?"* 
  - **Answer**: Multicollinearity occurs when independent variables in a regression model are highly correlated. It makes it difficult to interpret the beta coefficients of the Logistic Regression model, leading to unstable feature importance estimates."""
            
        elif "train_test_split" in source:
            explanation = """**What & Why we did this**: 
We partitioned our data into a Training Set (80%) and Testing Set (20%) using the `stratify=y` parameter. This ensures our model is evaluated on data it has never seen, proving it can generalize to real, unseen users.

**Interviewer Questions**:
- *"Why is `stratify=y` critical for churn prediction datasets?"* 
  - **Answer**: Churn datasets are almost always imbalanced (e.g., 90% retain, 10% churn). Stratification ensures both the train and test splits contain an equal proportion of the minority class (churners). Without it, the test set could randomly contain zero churners, making our evaluation metrics completely useless.
- *"What is data leakage? How do you prevent it?"* 
  - **Answer**: Data leakage happens when information from outside the training dataset "leaks" into the model during training. Doing the train-test split *before* performing any aggregate scaling, imputation, or advanced feature engineering prevents this."""
            
        elif "LogisticRegression" in source:
            explanation = """**What & Why we did this**: 
We trained a Logistic Regression classifier as our baseline model. It operates by fitting a line to separate churners from non-churners based on continuous probabilities. We evaluated it using ROC-AUC instead of standard accuracy.

**Interviewer Questions**:
- *"Why start with Logistic Regression instead of jumping straight to XGBoost or Random Forest?"* 
  - **Answer**: Following Occam's razor—start simple. If a linear model performs sufficiently well, it's easier to maintain, deploy, and explain to non-technical stakeholders. It also establishes a baseline to determine if complex, heavy models offer enough 'lift' to justify their computational overhead.
- *"Why should we look at ROC-AUC or F1-Score instead of Accuracy?"* 
  - **Answer**: In imbalanced datasets, a model could simply predict "No Churn" 100% of the time. If the churn rate is 5%, the model is technically 95% accurate, but entirely useless. Precision, Recall, and ROC-AUC evaluate how well the model distinguishes between real classes."""
            
        elif "RandomForestClassifier" in source:
            explanation = """**What & Why we did this**: 
We trained a Random Forest model, an ensemble model constructed of many decision trees (`n_estimators=100`). Unlike Logistic Regression, Random Forests can automatically capture deep, non-linear feature interactions (e.g., a high coupon failure rate might *only* cause churn if the total savings are also zero).

**Interviewer Questions**:
- *"How does a Random Forest mitigate overfitting compared to a single Decision Tree?"*
  - **Answer**: Through "Bagging" (Bootstrap Aggregating). It trains many trees on random sub-samples of the data, and randomly subsets the features available at each node split. This ensures the trees are uncorrelated. Averaging their predictions drastically reduces the model's overall variance and prevents overfitting.
- *"What are the primary hyperparameters you would tune for a Random Forest?"* 
  - **Answer**: The maximum depth of the trees (`max_depth`), the minimum number of samples required to split an internal node (`min_samples_split`), and the number of trees in the forest (`n_estimators`)."""
            
        elif "feature_importances_" in source:
            explanation = """**What & Why we did this**: 
We extracted and plotted the feature importances to interpret the Random Forest's "black box". In an industry setting (like a Shopping Extension), Product Managers care immensely about the 'Why'. If we know `cashback_earned` is the highest predictor of retention, stakeholders can prioritize engineering efforts to make cashback more prominent in the app UI.

**Interviewer Questions**:
- *"How does a Random Forest calculate feature importance natively?"*
  - **Answer**: Through Mean Impurity Decrease (often Gini Impurity). The algorithm tracks how much a specific feature successfully split the data and decreased the "impurity" (disorder) across all trees in the forest.
- *"Are there any known flaws with native Random Forest feature importance?"*
  - **Answer**: Yes, impurity-based feature importance is biased toward features with high cardinality (many unique continuous values) over categorical features. Permutation Importance or employing SHAP (SHapley Additive exPlanations) values offer far more robust, unbiased interpretability."""

        if explanation:
            new_cells.append(nbf.v4.new_markdown_cell(explanation))

nb['cells'] = new_cells

with open(file_path, 'w') as f:
    nbf.write(nb, f)

print("Notebook successfully updated with explanations and interview questions.")
