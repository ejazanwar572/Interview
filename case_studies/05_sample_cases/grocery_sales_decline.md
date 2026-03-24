# 🛒 Sample Case 1: Grocery Sales Decline Investigation

**Sub-Segment:** Grocery / FMCG  
**Difficulty:** Medium  
**Core Skills:** Decomposition, Root Cause Analysis, EDA, Diagnostic Analytics

---

## 📋 Problem Statement

> *"You are a data analyst at a UK-based supermarket chain with 450 stores. The Head of Trading has flagged that **like-for-like (comp-store) sales dropped 6% in Q3 vs. the same quarter last year**. You are asked to investigate the root cause and provide recommendations."*

---

## ❓ Clarifying Questions to Ask

Before diving in, state the following questions aloud:

1. Is the 6% drop in **revenue**, **units sold**, or both?
2. Is the decline **across all stores** or concentrated in a subset (region, tier, format)?
3. Has there been any **change in product ranging**, promotions, or pricing in Q3?
4. Are there known **external factors**? (Competitor opening, inflation, weather event?)
5. What **data do we have access to**? (POS, loyalty, inventory, footfall counters?)
6. What is the **decision this analysis will drive**? (Tactical promo response, strategic ranging change, ops fix?)

---

## 🔍 Hypothesis Generation (MECE)

```
Comp-Store Sales ↓ 6%
│
├── FEWER CUSTOMERS (Traffic ↓)
│   ├── Lost to competitor (new entrant or competitor promo)
│   ├── Consumer sentiment / macro (cost-of-living squeeze → fewer Top-ups)
│   └── Less effective marketing / lapsed loyalty card members
│
├── LOWER BASKET VALUE (AOV ↓)
│   ├── Trading down (branded → private label, full-size → smaller packs)
│   ├── Fewer items per basket (hardship purchase behavior)
│   └── Fewer high-margin categories in basket (fresh, alcohol, premium)
│
├── LOWER CONVERSION (Footfall same but fewer transactions)
│   ├── In-store experience issue (queues, out-of-stocks)
│   └── Browse-to-buy friction (out-of-stock on key items)
│
└── SUPPLY-SIDE (Available product on shelf ↓)
    ├── Stockouts on high-velocity SKUs
    └── Reduced planogram space for key categories
```

---

## 📊 Data Sources to Request

| Data | Key Columns | Why |
|---|---|---|
| POS weekly sales | `week`, `store_id`, `category`, `sku`, `qty`, `revenue`, `promo_flag` | Decompose the 6% |
| Footfall counters | `week`, `store_id`, `customer_count` | Isolate traffic vs. basket |
| Loyalty card data | `customer_id`, `visit_date`, `spend`, `basket_items`, `segment` | Cohort-level analysis |
| Inventory / OSA report | `store_id`, `sku`, `oos_hours`, `waste_units` | Check supply side |
| Promo calendar | `promo_id`, `weeks`, `sku_list`, `promo_type` | Control for promo base change |
| Competitor intel | Competitor promo events, new store openings by area | External hypothesis |

---

## 📐 Analysis Plan

### Step 1 — Decompose the 6%
```
YoY Revenue Gap
= Footfall Change  ×  Conversion Change  ×  AOV Change
```
Plot each component week-over-week for Q3 vs. prior year. Identify which lever moved first.

### Step 2 — Segment by Store
- Quartile stores by magnitude of decline
- Map poor performers to geography → look for regional pattern
- Check if any store tier (large, medium, convenience) is disproportionate

### Step 3 — Category Waterfall
- Rank categories by absolute revenue contribution to the gap
- Top 3–5 categories typically explain 70%+ of the gap (Pareto)
- Drill into fresh (produce, dairy, meat) — highest velocity, highest shrinkage risk

### Step 4 — Customer Cohort Check
- Compare: Are fewer loyalty customers transacting, or are the same customers spending less?
- Run RFM shift analysis: Has the Active → Lapsed migration accelerated since Q2?
- New customer acquisition rate: Has it slowed vs. prior year?

### Step 5 — OSA & Inventory Cross-Check
- Pull stockout events for top 200 velocity SKUs during Q3
- If OSA < 97%, flag as a likely contributing factor
- Check if stockout periods correlate to the worst-performing weeks

---

## 💡 Likely Root Causes & Recommendations

### Scenario A: Traffic is down, Basket is flat
→ **Root Cause:** External / acquisition problem (macro squeeze, competitor)  
→ **Action:** Reactivate lapsed loyalty members via targeted CRM campaign, review price position on KVIs (Key Value Items)

### Scenario B: Traffic is flat, Basket is down
→ **Root Cause:** Trading down behavior or fresh attachment issue  
→ **Action:** Promote premium private label in fresh; introduce value bundle offers on staples

### Scenario C: Stockout rate > 5% in top categories
→ **Root Cause:** Supply chain / replenishment gap  
→ **Action:** Review safety stock for top 500 SKUs; improve demand forecasting frequency for fresh

---

## 📈 Success Metrics

| Metric | Baseline (Q3 LY) | Target (Q3 TY) |
|---|---|---|
| Comp-store sales growth | −6% | ≥ 0% (flat recovery) |
| OSA | Below 97% | ≥ 97% |
| Lapsed customer reactivation | — | +10% back to active |
| AOV | — | Stabilize at prior year level |

---

## 🔁 STAR Format (Storytelling for Interview)

| Component | Example |
|---|---|
| **Situation** | Grocery chain facing 6% comp-store sales decline in Q3 |
| **Task** | Identify the root cause and recommend targeted intervention |
| **Action** | Decomposed revenue into footfall × conversion × AOV; ran category waterfall; segmented stores; found top 3 categories (fresh produce, dairy, chilled ready meals) accounting for 65% of gap, driven by OSA issues post a DC change |
| **Result** | Prioritized replenishment fix for top 200 SKUs; comp-store trend improved from −6% to −2% within 6 weeks |
