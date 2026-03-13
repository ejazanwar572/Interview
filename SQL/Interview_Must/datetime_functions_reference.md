# Top SQL DateTime Functions Cheat Sheet

This document contains a reference for the most frequently used DateTime functions in SQL (primarily focusing on MySQL syntax which is common for interview environments like LeetCode).

---

## 1. DATEDIFF()

**Purpose:** Calculates the exact difference in **days** between two dates. It strips out the time portion completely before calculating.
**Syntax:** `DATEDIFF(end_date, start_date)`

**Examples/Variations:**

```sql
-- 1. Standard usage (Returns positive 9)
SELECT DATEDIFF('2026-03-10', '2026-03-01');

-- 2. Reverse order (Returns negative -9)
SELECT DATEDIFF('2026-03-01', '2026-03-10');

-- 3. With Timestamps (Time is ignored! Returns 1 even though it's only 2 hours apart)
SELECT DATEDIFF('2026-03-02 01:00:00', '2026-03-01 23:00:00');
```

---

## 2. TIMESTAMPDIFF()

**Purpose:** Calculates the difference between two timestamps in a specific **unit** (e.g., SECOND, MINUTE, HOUR, DAY, MONTH, YEAR). Unlike `DATEDIFF`, it does not strip the time and evaluates the strict 24-hour passing of time.
**Syntax:** `TIMESTAMPDIFF(unit, start_timestamp, end_timestamp)`

**Examples/Variations:**

```sql
-- 1. Difference in Hours (Returns 24)
SELECT TIMESTAMPDIFF(HOUR, '2026-03-01 10:00:00', '2026-03-02 10:00:00');

-- 2. Difference in Minutes (Returns 90)
SELECT TIMESTAMPDIFF(MINUTE, '2026-03-01 10:00:00', '2026-03-01 11:30:00');

-- 3. Truncation behavior Note (Returns 0 because a full hour hasn't passed)
SELECT TIMESTAMPDIFF(HOUR, '2026-03-01 10:00:00', '2026-03-01 10:59:59');

-- 4. Difference in Months
SELECT TIMESTAMPDIFF(MONTH, '2025-01-01', '2026-03-01');
```

---

## 3. DATE_ADD()

**Purpose:** Adds a specified time interval to a given date or datetime. Very useful for calculating expiration dates, strict window boundaries, or SLA limits.
**Syntax:** `DATE_ADD(date, INTERVAL value unit)`

**Examples/Variations:**

```sql
-- 1. Add Days (Returns '2026-03-15')
SELECT DATE_ADD('2026-03-10', INTERVAL 5 DAY);

-- 2. Add Time (Returns '2026-03-10 12:30:00')
SELECT DATE_ADD('2026-03-10 10:00:00', INTERVAL 150 MINUTE);

-- 3. Add Months to current date
SELECT DATE_ADD(NOW(), INTERVAL 3 MONTH);
```

---

## 4. DATE_SUB()

**Purpose:** Subtracts a specified time interval from a given date. Primarily used for looking backwards (e.g., retrieving the last 7 days of activity).
**Syntax:** `DATE_SUB(date, INTERVAL value unit)`

**Examples/Variations:**

```sql
-- 1. Subtract Days (Returns '2026-03-08')
SELECT DATE_SUB('2026-03-10', INTERVAL 2 DAY);

-- 2. Trailing 30-day window from today
SELECT DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- 3. Subtract Years (Returns '2025-03-10')
SELECT DATE_SUB('2026-03-10', INTERVAL 1 YEAR);
```

---

## 5. DATE_FORMAT()

**Purpose:** Formats a date value into a specific string representation. Extremely useful for grouping continuous timeseries data into monthly (`YYYY-MM`) or daily (`YYYY-MM-DD`) buckets.
**Syntax:** `DATE_FORMAT(date, format_string)`

**Examples/Variations:**

```sql
-- 1. Format as DD-MM-YYYY (e.g., '10-03-2026')
SELECT DATE_FORMAT('2026-03-10 14:30:00', '%d-%m-%Y');

-- 2. Grouping by Month natively (e.g., '2026-03')
SELECT DATE_FORMAT(event_timestamp, '%Y-%m') AS monthly_cohort
FROM Users;

-- 3. Extracting the Month Name (e.g., 'March')
SELECT DATE_FORMAT('2026-03-10', '%M');

-- 4. Extracting the 12-hour time (e.g., '02:30 PM')
SELECT DATE_FORMAT('2026-03-10 14:30:00', '%h:%i %p');
```
