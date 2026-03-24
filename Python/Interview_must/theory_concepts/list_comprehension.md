# 🔷 List Comprehension — Complete Interview Reference

> **Who this is for:** Data scientist / analyst preparing for Python interviews (Pandas, data manipulation, FAANG-style).  
> **Goal:** Understand the *why*, *how*, and *when* — not just the syntax.

---

## 1. What Is It?

A **list comprehension** is a concise, Pythonic way to create a new list by applying an expression to each item in an iterable — optionally filtering with a condition.

It replaces the pattern of:
1. create an empty list
2. loop and `.append()`

with a **single, readable line**.

---

## 2. Core Syntax

```python
[expression  for  item  in  iterable  if  condition]
#  ───────── ┬──  ────── ──  ────────  ──  ─────────
#  "what     │    loop         source      optional
#  to keep"  └─── variable               filter
```

| Part         | Required? | Purpose                          |
|--------------|-----------|----------------------------------|
| `expression` | ✅ Yes    | What goes into the new list      |
| `for item in iterable` | ✅ Yes | Iterates over source  |
| `if condition` | ❌ No  | Filter — keeps item only if True |

---

## 3. Equivalent `for`-loop → comprehension

```python
# Traditional approach
result = []
for x in range(10):
    if x % 2 == 0:
        result.append(x ** 2)

# List comprehension equivalent
result = [x**2 for x in range(10) if x % 2 == 0]
# → [0, 4, 16, 36, 64]
```

---

## 4. Anatomy of Every Pattern

### 4.1 Simple Transformation (no filter)
```python
names = ['alice', 'bob', 'carol']
upper = [n.upper() for n in names]
# → ['ALICE', 'BOB', 'CAROL']
```

### 4.2 Filter Only (no transformation)
```python
scores = [45, 82, 60, 93, 55]
passing = [s for s in scores if s >= 60]
# → [82, 60, 93]
```

### 4.3 Transform + Filter
```python
words = ['hello', 'world', 'hi', 'python']
long_upper = [w.upper() for w in words if len(w) > 3]
# → ['HELLO', 'WORLD', 'PYTHON']
```

### 4.4 `if-else` inside the expression (not the filter)

> ⚠️ Key gotcha: `if-else` in the **expression** vs `if` at the **end** are different.

```python
# if-else in EXPRESSION (no filtering — every item gets a value)
result = ['even' if x % 2 == 0 else 'odd' for x in range(5)]
# → ['even', 'odd', 'even', 'odd', 'even']

# if at END (filtering — only keeps matching items)
result = [x for x in range(5) if x % 2 == 0]
# → [0, 2, 4]
```

---

## 5. Nested List Comprehensions

### 5.1 Flattening a 2D list (very common in interviews)
```python
matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
flat = [val for row in matrix for val in row]
# → [1, 2, 3, 4, 5, 6, 7, 8, 9]

# Read as: "for each row in matrix, for each val in row → take val"
# Outer loop comes FIRST, inner loop comes SECOND
```

### 5.2 Transpose a matrix
```python
matrix = [[1, 2, 3], [4, 5, 6]]
transposed = [[row[i] for row in matrix] for i in range(3)]
# → [[1, 4], [2, 5], [3, 6]]
```

### 5.3 Cartesian product (all pairs)
```python
colors = ['red', 'blue']
sizes  = ['S', 'M', 'L']
combos = [(c, s) for c in colors for s in sizes]
# → [('red','S'),('red','M'),('red','L'),('blue','S'),('blue','M'),('blue','L')]
```

---

## 6. Data Science / Pandas-Relevant Patterns

These come up constantly when working with DataFrames.

### 6.1 Dynamic column selection (your recent use case!)
```python
# Select all columns that end with '_hc' — no hardcoding
quarters = [c for c in df.columns if c.endswith('_hc')]

# Select all numeric columns
num_cols = [c for c in df.columns if df[c].dtype in ['int64', 'float64']]

# Select columns containing a keyword
rev_cols = [c for c in df.columns if 'revenue' in c.lower()]
```

### 6.2 Building a list of DataFrames (batch processing)
```python
import pandas as pd

files = ['jan.csv', 'feb.csv', 'mar.csv']
dfs   = [pd.read_csv(f) for f in files]
combined = pd.concat(dfs, ignore_index=True)
```

### 6.3 Generate column rename maps
```python
# Rename all cols: strip whitespace and lowercase
rename_map = {c: c.strip().lower().replace(' ', '_') for c in df.columns}
df.rename(columns=rename_map, inplace=True)
```
> Note: This uses a **dict comprehension** (same concept, outputs `{}`).

### 6.4 Flag-based filtering
```python
bad_cols   = [c for c in df.columns if df[c].isna().sum() > df.shape[0] * 0.5]
df_cleaned = df.drop(columns=bad_cols)
```

### 6.5 Extract unique values across columns
```python
all_depts = list({dept for col in ['dept_a', 'dept_b'] for dept in df[col].dropna()})
```
> Uses a **set comprehension** `{}` — automatically deduplicates.

---

## 7. Related Comprehension Types

