# Behavioral & Leadership (STAR Narratives for Wells Fargo)

As a "Lead Analytics Consultant", your technical skills get you the interview, but your **leadership, communication, and process management** get you the job. Wells Fargo heavily indexes on risk and compliance.

Use the **STAR** method (Situation, Task, Action, Result) for all behavioral questions.

---

## Narrative 1: Leading End-to-End Analytics Projects (General)
**Q: "Tell me about a time you led an analytics project from gathering requirements to final delivery."**

* **Situation:** A business unit needed a new dashboard to track customer transaction drops because they couldn't identify where the pipeline was failing.
* **Task:** As the Lead, I was tasked with building an end-to-end solution: from data modeling to the final BI visualization.
* **Action:** I initiated discovery sessions with the business stakeholders to translate vague requests into clear KPIs. I then designed the data model, established an automated ETL pipeline using Python/SQL, and built the final views. I ensured I held weekly syncs to iterate on feedback.
* **Result:** Delivered the solution 2 weeks ahead of schedule. Post-launch, the business team identified a 15% drop-off in a specific transaction tier, saving them hours of manual investigation.

## Narrative 2: Agile Ways of Working & User Stories
**Q: "How do you handle ambiguous requirements and translate them into efficient user stories?"**

* **Situation:** The business wanted "better ML insights" but couldn't articulate exactly what that meant for the data team.
* **Task:** I had to break this down into an actionable, Agile sprint plan.
* **Action:** I sat down with the Product Owner and wrote out Epics. I broke those down into specific User Stories following the INVEST criteria (Independent, Negotiable, Valuable, Estimable, Small, Testable). *Example Story:* "As a Risk Manager, I want to see a daily aggregated table of flagged transactions, so that I can audit them by end-of-day." I also ensured acceptance criteria included data validation checks.
* **Result:** The data engineering team had a crystal-clear backlog. We increased our sprint velocity by 20% because developers weren't blocked by ambiguous requirements.

## Narrative 3: Mentoring Junior Consultants
**Q: "Tell me about a time you mentored a junior team member."**

* **Situation:** A junior analyst on my team was struggling with optimizing SQL queries, causing pipeline delays.
* **Task:** I needed to upskill them without just doing the work for them.
* **Action:** I set up a weekly 30-minute pair-programming session. Instead of giving them the answers, I walked them through `EXPLAIN` execution plans and how to look for full table scans. I reviewed their PRs (Pull Requests) thoughtfully, pointing out why a CTE was better than a subquery in a specific instance.
* **Result:** Within 2 months, their queries were running significantly faster, and they eventually led a small optimization epic on their own.

## Narrative 4: Data Governance & Compliance (The "Wells Fargo" Answer)
**Q: "How do you ensure data security and compliance in your analytics workflows?"**

* **Situation:** We were migrating legacy data to a new cloud warehouse (e.g., GCP BigQuery) and realized there was potential PII (Personally Identifiable Information) mixed in.
* **Task:** I had to ensure our new analytics sandbox was compliant with strict banking regulations.
* **Action:** I partnered with the InfoSec and Data Governance teams. Before any modeling began, I implemented a pipeline step to hash/mask sensitive fields (like SSN or full names). I utilized metadata management tools (like Dataplex/Purview) to tag sensitive columns and set up Role-Based Access Control (RBAC) so analysts only saw what they needed.
* **Result:** Passed internal compliance audits with zero findings, establishing a reusable governance framework for future project migrations. 

## Pro-Tips for Tomorrow's Technical Round:
1. **Clarify before Coding:** When given a technical case study, spend 2 minutes asking establishing questions before writing a single line of SQL or Python. *"Does this column contain nulls? Are we optimizing for compute cost or speed?"*
2. **Think out loud:** Even if you write a buggy PySpark/Python line, if your logic is sound and stated clearly, you will pass.
3. **Bring it back to the business:** Always tie an AI/ML concept or an SQL optimization back to the fact that it *reduces cost* or *increases efficiency* for the bank.
