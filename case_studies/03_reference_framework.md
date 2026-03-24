# 📐 Retail Reference Framework

> A "Swiss Army Knife" for retail case studies. Use this as a mental toolkit — pull out the right card for the problem at hand.

---

## 🔬 Card 1: Retail Diagnostic Tree (5-Layer Drill-Down)

For any metric that has moved up or down, systematically narrow to root cause:

```
Layer 1 — WHAT moved?
  → Identify the metric: Revenue, Margin, Conversion, Retention, AOV, etc.

Layer 2 — WHICH slice?
  → By: Channel (Store / Online)
       Geography (Region / City / Store Tier)
       Category / Department
       Customer Segment (New / Returning / High-value)
       Time (Day-of-week, Hour, Season)

Layer 3 — WHICH component of the metric?
  → Decompose: Revenue = Transactions × AOV
                       = Footfall × Conversion × AOV
               Gross Profit = Revenue × (1 − COGS %) − Opex
               CLV = ARPU × Gross Margin × Customer Lifespan

Layer 4 — WHY did the component move?
  → Demand (Volume Change): traffic, new customers, churn, external shocks
  → Supply (Availability): stockout, OSA, ranging/assortment gaps
  → Price (Mix Shift): promo, markdown, competitor, price-tiering change
  → Execution (Process): ops issue, staff, planogram, UX/IT bug

Layer 5 — EVIDENCE & VALIDATION
  → Which stores / SKUs drove the comp movement?
  → Is the change new or ongoing? (Trend breakpoint detection)
  → Is there a known event that explains it? (Promo, competitor, weather, policy)
```

---

## 🎡 Card 2: Retail Analytics Wheel

Eight analytics domains — and the core business question each answers:

| Domain | Core Question | Grocery Example | Fashion Example |
|---|---|---|---|
| **Sales Analytics** | What sold, and how much? | Weekly sales by department | Style/colour/size revenue |
| **Customer Analytics** | Who are my customers? | Loyalty tier cohorts | Fashion lifestyle segments |
| **Merchandising Analytics** | What should be on shelf? | Optimal planogram layout | Size-run allocation |
| **Promotional Analytics** | Did the promo work? | Basket penetration lift | End-of-season clearance ROI |
| **Inventory Analytics** | How much to stock & where? | Fresh replenishment cycle | Season-opening OTB vs. sell-through |
| **Pricing Analytics** | What price maximizes value? | Price elasticity per category | Markdown curve optimization |
| **Operational Analytics** | How efficient are we? | Waste reduction, OSA | OTIF, returns rate reduction |
| **Forecasting Analytics** | What will happen next? | Demand forecast (weather-adjusted) | Style-level sell-through forecast |

---

## 🧩 Card 3: Problem Type → Technique → Metric Table

| Business Problem | Analytical Technique | Primary Metric | Secondary Metric |
|---|---|---|---|
| Sales Decline Investigation | Decomposition, Waterfall, Segment drill-down | Revenue Gap | Conversion Rate, AOV |
| Customer Churn | Survival Analysis, Logistic Regression, GBM | Churn Rate, AUC-ROC | Precision@K, CLV Impact |
| Demand Forecasting | SARIMA, Prophet, XGBoost | MAPE, RMSE | Bias, Service Level |
| Price Optimization | Elasticity (OLS/log-log), Conjoint Analysis | Revenue Lift, Gross Margin | Volume Change, SOW |
| Promotion ROI | A/B Test, DiD, Holdout | Incremental Revenue | Cannibalization, Margin |
| Basket / Cross-sell | Market Basket Analysis (Apriori/FP-Growth) | Lift, Confidence | Basket Size, Attach Rate |
| Inventory Stockout | Statistical Reorder Modelling, Simulation | OSA, Fill Rate | Holding Cost, DIO |
| Markdown / Clearance | Dynamic Pricing Model, Simulation | Sell-Through Rate | Margin %, End-of-season stock |
| Store Expansion | Cannibalization Model, Site Selection | Incremental Revenue | ROAS, Comp-store impact |
| Customer Segmentation | K-Means, Hierarchical, RFM | Segment Stability | Inter-cluster distance |
| Personalization | Collaborative Filtering, Hybrid RecSys | CTR, Conversion Lift | Revenue/User, Return Rate |
| Return Rate Reduction | Root Cause Analysis, Classification | Return Rate | Net Revenue, NPS |
| Size Run Optimization | Hist. sell-through + forecast | Size Fill Rate | Overstock, Stockout per size |
| Waste / Spoilage | Regression, Simulation | Waste % | OSA, Margin, Replenishment Freq |

