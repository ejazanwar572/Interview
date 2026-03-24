# 📦 Sample Case 3: Fashion / Apparel Inventory Overstock & Markdown Optimization

**Sub-Segment:** Fashion / Apparel  
**Difficulty:** Hard  
**Core Skills:** Inventory Analytics, Price Optimization, Sell-Through Forecasting, Decision Modelling

---

## 📋 Problem Statement

> *"You are a data scientist at a fast-fashion retailer. It is Week 10 of a 20-week Spring-Summer season. The Head of Buying flags that **15 styles across Womenswear have a sell-through rate below 25%**, significantly below the 60% target at this stage. The business must decide: when to markdown, by how much, and which styles to prioritize — without destroying margin unnecessarily on styles that may recover."*

---

## ❓ Clarifying Questions to Ask

1. What is the remaining sell-through target at **end of season** (Week 20)? (e.g., >80% at full price, or clear 100%?)
2. What are the **markdown rules**? Are there floors (minimum price protection) or brand restrictions?
3. Is the underperformance **consistent across all stores** or concentrated (e.g., specific sizes, regions, online only)?
4. Do we have **size-level sell-through** data, or only style-level?
5. Are any of the 15 styles **carryover (cross-season)** vs. true new-season introductions?
6. What is the **clearance pathway** if full-season markdown still leaves stock? (Outlet, liquidation, charity?)
7. What is the margin floor — i.e., below what gross margin does the business prefer to hold stock rather than clear?

---

## 🔍 Hypothesis Generation (MECE)

```
15 Styles with Sell-Through < 25% at Week 10
│
├── DEMAND-SIDE
│   ├── Trend shift (style no longer resonating with target customer)
│   ├── Poor photography / representation online
│   ├── Competitor offering a better alternative at same price point
│   └── Lack of visibility (merchandising weight, search ranking, email feature)
│
├── SUPPLY-SIDE
│   ├── Wrong size run (over-bought S/XS, under-bought M/L → early loss of traffic)
│   └── Stockout in popular sizes → KPI distorted
│
├── PRICING
│   ├── Full price too high relative to perceived value
│   ├── Insufficient promotional support (no featured in paid social/email)
│   └── Misalignment vs. comparable competitor styles
│
└── PLANNING / BUYING
    ├── Over-bought depth on low-confidence styles
    └── Delayed web / store introduction (late to market)
```

---

## 📊 Data Sources to Request

| Data | Key Columns | Why |
|---|---|---|
| Sales & sell-through (by style, size, colour, week) | `style_id`, `size`, `colour`, `week`, `units_sold`, `units_received`, `price_paid`, `channel` | Core analysis |
| Stock-on-hand (current snapshot) | `style_id`, `size`, `store_id`, `SOH_units` | Understand remaining exposure |
| Web engagement | `style_id`, `sessions`, `pdp_views`, `add_to_cart`, `purchase`, `return_rate` | Demand signal |
| Markdown history | `style_id`, `original_price`, `markdown_date`, `new_price`, `units_sold_post_markdown` | Elasticity estimation |
| Style metadata | `style_id`, `category`, `price_tier`, `intro_week`, `carryover_flag`, `trend_tag` | Segment analysis |
| Competitor data | `competitor_style`, `price`, `sell_out_indicator` | Competitive position |

---

## 📐 Analysis Plan

### Step 1 — Triage the 15 Styles
Classify each style on a 2×2:
```
         │   High Inventory Exposure
         │       (units × price)
─────────┼──────────────────────────
High     │  PRIORITY CLEAR  │  WATCH
Demand   │  (markdown now)  │  (nudge)
Signal   │─────────────────────────── 
Low      │   LIQUIDATE/EXIT │  HOLD?
Demand   │  (deep discount) │  (reassess)
Signal   │
```
- **Demand Signal** = session growth + add-to-cart rate + basket attach rate
- **Inventory Exposure** = remaining SOH × full price × (1 − expected sell-through)

### Step 2 — Size Run Analysis
For each style, check:
```
Size Fill Rate = Sizes Available in At Least 1 Store / Total Sizes in Range
```
- If key sizes (M, L) are already sold out → organic sell-through underreported
- This changes the action from "markdown" to **"size consolidation + rebalancing"**

### Step 3 — Markdown Elasticity Modelling
Using historical markdown events from prior seasons:

```
ln(ΔQty) = β₀ + β₁ × ln(ΔPrice) + ε
```

Where `β₁` = price elasticity. Typical fashion elasticity: **−1.5 to −3.0**

Compute:
- Revenue-maximizing markdown %
- Profit-maximizing markdown % (accounting for COGS floor)
- Clearance markdown % (target: 100% sell-through by end of season)

> 💡 **Key Insight:** If elasticity < −2.0, a 20% markdown generates enough volume that gross profit increases. If elasticity > −1.0, discounting destroys more revenue than it generates — hold at full price.

### Step 4 — Scenario Modelling (Decision Table)

For each triage group, model 3 scenarios:

| Scenario | Markdown % | Predicted Sell-Through | Gross Margin | Residual Risk |
|---|---|---|---|---|
| Hold (no action) | 0% | 30% | 60% | High overstock at week 20 |
| Mid Markdown | −20% | 55% | 45% | Some residual, manageable |
| Aggressive Markdown | −40% | 85% | 28% | Cleared; low margin |

### Step 5 — Markdown Timing Curve (When to Move)
For fashion clearance, markdown too early = margin destruction; too late = liquidation:

```
Optimal markdown window = 6–8 weeks before end of season
                        = No later than Week 12–14 (of 20-week season)
```
Use **survival analysis** (time-to-sell) per price point to predict likely sell-through by end of season without intervention.

---

## 💡 Recommendations

| Style Group | Action | Timing | Markdown | Rationale |
|---|---|---|---|---|
| High Demand + High Stock | Feature in email + paid social; no markdown yet | Week 11–12 | 0% now, −15% at Week 14 if sell-through < 50% | Demand is there; visibility fix first |
| Low Demand + High Stock | −25% markdown immediately | Week 11 | −25% | Elasticity suggests volume gain > margin loss |
| Size-run gap styles | Consolidate sizes across stores; rebalance NDC → stores with live sizes | Week 11 | 0% | Supply fix, not demand fix |
| Low Demand + Low Stock | Hold — small exposure; liquidate at Week 19 if needed | Week 19 | −50%+ | Not worth disturbing markdown architecture |

---

## 📈 Success Metrics

| Metric | Target |
|---|---|
| Sell-Through Rate (problematic styles) | ≥ 75% by Week 20 |
| Full-Price Sell-Through (all womenswear) | ≥ 70% |
| Markdown Gross Margin Retention | ≥ 40% blended |
| End-of-Season Overstock Value | < £500k (vs. £2.2M current projection) |
| Clearance Residual (for outlet) | < 5% of opening OTB |

---

## 🔁 STAR Format

| Component | Example |
|---|---|
| **Situation** | 15 SS womenswear styles at Week 10 below 25% sell-through vs. 60% target; £2.2M overstock projection |
| **Task** | Triage styles, model markdown elasticity, produce decision table to guide buying team |
| **Action** | Built 2×2 triage matrix; size-run analysis found 4 styles had sellable sizes depleted (not a demand issue); modelled elasticity for remaining 11 styles; ran 3-scenario P&L on each |
| **Result** | Recommended staggered markdown: Week 11 at −25% for 6 styles, visibility-only nudge for 4 styles, size rebalance for 4; end-of-season overstock reduced from £2.2M to £380k |
