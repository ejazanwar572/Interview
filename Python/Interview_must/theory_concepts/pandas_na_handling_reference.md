# Handling NAs in Pandas — Interview Reference

> **Interview focus only** — the patterns that appear in 90% of DS interview questions.

---

## ℹ️ Extra Context (Read Once, Not for Memorisation)

- In pandas, a missing value is stored as `NaN` (float) for numeric columns, `NaT` for datetime, and `None`/`pd.NA` for object/nullable types.
- **`NaN != NaN`** — this is why `x == NaN` never works; you must use `isna()`.
- `pd.NA` is the newer nullable type (pandas 1.0+); `np.nan` is the older float sentinel. They behave similarly for most interview questions.
- Operations on `NaN` propagate: `NaN + 5 = NaN`, `NaN > 0 = False`. Both matter in aggregations and boolean filters.

---

## 1. Detecting NAs

```python
df.isna()           # DataFrame of True/False per cell
df.isnull()         # identical to isna() — both work

df['col'].isna()    # boolean Series for one column
df['col'].notna()   # inverse — True where NOT null

# Count NAs per column
df.isna().sum()

# Rows with ANY null
df[df.isna().any(axis=1)]

# Check if a single value is NA (never use == NaN)
pd.isna(x)    # ✅
x == np.nan   # ❌ always False
```

---

## 2. Dropping NAs

```python
df.dropna()                        # drop rows with ANY null
df.dropna(subset=['col1','col2'])  # only if null in these columns ← most useful
df.dropna(thresh=2)                # keep rows with at least 2 non-null values
df.dropna(axis=1)                  # drop columns with any null
```

> **Interview tip:** Always specify `subset=` — dropping all rows with any null is usually wrong.

---

## 3. Filling NAs

### Constant fill

```python
df['col'].fillna(0)            # fill with a fixed value
df['col'].fillna('Unknown')    # for string columns
df.fillna({'col1': 0, 'col2': 'N/A'})   # different fill per column
```

### Statistical fill

```python
df['col'].fillna(df['col'].mean())     # global mean
df['col'].fillna(df['col'].median())   # global median — better for skewed data
df['col'].fillna(df['col'].mode()[0])  # mode (most frequent)
```

### Group-aware fill ← most asked in interviews

```python
# Fill with the median of each group (not the global median)
group_median = df.groupby('category')['price'].transform('median')
df['price'] = df['price'].fillna(group_median)
```

### Forward / Backward fill (time-series)

```python
df['col'].ffill()   # carry forward last known value
df['col'].bfill()   # fill from the next known value

# ⚠️ Always use groupby version for grouped data
df['col'] = df.groupby('user_id')['col'].ffill()
```

---

## 4. Replacing Values (not just NAs)

```python
df['col'].replace(0, np.nan)               # replace 0 with NaN
df['col'].replace({'Yes': 1, 'No': 0})     # multiple replacements via dict
df.replace(-999, np.nan)                   # across entire DataFrame
```

> **`replace` vs `fillna`:**
>
> - `fillna` only targets `NaN` cells
> - `replace` targets any specific value (e.g., sentinels like -999, "N/A" strings)

---

## 5. Interpolation

```python
df['col'].interpolate(method='linear')   # estimate midpoint between neighbours
df['col'].interpolate(method='time')     # proportional to actual time gaps
df['col'].interpolate(limit=1)           # fill at most 1 consecutive NaN
```

Use over `ffill` when the data is a smooth signal (temperatures, prices) and you want to estimate rather than repeat.

---

## 6. Checking After Fill

```python
df.isna().sum()          # verify no NAs remain
assert df.notna().all().all()   # raise error if any NA left
```

---

## Quick Decision Guide

| Situation                     | Method                                          |
| ----------------------------- | ----------------------------------------------- |
| Numeric, no groups            | `fillna(median())`                              |
| Numeric, with groups          | `groupby().transform('median')` then `fillna()` |
| Categorical                   | `fillna(mode()[0])` or `fillna('Unknown')`      |
| Time-series, carry last value | `groupby().ffill()`                             |
| Time-series, smooth estimate  | `interpolate(method='time')`                    |
| Sentinel values (-999, "N/A") | `replace(sentinel, np.nan)` first, then fill    |
| Remove sparse rows            | `dropna(subset=['key_col'])`                    |

---

## Common Interview Traps

```python
# ❌ Trap 1: comparing to NaN
df[df['col'] == np.nan]      # always empty — NaN != NaN
df[df['col'].isna()]         # ✅ correct

# ❌ Trap 2: global ffill across groups
df['revenue'].ffill()                          # bleeds User A's data into User B
df.groupby('user_id')['revenue'].ffill()       # ✅ correct

# ❌ Trap 3: mean vs median
df['salary'].fillna(df['salary'].mean())       # outliers skew the mean
df['salary'].fillna(df['salary'].median())     # ✅ robust to outliers

# ❌ Trap 4: mode indexing
df['col'].fillna(df['col'].mode())    # mode() returns a Series — won't align
df['col'].fillna(df['col'].mode()[0])          # ✅ take the first (most frequent)
```
