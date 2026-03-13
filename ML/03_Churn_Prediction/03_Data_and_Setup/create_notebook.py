import nbformat as nbf
import os
import json

# Create a new notebook object
nb = nbf.v4.new_notebook()

# Define the cells
text_cells = [
    """# Churn Prediction for Shopping Extension

This notebook analyzes synthetic data modeling the first 90 days of user interaction with a browser shopping extension to predict user churn. The features are based on extension events like price comparison views, auto-apply coupons attempts, and cashback activations.

**Problem Description**: Predict whether a user will uninstall the extension (churn) based on their interaction metrics (successes, failures, savings, and earnings).""",
    
    """### 1. Data Loading\nLet's load the data and look at a sample.""",
    
    """# Load the synthetic dataset
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

df = pd.read_csv('shopping_extension_data.csv')
print(df.head())""",
    
    """### 2. Exploratory Data Analysis (EDA) and Feature Engineering

Let's create some derived features that might be strong predictors of churn, such as the *Coupon Success Rate*.""",
    
    """# Feature Engineering: Coupon Success Rate
# Handle division by zero for users with 0 attempts
df['coupon_success_rate'] = np.where(df['coupon_attempts'] > 0, 
                                     df['coupon_successes'] / df['coupon_attempts'], 
                                     0)

# Let's look at the correlation matrix to see what impacts Churn
plt.figure(figsize=(10, 8))
correlation_matrix = df.drop('user_id', axis=1).corr()
sns.heatmap(correlation_matrix, annot=True, cmap='coolwarm', fmt='.2f')
plt.title('Feature Correlation Matrix')
plt.show()""",
    
    """### 3. Machine Learning Modeling

We will split our data and build two models:
1. **Logistic Regression**: Great for baseline and interpretability (understanding *how* a feature impacts churn).
2. **Random Forest Classifier**: A tree-based ensemble method that can capture non-linear relationships and interactions between features.""",
    
    """from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, roc_auc_score, confusion_matrix

# Define Features (X) and Target (y)
features = ['price_comp_views', 'coupon_attempts', 'coupon_successes', 
            'amount_saved', 'cashback_clicks', 'cashback_earned', 
            'total_interactions', 'coupon_success_rate']

X = df[features]
y = df['churned']

# Train-Test Split (80% training, 20% testing)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)

print(f"Training instances: {len(X_train)}, Testing instances: {len(X_test)}")""",
    
    """#### Model 1: Logistic Regression""",
    
    """# Initialize and train Logistic Regression
lr_model = LogisticRegression(max_iter=1000)
lr_model.fit(X_train, y_train)

# Predictions
lr_preds = lr_model.predict(X_test)
lr_probs = lr_model.predict_proba(X_test)[:, 1]

print("Logistic Regression Evaluation:")
print(classification_report(y_test, lr_preds))
print(f"ROC-AUC Score: {roc_auc_score(y_test, lr_probs):.4f}")""",
    
    """#### Model 2: Random Forest

Random Forests generally perform exceptionally well on tabular behavioral data.""",
    
    """# Initialize and train Random Forest
rf_model = RandomForestClassifier(n_estimators=100, random_state=42, n_jobs=-1)
rf_model.fit(X_train, y_train)

# Predictions
rf_preds = rf_model.predict(X_test)
rf_probs = rf_model.predict_proba(X_test)[:, 1]

print("Random Forest Evaluation:")
print(classification_report(y_test, rf_preds))
print(f"ROC-AUC Score: {roc_auc_score(y_test, rf_probs):.4f}")""",
    
    """### 4. Optimized Solution & Feature Importance

To understand *why* users churn, we can look at the feature importance derived from the Random Forest model. This aligns strongly with optimized tree-based modeling for churn domains.""",
    
    """# Plot Feature Importances for Random Forest
feature_importances = pd.DataFrame({
    'Feature': features,
    'Importance': rf_model.feature_importances_
}).sort_values(by='Importance', ascending=False)

plt.figure(figsize=(10, 6))
sns.barplot(x='Importance', y='Feature', data=feature_importances)
plt.title('Random Forest Feature Importance')
plt.show()"""
]

# Alternate appending markdown and code cells based on the content
# We know the first cell is markdown, second is markdown, etc. 
# We'll map them explicitly
cell_types = ['markdown', 'markdown', 'code', 'markdown', 'code', 'markdown', 'code', 'markdown', 'code', 'markdown', 'code', 'markdown', 'code']

for t, content in zip(cell_types, text_cells):
    if t == 'markdown':
        nb['cells'].append(nbf.v4.new_markdown_cell(content))
    else:
        nb['cells'].append(nbf.v4.new_code_cell(content))

file_path = '/Users/ejazanwar/Downloads/Interview/ML/Churn_Prediction/churn_model.ipynb'
with open(file_path, 'w') as f:
    nbf.write(nb, f)

print("Notebook successfully generated programmatically.")
