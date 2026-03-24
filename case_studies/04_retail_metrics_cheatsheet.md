# 📊 Retail Metrics Cheat Sheet

> Quick-reference formulas, benchmarks, and interpretation signals for **Grocery** and **Fashion/Apparel**. Memorize these before any retail interview.

---

## 1. Sales KPIs

| Metric | Formula | Grocery Benchmark | Fashion Benchmark | Signal When Low |
|---|---|---|---|---|
| **Revenue / GMV** | Σ (Price × Qty Sold) | N/A (varies) | N/A (varies) | Demand or availability issue |
| **Comp-Store Sales Growth** | `(Current Sales − Prior Year Sales) / Prior Year Sales × 100` | +2–4% healthy | +3–6% healthy | Market share loss or traffic drop |
| **Conversion Rate (In-store)** | `Transactions / Footfall × 100` | 25–40% | 15–25% | Poor UX, assortment, or staff |
| **Conversion Rate (Online)** | `Purchases / Sessions × 100` | 2–5% | 1.5–3.5% | Funnel friction, irrelevant recommendations |
| **AOV / ATV** | `Total Revenue / Number of Transactions` | £25–£60 | £60–£120 | Low basket size or pricing too low |
| **Sales per Square Foot** | `Revenue / Total Retail Floor Area (sq ft)` | $400–$600/yr | $200–$400/yr | Space inefficiency, poor planogram |
| **Sell-Through Rate** | `Units Sold / Units Received × 100` | >85% (ambient) | >70% (full-price) | Overstock, demand miss |
| **YoY Growth** | `(This Year − Last Year) / Last Year × 100` | +3–5% | +4–8% | Underperformance vs. market |
| **Revenue Lift (Promo)** | `(Promo Sales − Baseline Sales) / Baseline Sales × 100` | 15–30% | 20–40% | Promo not driving incremental value |

---

## 2. Customer KPIs

| Metric | Formula | Benchmark | Signal When Off |
|---|---|---|---|
| **CLV** | `ARPU × Gross Margin % × Avg Lifespan (yrs)` | Varies; top decile 3–5× median | Low → poor retention or margin |
| **CAC** | `Total Marketing Spend / New Customers Acquired` | Grocery: £5–15 | Fashion: £20–40 | High → inefficient acquisition |
| **CLV : CAC Ratio** | `CLV / CAC` | Target ≥ 3× | < 3 → unsustainable unit economics |
| **Churn Rate** | `Customers Lost / Customers at Start of Period × 100` | Grocery: 8–15%/yr | Fashion: 30–50%/yr | High → poor loyalty, NPS, or relevance |
| **Retention Rate** | `1 − Churn Rate` | Grocery: 85–92% | Fashion: 50–70% | Inverse of churn above |
| **NPS** | `% Promoters − % Detractors` | Grocery: 30–55 | Fashion: 40–65 | < 20 → experience/service issue |
| **Repeat Purchase Rate** | `Customers w/ ≥2 Purchases / Total Customers × 100` | Grocery: 75%+ | Fashion: 25–40% | Low → onboarding or relevance issue |
| **Cart Abandonment Rate** | `(Carts Started − Carts Completed) / Carts Started × 100` | Industry avg: 65–75% | Target: <65% | High → checkout friction / payment issues |
| **Return Rate** | `Units Returned / Units Sold × 100` | Grocery: <2% | Fashion (online): 20–40% | High → sizing, quality, or photo accuracy |
| **RFM Score** | Rank customers on Recency (1–5), Frequency (1–5), Monetary (1–5) | N/A | N/A | Low scores → segment for win-back |

> #### RFM Scoring Reference
> | Score | Recency | Frequency | Monetary |
> |---|---|---|---|
> | 5 | Purchased within last 7 days | 10+ purchases | Top 20% spenders |
> | 3 | Purchased 1–3 months ago | 3–5 purchases | Mid-tier spenders |
> | 1 | No purchase in 6+ months | Single purchase | Bottom 20% spenders |

