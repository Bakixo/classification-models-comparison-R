# Classification Model Comparison in R

This project compares multiple **classification models** on a dataset containing numerical health-related features.
The objective is to predict the target variable **Classification** and evaluate different machine learning approaches.

---

## 📌 Project Overview

Models implemented in this project:

- Decision Tree (CART)
- Random Forest
- Naive Bayes

The workflow includes missing data imputation, model training, evaluation, and comparison using standard classification metrics.

---

## 📊 Methodology

1. **Data Loading**
   - Dataset loaded from CSV file
   - Target variable converted to factor

2. **Missing Data Imputation**
   - Applied **MICE (Predictive Mean Matching)** to handle missing values

3. **Train–Test Split**
   - 80% training, 20% testing
   - Stratified split using `caret::createDataPartition`

4. **Model Training**
   - Decision Tree (`rpart`)
   - Random Forest (`randomForest`)
   - Naive Bayes (`e1071`)

5. **Model Evaluation**
   - Confusion Matrix
   - Accuracy
   - Sensitivity (Recall)
   - Specificity
   - Precision

6. **Model Comparison**
   - Metrics summarized in a comparison table
   - Feature importance visualization for Random Forest

7. **New Data Prediction**
   - New observation scaled using training statistics
   - Prediction performed using trained models

---

## 📦 Requirements

Install all required packages by running:

```r
source("requirements.R")
