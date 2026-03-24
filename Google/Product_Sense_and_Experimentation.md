# Product Sense and Experimentation

The Product Sense interview tests your ability to connect data insights with business strategy. At Google, the primary focus is the **USER**. You must demonstrate structured thinking, trade-off reasoning, and deep curiosity about user behavior.

## Core Framework: The "GAME" Framework
When answering open-ended product questions, structure your thoughts using frameworks like GAME or a similar step-by-step approach.
- **G - Goal**: What is the overarching goal of the product or specific feature? Connect this to the broader company mission.
- **A - Actions**: What actions do we want the user to take to achieve this goal?
- **M - Metrics**: What metrics specifically track these actions? (e.g., primary/North Star metric, secondary metrics, guardrail metrics).
- **E - Evaluations**: How do we evaluate these metrics? (e.g., A/B testing, causal inference, longitudinal studies).

## Key Metric Categories
- **User Satisfaction**: CSAT, NPS, App Store ratings, implicit signals (dwell time, return rate, specific feature interaction).
- **Engagement**: Daily Active Users (DAU), Monthly Active Users (MAU), session length, feature adoption rate.
- **Efficiency**: Latency, time to complete a core task, error rates, bounce rates.
- **Predictability & Retention**: Churn rate, LTV (Lifetime Value), cohort retention curves.

---

## Example FAANG / Google Scenarios

### Scenario 1: Diagnosing a Problem (The "Drop in a Metric" Question)
**Question**: "We noticed a 15% drop in user engagement on the Google Play Games app over the last week. How would you investigate this?"

**How to answer (The Diagnostic Framework)**:
1.  **Clarify the Metric**: What exactly defines "engagement" here? Is it DAU, session length, or games played?
2.  **Timeframe & Scope**: Was the drop sudden (one day) or gradual? Is it global or isolated to a specific region, device (Android version), or user segment?
3.  **Internal Factors**: Did we recently launch a new feature? Were there server outages or latency issues? Was there a change in the tracking or logging system?
4.  **External Factors**: Is there a seasonality effect (e.g., holidays, back-to-school)? Did a competitor launch a major feature? Is there an external macro event?
5.  **Hypothesis Generation & Data Validation**: Formulate hypotheses based on the above and explain how you would write SQL queries to pull data and test them.

---

### Scenario 2: Measuring Success
**Question**: "We offered users 10% off of all their purchases at the Google Play store last weekend. How can we determine if this promotion was successful or not?" *(Straight from the Google Prep PDF)*

**How to answer**:
1.  **Clarify Assumptions**: "Did every user receive this offer globally, or did we select certain users? And if so - how did we segment this selection? Do I have purchase history trends for previous weekends?"
2.  **Define Success Goal**: Was the goal to increase pure revenue, bring in new first-time purchasers, or drive engagement in specific game verticals?
3.  **Define Metrics**: 
    - *Primary Base Metric*: Incremental Revenue, Total Conversion Rate of the offer.
    - *Secondary/Counter Metrics*: Cannibalization of future purchases (did users just stock up and stop buying later?), profit margin change.
4.  **Evaluation Strategy**: If it was a randomized offer (A/B Test), we compare the Treatment and Control. If it was a global rollout, we would need to use causal inference techniques like Difference-in-Differences (if we have a comparable counterfactual) or CausalImpact (time series analysis) using historical data as the synthetic control.

---

### Scenario 3: Design an Experiment
**Question**: "Google Maps is thinking of adding a new feature that highlights eco-friendly routing. How would you test this?"

**How to answer**:
1.  **Goal**: Reduce carbon emissions and improve user satisfaction without severely compromising ETA.
2.  **Experiment Design**: A/B test where Control gets standard routing and Treatment gets eco-friendly routing highlighted.
3.  **Metrics**: 
    - *Success*: % of users selecting the eco-friendly route.
    - *Guardrail*: DAU, Uninstallation rates, Total travel time variance.
4.  **Network Effects consideration**: Since routing affects traffic, standard A/B testing might suffer from interference (SUTVA violation). A switchback experiment or geographical split (geo-experiment) might be required.
