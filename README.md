# Customer Churn Analytics



Predicting customer churn for a telecom company and translating the results into actionable retention recommendations — from data warehousing through exploratory
analysis, model optimization, and business insights, with a Power BI dashboard layer.



## Project Overview



Customer churn (a customer ending their subscription) is one of the costliest problems for subscription-based businesses. This project builds an end-to-end pipeline to:

1. Extract, transform, and load the raw data (ETL / Data Warehouse)
2. Explore and understand the drivers of churn in the data
3. Train and compare several classification models
4. Optimize the best models to handle class imbalance and maximize business-relevant performance (not just accuracy)
5. Translate model results into concrete retention recommendations
6. Visualize results and tell the business story through an interactive Power BI Dashboard



## Dataset



The [Telco Customer Churn dataset](https://www.kaggle.com/datasets/blastchar/telco-customer-churn), containing 7,043 customers and 19 features covering demographics, account information, and subscribed services. The target variable, `Churn`, is imbalanced: \~26.5% of customers churned.



## Project Structure



```
Customer-Churn-Analytics/
├── 01\_Telco\_Customer\_Churn\_Analysis.ipynb        # Exploratory data analysis
├── 02\_Telco\_Customer\_Churn\_Prediction.ipynb      # Baseline models (LR, DT, RF, XGBoost)
├── 03\_Customer\_Churn\_Model\_Optimization.ipynb    # Class imbalance handling, tuning, thresholding
├── 04\_Business\_Insights.ipynb                    # Feature importance \& recommendations
├── raw data/                                     # Original, unprocessed data
├── Clean Data/
│   └── telco\_clean.csv                           # Cleaned dataset (output of notebook 01)
├── ETL/                                           # Data extraction / transformation / loading
├── Power BI/                                      # Interactive dashboard and storytelling
├── final\_xgboost\_model.pkl                        # Final trained pipeline (preprocessing + model)
├── final\_threshold.pkl                            # Retained decision threshold (0.45)
├── X\_train.csv / X\_test.csv / y\_train.csv / y\_test.csv   # Train/test split, bridging notebooks 03 → 04
├── requirements.txt
└── README.md
```

## Methodology



**ETL / Data Warehouse:** extraction, cleaning, and structuring of the raw Customer data ahead of analysis.



**01 — Exploratory Data Analysis:** univariate and bivariate analysis of churn against customer attributes (contract type, tenure, internet service, pricing, etc.), producing a cleaned dataset for modeling.



**02 — Baseline Models:** four classifiers trained with default hyperparameters — Logistic Regression, Decision Tree, Random Forest, XGBoost — to establish a performance baseline and confirm the impact of class imbalance on Recall.



**03 — Model Optimization:** a step-by-step approach to improving the two best-performing baseline models (Logistic Regression, XGBoost):

* Class imbalance handling: `class\_weight="balanced"` compared against SMOTE, evaluated independently per model
* Hyperparameter tuning via `GridSearchCV`, with `scoring="f1"` chosen deliberately after an initial `scoring="recall"` search was found to push the model toward an extreme, low-precision solution
* Boundary checks on grid search results, extending the search range whenever the best hyperparameter landed at the edge of the tested grid
* Decision threshold tuning on the final model, trading a small amount of F1-score for a meaningful gain in Recall — justified by the higher business cost of a missed churner compared to an unnecessary retention offer



**04 — Business Insights:** feature importance analysis (native XGBoost importances), cross-checked against the exploratory analysis; individual customer prediction examples isolating the effect of contract type, online security, and monthly charges; and concrete, evidence-based retention recommendations.



**Power BI:** an interactive dashboard translating the model's findings into a business-facing story for stakeholders.



## Final Model

||Configuration|
|-|-|
|Algorithm|XGBoost|
|Hyperparameters|`max\_depth=5`, `learning\_rate=0.1`, `n\_estimators=70`|
|Class imbalance handling|`scale\_pos\_weight`|
|Decision threshold|0.45 (tuned from default 0.5)|

|Metric|Score|
|-|-|
|Recall|0.810|
|Precision|0.506|
|F1-score|0.623|
|Accuracy|0.740|
|ROC-AUC|0.839|

## 

## Key Findings



* **Contract type is the dominant churn driver**, both in the exploratory analysis (42.7% churn rate for month-to-month contracts vs. 2.8% for two-year contracts) and in the model's feature importance (by far the most influential feature). An isolated customer test confirmed the effect directly: changing only the contract type shifted a customer's predicted churn probability from 0.839 down to 0.103.
* **OnlineSecurity is a clear, low-cost retention lever**: enabling it reduces predicted churn probability from 0.839 to 0.666 for an otherwise identical customer.
* **Internet service type is tied to pricing, not just technology**: Fiber optic customers pay \~57% more on average than DSL customers and churn at a correspondingly higher rate. However, an isolated test on `MonthlyCharges` alone revealed a non-linear relationship — churn risk peaked at $85/month and declined at $110/month — so this finding is scoped specifically to the Fiber optic segment rather than generalized into a broad pricing claim.
* 

## Business Recommendations



1. Prioritize converting month-to-month customers to longer-term contracts, with incentives specifically emphasizing two-year commitments

2. Promote OnlineSecurity adoption as a low-cost, high-impact retention lever

3. Address the Fiber optic pricing/value gap specifically, avoiding broad company-wide pricing claims given the non-linear price-churn relationship observed

4. Use the model as a prioritization tool for the retention team, ranking customers by churn risk rather than replacing human judgment



## Tech Stack

Python · pandas · scikit-learn · XGBoost · imbalanced-learn · matplotlib · seaborn ·Power BI



## How to Run

```bash
pip install -r requirements.txt
```

Run the notebooks in order (01 → 04). Notebook 03 saves the final trained model and train/test data to disk (already included in this repo); notebook 04 loads them directly, so it can be run independently once the pickle and CSV files are present.



