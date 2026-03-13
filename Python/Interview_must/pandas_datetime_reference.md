# Pandas Datetime Functions — Interview Reference

> Covers every datetime pattern used in this `Interview_must` folder.
> Think of this as the Python equivalent of SQL's `DATE_ADD / DATE_FORMAT / DATEDIFF`.

---

## 1. Creating Datetimes

### `pd.to_datetime(value)`

Convert strings, lists, or columns to datetime.

```python
pd.to_datetime('2021-01-01')                    # single string
pd.to_datetime(['2021-01-01', '2021-02-01'])    # list → DatetimeIndex
df['date'] = pd.to_datetime(df['date_str'])     # column in-place
```

### `pd.date_range(start, end/periods)`

Generate a sequence of dates.

```python
pd.date_range('2021-01-01', periods=7)                     # 7 days from Jan 1
pd.date_range(start='2021-01-01', end='2021-01-31')        # Jan 1 → Jan 31
pd.date_range(start='2024-01-01', end='2024-01-08', inclusive='left')  # exclude end
```

### `pd.Timedelta(n, unit)` / `pd.to_timedelta(series, unit)`

Create a duration to add/subtract.

```python
pd.Timedelta(days=5)                              # fixed duration
pd.to_timedelta(df['rank'], unit='D')             # from a numeric column (used in streak trick)
```

---

## 2. Arithmetic — Add / Subtract Dates

| Operation               | Code                                                 | SQL Equivalent                   |
| ----------------------- | ---------------------------------------------------- | -------------------------------- |
| Subtract two datetimes  | `df['end'] - df['start']` → timedelta                | `DATEDIFF`                       |
| Add N days              | `df['date'] + pd.Timedelta(days=N)`                  | `DATE_ADD(date, INTERVAL N DAY)` |
| Subtract N days         | `df['date'] - pd.Timedelta(days=N)`                  | `DATE_SUB(date, INTERVAL N DAY)` |
| Subtract date from rank | `df['date'] - pd.to_timedelta(df['rank'], unit='D')` | — (streak trick)                 |

```python
# Duration in minutes (used in ride duration question)
df['duration_min'] = (df['ended_at'] - df['started_at']).dt.total_seconds() / 60

# Streak key: date - cumcount rank → same anchor for consecutive days
df['streak_key'] = df['login_date'] - pd.to_timedelta(df['rank'], unit='D')
```

---

## 3. Extracting Date Components (`.dt` accessor)

| Component           | Code                         | Example Output              |
| ------------------- | ---------------------------- | --------------------------- |
| Date only (no time) | `df['dt'].dt.date`           | `datetime.date(2021, 1, 1)` |
| Year                | `df['dt'].dt.year`           | `2021`                      |
| Month number        | `df['dt'].dt.month`          | `1`                         |
| Day of month        | `df['dt'].dt.day`            | `15`                        |
| Day of week         | `df['dt'].dt.dayofweek`      | `0`=Mon … `6`=Sun           |
| Day name            | `df['dt'].dt.day_name()`     | `'Monday'`                  |
| Hour                | `df['dt'].dt.hour`           | `8`                         |
| Convert to Period   | `df['dt'].dt.to_period('M')` | `Period('2021-01', 'M')`    |

```python
# Filter weekdays (Mon–Fri = dayofweek 0–4)
weekdays = all_days[all_days.dayofweek < 5]

# Extract year-month for groupby
df['month'] = df['created_at'].dt.to_period('M')   # used in MoM question
```

---

## 4. Duration Extraction (from Timedelta)

```python
td = df['ended_at'] - df['started_at']   # timedelta Series

td.dt.total_seconds()   # → float of total seconds  ← most useful
td.dt.days              # → int of whole days only
td.dt.seconds           # → seconds within the day (not total!)
td.dt.components        # → DataFrame: days, hours, minutes, seconds
```

> ⚠️ **`dt.seconds` ≠ `dt.total_seconds()`**  
> A 2-day 1-hour timedelta: `.dt.seconds = 3600` (just the sub-day part), `.dt.total_seconds() = 176400`.

---

## 5. Filtering by Date Range

### `.between(start, end)` — inclusive on both ends

```python
# Used in rolling date window filter question
df[df['created_at'].between('2020-01-01', '2020-01-05')]
```

### Direct comparison

```python
df[df['date'] >= '2021-01-01']
df[df['date'] < pd.Timestamp('2021-02-01')]

# Overlap check (used in subscription overlap question)
df['end_date'] > df['next_start_date']   # True = overlap
```

---

## 6. Forward Fill / Backward Fill (Time-Series Gaps)

```python
# Fill NaN with previous known value — MUST use groupby version
df['revenue'] = df.groupby('client_id')['revenue'].ffill()   # forward fill
df['revenue'] = df.groupby('client_id')['revenue'].bfill()   # backward fill

# ❌ Don't use global ffill — it bleeds values across groups
df['revenue'].fillna(method='ffill')   # WRONG for grouped data
```

````

| Method   | When to use                                          |
| -------- | ---------------------------------------------------- |
| `linear` | Dates are evenly spaced                              |
| `time`   | Dates have irregular gaps (e.g., some days missing)  |
| `ffill`  | You want to carry the last known value, not estimate |

---

## 8. Period & Resampling

```python
# Convert to monthly period (for MoM groupby)
df['month'] = df['date'].dt.to_period('M')   # '2021-01', '2021-02', ...

# Resample — aggregate a time-series by frequency
df.set_index('date').resample('M')['revenue'].sum()    # monthly totals
df.set_index('date').resample('W')['sales'].mean()     # weekly average
````

| Alias  | Frequency   |
| ------ | ----------- |
| `'D'`  | Daily       |
| `'W'`  | Weekly      |
| `'M'`  | Month end   |
| `'MS'` | Month start |
| `'Q'`  | Quarter end |
| `'Y'`  | Year end    |

---

## 9. Business Days

```python
import numpy as np


# Generate business dates
pd.bdate_range('2024-01-01', '2024-01-08', inclusive='left')

# Manual: filter weekdays from a full date_range
all_days = pd.date_range('2024-01-01', '2024-01-08', inclusive='left')
bdays = all_days[all_days.dayofweek < 5]
```

---

## 10. Shift — Lead / Lag

```python
# Lag: previous row's value per group (SQL LAG())
df['prev_start'] = df.groupby('user_id')['start_date'].shift(1)

# Lead: next row's value per group (SQL LEAD())
df['next_start'] = df.groupby('user_id')['start_date'].shift(-1)
```

---

## Quick Syntax Cheatsheet

| Goal                       | Code                                                                  |
| -------------------------- | --------------------------------------------------------------------- |
| String → datetime          | `pd.to_datetime('2021-01-01')`                                        |
| Date difference in days    | `(end - start).dt.days`                                               |
| Date difference in minutes | `(end - start).dt.total_seconds() / 60`                               |
| Add N days                 | `date + pd.Timedelta(days=N)`                                         |
| Extract month              | `df['date'].dt.month`                                                 |
| Group by month             | `df['date'].dt.to_period('M')`                                        |
| Filter date range          | `df['date'].between('2021-01-01', '2021-03-31')`                      |
| Business day count         | `np.busday_count(start, end)`                                         |
| Forward fill per group     | `df.groupby('id')['col'].ffill()`                                     |
| Next row's date per group  | `df.groupby('id')['date'].shift(-1)`                                  |
| Consecutive streak key     | `df['date'] - pd.to_timedelta(df.groupby('id').cumcount(), unit='D')` |
