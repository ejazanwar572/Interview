# 🧭 Retail Case Study Guidelines

> A repeatable, structured approach for tackling any retail analytics case study in an interview. Applies to both **Grocery** and **Fashion/Apparel** problems.

---

## The 7-Step Retail Case Framework

```
[1] Clarify → [2] Hypothesize → [3] Data → [4] Analyze → [5] Metrics → [6] Recommend → [7] Communicate
```

---

## Step 1: Clarify the Problem

> **Goal:** Fully define the scope before touching data. Never assume. Shows business maturity.

### Clarifying Questions Checklist

**Context**
- [ ] What is the business objective? (Revenue, margin, customer growth, cost reduction?)
- [ ] What is the specific symptom? (e.g., "comp-store sales dropped 8% MoM")
- [ ] Which sub-segment? (Grocery / Fresh / Fashion / Online / Offline?)
- [ ] Which geography and store tier?
- [ ] What time window are we looking at?

**Constraints**
- [ ] What data is available? (POS, loyalty, CRM, web, inventory, 3rd party?)
- [ ] What is the timeframe / urgency?
- [ ] Have there been recent external events? (Macro, competitor, weather, promotion?)

**Success Definition**
- [ ] What does a "good" outcome look like?
- [ ] Who are the stakeholders and what decisions will this analysis drive?

> 💡 **Tip:** Spend 2–3 minutes here. Interviewers reward structured clarification over jumping to solutions.

---

## Step 2: Hypothesize

> **Goal:** Before looking at data, generate a MECE set of potential root causes.

### Retail Hypothesis Tree (Universal)

```
Problem: [Metric] is [up/down]
│
├── DEMAND-SIDE
│   ├── Change in customer volume (traffic, acquisition, churn)
│   ├── Change in customer behavior (basket, frequency, return rate)
│   └── Change in market / external factors (macro, competitor, seasonality)
│
├── SUPPLY-SIDE
│   ├── Inventory availability (stockouts, phantom inventory, OSA)
│   └── Assortment / ranging changes
│
├── PRICE
│   ├── Our pricing change (markdown, promo, dynamic pricing)
│   └── Competitor pricing
│
└── EXECUTION
    ├── Store operations (planogram, staff, opening hours)
    └── Digital / UX (site bugs, app changes, checkout friction)
```

> 💡 **Grocery:** Always check **waste / spoilage** and **promotional compliance** early.  
> 💡 **Fashion:** Always check **size run availability** and **end-of-season markdown timing**.

---

## Step 3: Data Sources

> **Goal:** Know exactly what data to request and which columns matter.

### Internal Data

| Source | Key Fields | Use Case |
|---|---|---|
| POS / Transaction data | `store_id`, `sku`, `date`, `qty_sold`, `price`, `promo_flag` | Sales trends, basket analysis |
| Loyalty / CRM | `customer_id`, `visit_date`, `spend`, `segment`, `channel` | CLV, churn, RFM |
| Inventory system | `sku`, `store_id`, `stock_on_hand`, `reorder_point`, `lead_time` | Stockout detection, DIO |
| Web / App analytics | `session_id`, `page_views`, `add_to_cart`, `purchase`, `device` | Conversion funnel, cart abandon |
| Returns data | `order_id`, `reason_code`, `sku`, `return_date` | Return rate, quality issues |
| Supplier data | `purchase_order`, `expected_delivery`, `actual_delivery` | OTIF, lead time compliance |

### External Data

| Source | Use Case |
|---|---|
| Weather data | Grocery demand spikes (soup in winter), outdoor fashion seasonality |
| Competitor pricing (scraped) | Price elasticity, response strategy |
| Macro data (unemployment, CPI) | Disposable income effects on discretionary spend |
| Social media / trends | *(Fashion)* Viral trend detection, influencer attribution |
| Google Trends | Early demand signal for new styles or categories |

---

## Step 4: Analysis Plan

> **Goal:** A structured 4-phase analysis approach — always in this order.

### Phase A: EDA & Sanity Checks
- Row counts, null rates, duplicate detection
- Distribution of key metrics (histogram, percentile check)
- Time series plot of the KPI in question + year-ago overlay
- Breakdown by: store, region, category, channel, customer segment

