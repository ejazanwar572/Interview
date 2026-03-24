# 👗 Sample Case 2: Fashion / Apparel Customer Churn & Retention

**Sub-Segment:** Fashion / Apparel (Online + Offline)  
**Difficulty:** Medium–Hard  
**Core Skills:** Churn Modelling, RFM, Survival Analysis, CRM Strategy, CLV

---

## 📋 Problem Statement

> *"You work as a data scientist at a mid-market fashion retailer with 200 UK stores and a growing online channel. The CMO raises a concern: **30% of customers acquired in FY2022 have not made a second purchase in 12 months**. She wants to understand who is churning, why, and what we can do about it."*

---

## ❓ Clarifying Questions to Ask

1. How are we defining **churn**? (No purchase in 6 months? 12 months?)
2. Is the 30% figure improving, worsening, or stable vs. prior cohorts?
3. Is churn higher on **online-acquired vs. in-store-acquired** customers?
4. Do we have **loyalty / CRM data** at customer level? (purchase history, email engagement, return history)
5. What **channels** are used to contact customers? (Email, push, direct mail, paid retargeting)
6. What's the **budget** for a retention campaign?
7. What decision does this analysis inform — modelling, campaign design, or product strategy?

---

## 🔍 Hypothesis Generation (MECE)

```
30% of FY2022 Cohort Has Not Returned
│
├── PRODUCT-RELATED
│   ├── Poor size fit / quality disappointment (first purchase drove negative experience)
│   ├── High return rate → customer disengaged post-return
│   └── Irrelevant product assortment shown at re-visit
│
├── EXPERIENCE-RELATED
│   ├── Post-purchase experience poor (delivery delay, packaging, CS interaction)
│   ├── App / website friction at re-engagement
│   └── First-purchase category was one-off (gifting, occasion wear)
│
├── MARKETING-RELATED
│   ├── No re-engagement communication post-first-purchase
│   ├── Communications are generic (not personalized to style preference)
│   └── Competitor acquired customer loyalty (better value or loyalty program)
│
└── VALUE / PRICE
    ├── Perceived price-quality mismatch
    └── Competitor price advantage in key style segments
```

---

## 📊 Data Sources to Request

| Data | Key Columns | Why |
|---|---|---|
| Transaction data | `customer_id`, `order_date`, `channel`, `sku`, `category`, `price_paid`, `promo_flag` | Purchase history, frequency |
| Returns data | `order_id`, `return_date`, `reason_code`, `sku` | Return experience correlation |
| CRM / Email data | `customer_id`, `email_open_date`, `click_date`, `campaign_id`, `unsubscribe_flag` | Engagement post-purchase |
| Web / App events | `customer_id`, `session_date`, `pages_viewed`, `product_viewed`, `cart_add`, `purchase` | Re-visit intent |
| Customer profile | `customer_id`, `acquisition_channel`, `first_purchase_category`, `loyalty_tier` | Segment drivers |
| NPS / CSAT surveys | `customer_id`, `nps_score`, `csat_score`, `verbatim_comment` | Experience signal |

---

## 📐 Analysis Plan

### Step 1 — Define & Measure Churn
```python
# Churn = no purchase in 12 months from first purchase date
is_churned = (today - second_purchase_date).isnull() 
             OR (second_purchase_date - first_purchase_date) > 365
```
- Calculate churn rate by: acquisition channel, first purchase category, return status, and loyalty tier

### Step 2 — RFM Segmentation of Churned Cohort
Assign each FY2022 customer an RFM label as of 12 months post-acquisition:
- **Champions (553–555):** Still active → retain
- **At Risk (222–333):** Declining engagement → priority win-back
- **Lost (111):** Long lapsed → cost vs. value trade-off
- **New Promising:** Single purchase, recent → early intervention

### Step 3 — Survival Analysis (Kaplan-Meier by Segment)
Plot **time-to-churn curves** by:
- Acquisition channel (paid social, email, in-store, referral)
- First purchase category (occasionwear vs. basics vs. accessories)
- Return flag (did they return first purchase? → check churn rate uplift)

> 💡 Fashion Insight: Customers whose first purchase was returned churn at **2–3× the rate** of non-returners. This is critical to catch early.

### Step 4 — Predictive Churn Model
**Features to include:**
- Days since last purchase
- Number of purchases in first 90 days
- Return rate (first 3 orders)
- Email engagement score (open/click rate)
- Product category diversity
- Avg discount % on purchases
- First purchase channel

**Model:** Gradient Boosting (XGBoost) for classification with AUC-ROC as primary metric  
**Output:** Churn probability score per customer (0–1)

### Step 5 — Segment Actionable Groups
| Score Bucket | Label | Size Estimate | Action |
|---|---|---|---|
| 0.7–1.0 | High Risk | 15% | Immediate win-back: personalized email + exclusive discount |
| 0.4–0.69 | Medium Risk | 20% | Engagement nudge: style quiz + product recommendation email |
| 0.0–0.39 | Low Risk | 65% | Loyalty programme CTA + BVNL (be visible not loud) |

---

## 💡 Recommendations

| Priority | Action | Expected Impact |
|---|---|---|
| **1 (Quick Win)** | Trigger automated win-back email at Day 60 post-purchase with a personalized recommendation carousel | +8–12% second-purchase rate for at-risk segment |
| **2** | For customers who returned their first order: flag as "high churn risk" in CRM immediately and escalate CS contact within 48 hrs | Reduce post-return churn by 15–20% |
| **3** | Redesign the post-purchase journey: add style profile quiz + curated "next for you" email sequence | Improve 90-day engagement rate |
| **4** | A/B test: personalised size recommendation vs. generic product email | Measure lift in conversion and reduction in return rate |

---

## 📈 Success Metrics

| Metric | Current | Target (12 months) |
|---|---|---|
| 12-month repeat purchase rate | 70% | 80% |
| Post-return churn rate | 60% | 40% |
| Email CTR for win-back campaign | Baseline TBD | ≥ 5% |
| CLV (FY2022 cohort) | £X | +15% uplift |
| AUC-ROC of churn model | — | ≥ 0.80 |

---

## 🔁 STAR Format

| Component | Example |
|---|---|
| **Situation** | 30% of FY2022 fashion cohort churned within 12 months; CMO wants root cause and intervention |
| **Task** | Build churn model, identify at-risk segments, propose CRM response |
| **Action** | Built XGBoost churn model (AUC 0.83); found return-rate and first-order category as top drivers; segmented high-risk customers; recommended automated trigger at Day 60 |
| **Result** | Win-back campaign delivered 11% second-purchase uplift on high-risk segment; equivalent to £2.4M incremental annual revenue |