| Type   | Syntax                            | Output  |
|--------|-----------------------------------|---------|
| List   | `[expr for x in it]`             | `list`  |
| Set    | `{expr for x in it}`             | `set` (no duplicates, unordered) |
| Dict   | `{k: v for x in it}`             | `dict`  |
| Generator | `(expr for x in it)`          | lazy `generator` (memory efficient) |

```python
# Set comprehension — unique domains from emails
emails  = ['a@gmail.com', 'b@yahoo.com', 'c@gmail.com']
domains = {e.split('@')[1] for e in emails}  # {'gmail.com', 'yahoo.com'}

# Dict comprehension — square lookup table
squares = {x: x**2 for x in range(1, 6)}  # {1:1, 2:4, 3:9, 4:16, 5:25}

# Generator — sum without building full list in memory
total = sum(x**2 for x in range(1_000_000))
```

---

## 8. Performance

| Method                | Speed      | Memory     | Use when...                        |
|-----------------------|------------|------------|------------------------------------|
| List comprehension    | ✅ Faster   | Stores all | You need indexable list, <1M items |
| `for` loop + append   | ❌ Slower   | Stores all | Multi-step logic, readability first|
| Generator expression  | ✅ Faster   | ✅ Minimal  | One-pass iteration (sum, any, all) |
| `map()` / `filter()`  | Similar    | Lazy        | Functional style; less readable    |

**Why is list comprehension faster than a `for` + `append`?**  
The bytecode for list comprehension is optimised by CPython — it uses `LIST_APPEND` internally which avoids the overhead of the `.append` attribute lookup on each iteration.

```python
import timeit

# Comprehension
timeit.timeit('[x**2 for x in range(1000)]', number=10000)   # ~0.5s

# for-loop append
timeit.timeit('''
r=[]
for x in range(1000): r.append(x**2)
''', number=10000)  # ~0.8s
```

---

## 9. When NOT to Use List Comprehensions

| Situation                                              | Better Alternative               |
|--------------------------------------------------------|----------------------------------|
| Multi-step logic (>2 operations per item)             | Regular `for` loop               |
| Nested 3+ levels deep                                 | Regular `for` loop (readability) |
| You only need one-pass iteration (sum, any, all, max) | Generator expression             |
| Side effects (printing, writing to file)              | Regular `for` loop               |
| Very large sequences (>millions of items)             | Generator or `itertools`         |

---

## 10. Common Interview Questions & Pitfalls

### Q1: What does this output?
```python
result = [x * y for x in [1, 2, 3] for y in [10, 20]]
# → [10, 20, 20, 40, 30, 60]
# Outer loop (x) runs first, inner loop (y) is fully exhausted each time
```

### Q2: What's the difference between these two?
```python
a = [x if x > 0 else 0 for x in [-1, 2, -3, 4]]  # → [0, 2, 0, 4] (replace negatives)
b = [x for x in [-1, 2, -3, 4] if x > 0]          # → [2, 4] (remove negatives)
```
> **Rule:** `if-else` in the **expression** = no filtering, every element stays.  
> `if` at the **end** = filtering, only matching elements survive.

### Q3: Pitfall — variable leakage (Python 2 only)
```python
# In Python 3: loop variable is scoped to the comprehension ✅
x = 100
result = [x for x in range(5)]
print(x)  # → 100  (outer x unchanged in Python 3)
```

### Q4: Pitfall — mutable default in nested lists
```python
# WRONG: all rows point to the SAME list object
matrix = [[0] * 3] * 3
matrix[0][0] = 9
# → [[9,0,0],[9,0,0],[9,0,0]] ← all rows changed!

# CORRECT: use comprehension to create independent rows
matrix = [[0] * 3 for _ in range(3)]
matrix[0][0] = 9
# → [[9,0,0],[0,0,0],[0,0,0]] ✅
```

### Q5: `_` as a throwaway variable
```python
# When you don't need the loop variable
zeros = [0 for _ in range(5)]  # → [0, 0, 0, 0, 0]
```

---

## 11. Quick-Reference Cheat Sheet

```python
# ── Basic ──────────────────────────────────────────────────────
[expr for x in iterable]
[expr for x in iterable if cond]
[expr_if_true if cond else expr_if_false for x in iterable]

# ── Nested (flat) ──────────────────────────────────────────────
[expr for outer in it1 for inner in it2]          # outer first!

# ── Related types ──────────────────────────────────────────────
{expr for x in iterable}                          # set
{k: v for x in iterable}                          # dict
(expr for x in iterable)                          # generator

# ── Data science shortcuts ─────────────────────────────────────
[c for c in df.columns if c.endswith('_suffix')]  # dynamic col select
[pd.read_csv(f) for f in file_list]               # batch load
{c: c.lower() for c in df.columns}                # rename map
[x for x in series if pd.notna(x)]               # drop NaN
```

---

## 12. Mental Model: "Read it left to right, like English"

```
[  x**2        for x in range(10)    if x % 2 == 0  ]
   ─────          ─────────────────     ─────────────
"give me x²   for every x in 0-9    only if x is even"
```

This left-to-right reading is the key to writing *and* understanding nested comprehensions without confusion.