---

## 🗂️ Card 4: Data Source → Business Question Matrix

| Business Question | Primary Data Source | Key Columns to Request |
|---|---|---|
| Why did sales drop? | POS / Transaction data | `date`, `store_id`, `sku`, `qty`, `price`, `promo_flag` |
| Why are customers churning? | CRM / Loyalty | `customer_id`, `last_purchase_date`, `visit_frequency`, `channel` |
| Which products to cross-sell? | Transaction data | `basket_id`, `sku_list`, `customer_id`, `timestamp` |
| Are promos working? | POS + Promo calendar | `promo_id`, `start_date`, `end_date`, `promo_type`, `baseline_sales` |
| Where are the stockouts? | Inventory + POS | `stock_on_hand`, `expected_daily_demand`, `oos_flag`, `store_id` |
| What's driving high returns? | Returns + Order data | `return_reason_code`, `sku`, `size`, `channel`, `days_to_return` |
| What price to set? | POS + Competitor data | `price`, `qty_sold`, `competitor_price`, `elasticity_estimate` |
| Demand forecast for next week? | POS + Calendar + Weather | `date`, `qty_sold`, `weather_temp`, `is_holiday`, `event_flag` |

---

## 🧱 Card 5: MECE Decomposition Cards

### Revenue Decomposition
```
Revenue
├── Number of Transactions
│   ├── Footfall / Visits
│   └── Conversion Rate
└── Average Transaction Value (AOV)
    ├── Number of Items per Basket
    └── Average Item Price
```

### Customer Decomposition
```
Customer Base
├── Acquisition
│   ├── New Customers
│   └── Reactivated (Lapsed → Returned)
├── Retention
│   ├── Frequency (visits/year)
│   └── Spend per Visit
└── Attrition
    └── Churned Customers (no purchase in X days)
```

### Gross Profit Decomposition
```
Gross Profit
├── Revenue (see above)
└── COGS
    ├── Product Cost (negotiated with supplier)
    ├── Shrinkage / Waste
    └── Markdown / Promotions
```

---

## 🔁 Card 6: A/B Test Design Card (Retail)

For any experiment in a retail context:

| Step | Question | Retail Example |
|---|---|---|
| **Hypothesis** | What change are you testing? | "Showing personalized banners will increase CTR" |
| **Unit of Randomization** | Customer, Store, or Basket? | Customer-level (to avoid contamination) |
| **Control vs. Treatment** | Baseline vs. new experience | Control = generic homepage, Treatment = personalized |
| **Sample Size** | MDE, power (0.80), alpha (0.05) | N = ~5k per arm for 5% lift detection |
| **Duration** | Long enough for novelty effect to wear off | ≥2 full weeks; avoid holiday contamination |
| **North Star Metric** | Single primary outcome | Conversion Rate |
| **Guardrail Metrics** | Prevent harm elsewhere | Return Rate, Basket Size, NPS |
| **Analysis** | Z-test, t-test, or Mann-Whitney? | Two-proportion z-test for conversion |
| **Watch-outs** | Network effects, spillover, Novelty Effect | Ensure store-level isolation if testing in-store |

---

## 🚨 Card 7: Common Retail Pitfalls in Case Interviews

| Mistake | Why It's Wrong | Correct Approach |
|---|---|---|
| Jumping to ML immediately | Cases rarely need ML — EDA first | Run decomposition before modelling |
| Ignoring seasonality | Retail is highly seasonal | Always plot year-ago comparison |
| Treating all customers the same | High-value ≠ average customer | Segment before prescribing actions |
| Measuring promo revenue without baseline | Promo "lift" might just be pull-forward | Use holdout group / DiD |
| Forgetting supply side | Demand dip can be a supply problem (stockout) | Cross-check OSA + sales simultaneously |
| Only reporting averages | Averages hide bimodality | Use percentiles and segment views |
| Recommending price drops for sales lift | Margin erosion risk | Model elasticity + profit impact |
| Ignoring return rate (fashion) | High gross revenue can be wiped by returns | Always check net revenue |