---

## 3. Profitability KPIs

| Metric | Formula | Grocery Benchmark | Fashion Benchmark |
|---|---|---|---|
| **Gross Margin** | `(Revenue − COGS) / Revenue × 100` | 25–30% | 50–60% |
| **Net Margin** | `Net Profit / Revenue × 100` | 2–4% | 8–12% |
| **Gross Profit per Basket** | `Gross Margin × AOV` | £7–£18 | £30–£70 |
| **ROAS** | `Revenue from Ads / Ad Spend` | ≥ 4× | ≥ 5× |
| **Promo Profit Lift** | `Incremental Gross Profit − Promo Cost` | Should be > 0 | Should be > 0 |

---

## 4. Digital / Omnichannel KPIs

| Metric | Formula | Benchmark |
|---|---|---|
| **Session-to-Cart Rate** | `Sessions with Add-to-Cart / Total Sessions × 100` | 8–15% |
| **Cart-to-Purchase Rate** | `Completed Purchases / Sessions with Cart × 100` | 25–35% |
| **Total Funnel Conversion** | `Purchases / Total Sessions × 100` | 2–5% |
| **Revenue per Visitor (RPV)** | `Total Revenue / Total Visitors` | £2–£5 (fashion online) |
| **Email Open Rate** | `Opened / Delivered × 100` | Retail avg: 20–25% |
| **Email Click-Through Rate** | `Clicks / Delivered × 100` | Retail avg: 2–5% |
| **BOPIS Uptake Rate** | `BOPIS Orders / Total Online Orders × 100` | 15–25% (growing) |

---

## 5. Employee KPIs

| Metric | Formula | Benchmark |
|---|---|---|
| **Sales per Employee** | `Total Revenue / Headcount` | Varies by format |
| **Revenue per Labour Hour** | `Revenue / Total Labour Hours` | Track vs. own baseline |
| **Employee Turnover Rate** | `Employees Left / Avg Headcount × 100` | Retail avg: 60–70% (high) |
| **Avg Transaction per Staff Hour** | `Transactions / Total Staff Hours` | Track peak vs. off-peak |

---

## 6. Key Formula Reference Card

```
CLV             = ARPU × Gross Margin (%) × Avg Customer Lifespan
CAC             = Total Spend / New Customers
Inventory Turn  = COGS / Avg Inventory
DIO             = 365 / Inventory Turnover
Sell-Through    = Units Sold / Units Received × 100
Conversion Rate = Transactions / Footfall × 100
Churn Rate      = Customers Lost / Customers at Start × 100
NPS             = % Promoters − % Detractors
ATV / AOV       = Revenue / # Transactions
Lift (Promo)    = (Promo Sales − Baseline) / Baseline × 100
Sales/Sqft      = Revenue / Floor Area
Gross Margin    = (Revenue − COGS) / Revenue × 100
Return Rate     = Returns / Units Sold × 100
ROAS            = Revenue from Ads / Ad Spend
```

---

## 7. Interpretation Signals Cheat Sheet

| Scenario | Metric Combination | Most Likely Cause |
|---|---|---|
| Revenue down, footfall stable | ↓ Conversion or ↓ AOV | Assortment, pricing, or UX problem |
| Revenue down, footfall down | ↓ Traffic | Marketing, competitor, or macro |
| High sell-through but high stockouts | OSA < 95% | Replenishment failure, phantom inventory |
| High return rate + low NPS | Product quality or sizing mismatch | Product description or size run issue |
| High CAC + low CLV:CAC | < 3× ratio | Acquisition channels inefficient or wrong segment |
| Promo lift positive but margin down | Profit lift < 0 | Over-discounting, cannibalization |
| YoY flat but comp-stores negative | New store opening masking decline | Cannibalization of nearby stores |
