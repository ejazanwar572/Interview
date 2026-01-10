# MySQL Date Functions Cheatsheet

Here are the most commonly used date functions in MySQL for interviews and daily work.

> 
> The functions below are specifically for **MySQL** (standard interview SQL).

---

## 1. Getting Current Time
| Function | Description | Example |
| :--- | :--- | :--- |
| `NOW()` | Current date and time | `2025-12-14 16:20:00` |
| `CURDATE()` | Current date only | `2025-12-14` |
| `CURTIME()` | Current time only | `16:20:00` |

## 2. Formatting Dates (`DATE_FORMAT`)
Used to convert a date object into a specific string format.
**Syntax**: `DATE_FORMAT(date, format_string)`

```sql
SELECT DATE_FORMAT(NOW(), '%Y-%m-%d'); -- '2025-12-14'
SELECT DATE_FORMAT(NOW(), '%D %M %Y'); -- '14th December 2025'
```

**Common Specifiers:**
- `%Y`: Year (2025)
- `%m`: Month numeric (12)
- `%M`: Month name (December)
- `%d`: Day numeric (14)
- `%D`: Day suffix (14th)
- `%H`: Hour (24-hr) | `%h`: Hour (12-hr)

## 3. Extracting Parts
| Function | Example Input | Result |
| :--- | :--- | :--- |
| `YEAR(date)` | `YEAR('2025-12-14')` | `2025` |
| `MONTH(date)` | `MONTH('2025-12-14')` | `12` |
| `DAY(date)` | `DAY('2025-12-14')` | `14` |
| `WEEK(date)` | `WEEK('2025-12-14')` | `50` |
| `QUARTER(date)` | `QUARTER('2025-12-14')` | `4` |

## 4. Date Arithmetic
**Adding/Subtracting Intervals**
```sql
SELECT DATE_ADD('2025-12-14', INTERVAL 1 DAY);   -- '2025-12-15'
SELECT DATE_SUB('2025-12-14', INTERVAL 1 MONTH); -- '2025-11-14'
SELECT DATE_ADD('2025-12-14', INTERVAL -1 YEAR); -- '2024-12-14'
```

**Difference Between Dates**
`DATEDIFF(date1, date2)` returns `days`.
```sql
-- Returns 1 (date1 - date2)
SELECT DATEDIFF('2025-12-15', '2025-12-14'); 

-- Returns -1
SELECT DATEDIFF('2025-12-14', '2025-12-15');
```

## 5. String to Date (`STR_TO_DATE`)
Converts a string into a proper valid date object.
**Syntax**: `STR_TO_DATE(string, format)`

```sql
-- Converts raw string '14,12,2025' to Date object
SELECT STR_TO_DATE('14,12,2025', '%d,%m,%Y'); -- '2025-12-14'
```

## 6. Timestamp Handling
If you are dealing with slightly more precise times or timezone conversions.
```sql
SELECT TIMESTAMPDIFF(SECOND, '2025-12-14 12:00:00', '2025-12-14 12:00:10'); -- 10
SELECT TIMESTAMPDIFF(MONTH, '2025-01-01', '2025-03-01'); -- 2
```

---

### Practice Example (MySQL Syntax)
Top Sales for the **Last 30 Days**:
```sql
SELECT * 
FROM orders 
WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);
```
