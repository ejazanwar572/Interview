# Pandas `iloc` Guide: Integer Location Indexing

The `iloc` indexer in Pandas stands for **"integer location"** and is used to select rows and columns by their **0-based positional index**.

Unlike `loc` (which uses labels/names), `iloc` strictly uses numbers. Here is a definitive guide to every way you can use `iloc`:

---

### 1. Selecting a Single Row

Returns a Pandas `Series` representing that specific row.

```python
# Get the first row (index 0)
df.iloc[0]

# Get the last row
df.iloc[-1]
```

### 2. Selecting Multiple Rows (Slicing)

Returns a Pandas `DataFrame`. The syntax is `[start:stop]`. Note that `stop` is **exclusive** (it does not include the stop index).

```python
# Get rows 0, 1, and 2 (excludes row 3)
df.iloc[0:3]

# Get the first 5 rows (same as df.head(5))
df.iloc[:5]

# Get all rows starting from row 10 to the end
df.iloc[10:]
```

### 3. Selecting Specific, Non-Contiguous Rows

Pass a list of integers to select specific rows that aren't next to each other.

```python
# Get rows at index 0, 3, and 7
df.iloc[[0, 3, 7]]
```

### 4. Selecting Specific Rows AND Specific Columns

The general syntax is `df.iloc[row_selector, column_selector]`.

```python
# Get the 1st row (0) and 2nd column (1) -> returns a single scalar value
df.iloc[0, 1]

# Get the first 3 rows, and the first 2 columns
df.iloc[0:3, 0:2]

# Get specific rows (0, 5) and specific columns (1, 3)
df.iloc[[0, 5], [1, 3]]
```

### 5. Selecting All Rows, but Specific Columns

You use the colon `:` by itself string to mean "everything".

```python
# Get all rows, but only the 3rd column (index 2)
df.iloc[:, 2]

# Get all rows, but only the last two columns
df.iloc[:, -2:]
```

### 6. Using a Step (Skipping Rows/Columns)

The full slicing syntax is `[start:stop:step]`.

```python
# Get every 2nd row (index 0, 2, 4, 6, ...)
df.iloc[::2]

# Reverse the entire dataframe vertically
df.iloc[::-1]

# Reverse the rows AND the columns
df.iloc[::-1, ::-1]
```

### 7. Boolean Masking with `iloc` (Advanced & Rare)

You _cannot_ directly pass a Pandas Series boolean mask (like `df['age'] > 30`) into `.iloc` because `.iloc` strictly expects position-based inputs (NumPy boolean arrays or lists work, but Series index alignments cause errors). If you try, you'll get a `NotImplementedError` or `ValueError`.

If you absolutely must filter with logic but extract columns by position, you convert the mask to a NumPy array by calling `.values`:

```python
# Extract the first 3 columns for users older than 30
df.iloc[(df['age'] > 30).values, 0:3]
```

_(Note: Practically, it's safer and more idiomatic to use `.loc` for pure logic masking)._

---

### Key Takeaway Rule of Thumb

- If your logic involves names, strings, or explicit indices (`df.loc['row_name', 'col_name']`), use **`loc`**.
- If your logic is strictly positional ("I want the 5th item from the top" or "I want the last 3 columns"), use **`iloc`**.
