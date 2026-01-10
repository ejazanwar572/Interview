---
description: Autonomous Job Hunt & Tailor Resume
---

# **/tailor_job_application_v2 — Execution Checklist (WITH FIXED COMPANY LIST)**

---

## **0. Preconditions (Must Be True Before Start)**

* **Company scope is fixed and authoritative** (see Section 1)
* Target roles:

  * Senior Product Analyst
  * Senior Data Analyst
  * Lead Analyst
  * Analytics Manager
* Location = India
* Posting window ≤ 4 days
* Base resume = **generic analytics resume**
* `generate_standard_resume.py` exists and is executable

---

## **1. Company Scope (HARD CONSTRAINT)**

Search **ONLY** the official career pages / ATS of the following companies.
**Do NOT search outside this list.**

### **Big Tech / Product**

* Google
* Amazon
* Microsoft
* Adobe
* eBay
* Salesforce
* Uber
* Ola
* Grab

### **Indian Consumer & Fintech**

* Flipkart
* Swiggy
* Zomato
* Paytm
* PhonePe
* Razorpay
* Meesho
* Groww

### **Payments & Financial Services**

* Visa
* Mastercard
* Stripe
* Wells Fargo

### **Enterprise / Data**

* Gartner
* S&P Global

### **Retail / Travel / FMCG**

* Target
* Expedia Group
* PepsiCo

> This list is **final** unless explicitly modified by the user.

---

## **2. Discover Career Pages**

For **each company in Section 1**:

* Locate official:

  * Career / Jobs page
  * ATS-hosted listings (Greenhouse, Workday, Lever, Ashby, etc.)
* Use Google **only** to locate these pages
* ❌ Do not use job portals or aggregators

---

## **3. Search for Roles (Company-Scoped Only)**

Within each company’s career system:

* Search for target roles
* Apply filters:

  * Location = India
  * Posting date ≤ 4 days (if supported)
* Ignore blogs, referral pages, archived listings

---

## **4. Hard Verification Gate**

For **every role found**, confirm:

* Job = Active
* Applications = Open
* Posting not expired
* Apply button functional
* Job detail page loads correctly

**Immediately discard** if:

* “No longer accepting applications”
* “Applications closed”
* “Position filled”
* “Expired”
* Disabled Apply button
* ATS 404 / redirect loop
* Generic listing page instead of JD

---

## **5. Rank & Select Top Matches**

From verified roles:

* Rank by:

  * Seniority alignment
  * Analytics depth
  * Tooling relevance
  * Product/business impact
* Select **top 1–3 roles only**

---

## **6. Extract Job Descriptions**

For each selected role:

* Responsibilities
* Qualifications
* Required skills/tools
* Experience requirements

---

## **7. Tailor Resume (Markdown First)**

For each role:

* Start from **generic analytics base resume**
* Create:

  ```
  /Users/ejazanwar/Desktop/Interview/Resumes/<Company>_<Role>_Resume.md
  ```
* Update:

  * Professional summary
  * Skills (JD-mapped)
  * Experience bullets (impact-driven)

---

## **8. Generate PDF Resume**

* Run:

  ```
  python3 /Users/ejazanwar/Desktop/Interview/Scripts/generate_standard_resume.py <Input_MD_Path> <Output_PDF_Path>
  ```
* Verify PDF creation

---

## **9. Final Link Validation**

* Open each Apply link
* Confirm:

  * Exact job posting
  * Official company ATS
  * Application still open
* Replace rejected roles if needed

---

## **10. Final Report Output**

Include only fully verified roles:

* Company
* Role title
* Posting date
* Job type
* Verified Apply link
* PDF resume path

---

## **11. Stop Conditions**

* Stop after 1–3 valid roles
* No padding
* No partially verified jobs

---

### Bottom line

You’re right to call this out.
**Company scope must live inside the checklist**, not in memory or prior messages.
This version is now **execution-safe and unambiguous**.

If you want next:

* YAML/JSON config version
* Agent pseudo-code
* Retry / failure handling logic

Say which.
