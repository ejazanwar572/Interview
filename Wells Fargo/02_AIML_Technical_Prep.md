# AI/ML & Gen AI Basics: Technical Prep for Lead Analytics

As a Lead Analytics Consultant, you are not expected to be a Machine Learning Researcher who derives backpropagation on a whiteboard. Instead, you are expected to **understand when to use ML, how to evaluate it, how to handle data specifically for it, and how to communicate its value.**

This cheat sheet covers the highest-yield AI/ML and Gen AI concepts based on your job description requirements.

---

## 1. Machine Learning Fundamentals (Categorization)

### Supervised Learning
You have historical data with labeled answers (e.g., historical transactions labeled as fraud or non-fraud).
- **Classification:** Predicting a discrete label (e.g., Is this transaction Fraud? Yes/No).
  - *Models:* Logistic Regression, Random Forest, XGBoost.
- **Regression:** Predicting a continuous numeric value (e.g., forecasting next month's transaction volume).
  - *Models:* Linear Regression, Ridge/Lasso Regression.

### Unsupervised Learning
You have unlabelled data and want to find hidden structures.
- **Clustering:** Grouping similar data points (e.g., Customer Segmentation for a new credit card product).
  - *Models:* K-Means, DBSCAN.
- **Anomaly Detection:** Finding outliers (e.g., unusual network behavior or sudden drop in account balance).
  - *Models:* Isolation Forest, Autoencoders.

---

## 2. Dealing with Imbalanced Data (Crucial for Banking)
In banking, fraud is rare (e.g., 0.1% of transactions). If a model just guesses "Not Fraud" every time, it achieves 99.9% accuracy, but it's completely useless!

**Correct Evaluation Metrics (DO NOT use Accuracy):**
1. **Precision:** Out of all transactions the model *flagged* as fraud, how many were actually fraud? (Focus here if False Positives are very costly, like ruining customer experience by blocking legitimate cards).
2. **Recall (Sensitivity):** Out of all *actual* fraud transactions, how many did the model catch? (Focus here if False Negatives are very costly, like losing millions to actual fraud).
3. **F1-Score:** The harmonic mean of Precision and Recall. Use this for a balanced single metric.
4. **ROC-AUC:** Area under the Receiver Operating Characteristic curve. It plots True Positive Rate vs False Positive Rate. A score of 0.5 is random guessing; 1.0 is perfect.

**Techniques to Handle Imbalanced Data:**
- **Oversampling:** Duplicating the minority class (e.g., SMOTE - Synthetic Minority Over-sampling Technique).
- **Undersampling:** Reducing the majority class.
- **Class Weights:** Modifying the ML algorithm to penalize missing the minority class much more strictly.

---

## 3. Data Science & Statistical Forecasting
Since the JD specifically mentions "statistical forecast":
- **Time Series Forecasting:** Predicting future values based on past time-stamped data.
- **ARIMA (AutoRegressive Integrated Moving Average):** A classic statistical method for forecasting series that have stationarity (meaning mean and variance do not change over time).
- **Prophet (by Meta):** A very common modern forecasting library that handles seasonality and daily patterns well.

---

## 4. Generative AI for Analytics (Practical Applications)
If asked "How would you drive innovation using Gen AI?" - answer with **pragmatic, low-risk** use cases. Do not suggest using ChatGPT to make financial decisions on PII data.

**Good Lead-Level Answers:**
1. **Code Generation & Boilerplate:** "I use Gen AI (like GitHub Copilot) to accelerate the creation of PySpark boilerplate code, writing DAGs for Airflow, or generating unit test structures, which increases my team's velocity by 20%."
2. **Data Exploration & Query Translation:** "Using specialized LLMs securely to help non-technical stakeholders translate natural language business questions into initial SQL syntax."
3. **Automated Documentation:** "Applying LLMs to read complex legacy SQL scripts and generate human-readable data lineage and documentation."
4. **Data Privacy / Governance:** "Applying smaller NLP models to scan raw data lakes and automatically tag/flag potential PII (Personally Identifiable Information) before it enters our analytical data warehouse."

---

## 5. Potential Interview Questions & Suggested Answers

**Q: How do you choose between Logistic Regression and a Random Forest?**
*Answer:* I start with Logistic Regression as a baseline because it is highly interpretable, fast to train, and easy to explain to stakeholders (e.g., "Feature X increases odds by 10%"). I move to Random Forest if the relationship between variables is highly non-linear, though I sacrifice some interpretability for better predictive power.

**Q: We have a dataset with a lot of missing values. How do you handle them before training a model?**
*Answer:* I don’t just drop them blindly. First, I identify the *reason* they are missing. Is it Missing Completely at Random? If there is a small amount, I might drop rows. If the feature is highly correlated to the target, I might impute it. For numerical data, I might use median (to avoid outliers affecting the mean). For categorical, I use the mode, or add a new category called "Missing" because the absence of data might itself be a signal!

**Q: How do you prevent overfitting?**
*Answer:* Overfitting happens when a model memorizes the training data but fails on new data (high variance). I prevent it by using Cross-Validation (like K-Fold), simplifying the model (reducing depth in Decision Trees), using Regularization (L1/Lasso or L2/Ridge), and simply collecting more diverse data.

---
**Fact-Check Note:** Be extremely transparent about what you know. If they ask about deep learning (Neural Networks/TensorFlow), and you haven't used it, say: *"My core expertise lies in ML algorithms like Random Forest, XGBoost and Regression models which solve 95% of tabular data problems in analytics. I am conceptually familiar with deep learning, but prefer simpler, interpretable models unless working with image or text data."*