### Phase B: Diagnostic Drill-Down
- Waterfall / decomposition: metric = A × B × C (find which component moved)
- Segment isolation: which stores / SKUs / customers are driving the change?
- Cohort comparison: are new customers behaving differently than retained ones?
- Promotion analysis: is there a promo effect (halo / cannibalization)?

### Phase C: Modelling (when appropriate)

| Problem Type | Technique | Evaluation Metric |
|---|---|---|
| Demand forecasting | XGBoost, SARIMA, Prophet | MAPE, RMSE |
| Customer churn | Logistic Regression, Gradient Boosting | AUC-ROC, Precision-Recall |
| Price elasticity | OLS / Log-log regression | R², coefficient significance |
| Basket recommendations | Apriori, FP-Growth, Collaborative Filter | Lift, Recall@K |
| Store clustering | K-Means, Hierarchical | Silhouette score, business interpretability |
| Inventory optimization | Simulation, stochastic models | Service level, holding cost |

### Phase D: Validation & Sanity Check
- Does the result directionally make intuitive business sense?
- Run the analysis on a holdout time period to confirm
- Check for data artifacts (e.g., did data collection change at the same time as the metric drop?)

---

## Step 5: Define Metrics & Success Criteria

> **Goal:** Pick a North Star + 2–3 guardrail metrics. Avoid metric overload.

### Metric Selection Framework

```
North Star Metric = The single metric that best captures the outcome we care about
Guardrail Metrics = Ensure we don't improve the North Star by degrading other things
```

### Example

| Scenario | North Star | Guardrails |
|---|---|---|
| Reduce grocery churn | 90-day retention rate | Basket size, NPS, promo cost |
| Increase fashion conversion | Online conversion rate | Return rate, margin, cart size |
| Improve grocery availability | On-Shelf Availability (OSA) | Waste %, holding cost, COGS |

---

## Step 6: Formulate Recommendations

> **Goal:** MECE, actionable, prioritized. Link every recommendation to a metric and an owner.

### Recommendation Structure

```
1. Restate the core finding (1 sentence)
2. Root cause identified (from Phase B)
3. Recommended action (specific, time-bound)
4. Expected impact (quantified: "+X% in Y metric over Z weeks")
5. Trade-offs / risks (what could go wrong)
6. Next steps / owner
```

### Common Pitfalls to Avoid
- ❌ Saying "let's collect more data" without saying which data and why
- ❌ Recommending a model without a deployment/monitoring plan
- ❌ Ignoring margin trade-offs when recommending promotions
- ❌ Assuming the data is clean without verifying
- ❌ Narrowly optimizing one metric at the expense of guardrails

---

## Step 7: Communication

> **Goal:** Tailor your output to the stakeholder. Business stakeholders don't want p-values.

### STAR Format (for behavioural framing)

| Component | What to say |
|---|---|
| **Situation** | Context of the problem (what was happening) |
| **Task** | Your specific role and objective |
| **Action** | The analytical steps you took |
| **Result** | The measurable business outcome |

### Stakeholder Tiering

| Audience | Emphasize |
|---|---|
| C-suite / Business | Business impact, ROI, strategic implications |
| Product / Category Manager | Actionable tactics, speed, execution risk |
| Data / Engineering | Methodology, model details, scalability |

---

## Common Retail Case Study Types

| Case Type | Core Question | Grocery? | Fashion? |
|---|---|---|---|
| Sales Decline Investigation | Why did revenue drop? | ✅ | ✅ |
| Churn & Retention | Why are customers leaving? | ✅ | ✅ |
| Inventory Overstock / Stockout | How do we fix availability? | ✅ | ✅ |
| Promotion ROI | Did the promo work? | ✅ | ✅ |
| Store Expansion / Cannibalization | Should we open a new store? | ✅ | ✅ |
| Price Optimization | What price maximizes margin? | ✅ | ✅ |
| Demand Forecasting | What will we sell next week? | ✅ | ✅ |
| Personalization / Recommendations | Which product to show whom? | ✅ | ✅ |
| Basket Analysis | What products go together? | ✅ | ✅ |
| Markdown / Clearance Optimization | When to cut price? When by how much? | ❌ | ✅ |
| Size Run Optimization | Which sizes to stock per style? | ❌ | ✅ |
| Waste / Spoilage Reduction | How to minimize fresh food waste? | ✅ | ❌ |
