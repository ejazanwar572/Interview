# Python Built-in Methods — Interview Cheatsheet

## Dict Methods

### `.get(key, default)`

Returns value for `key`, or `default` if key doesn't exist. **Never raises KeyError.**

```python
d = {"a": 1}
d.get("a")        # 1
d.get("z")        # None
d.get("z", 0)     # 0   ← safe fallback
```

**Interview use:** Frequency counting without `KeyError`

```python
freq = {}
for ch in "banana":
    freq[ch] = freq.get(ch, 0) + 1
# {'b':1, 'a':3, 'n':2}
```

---

### `.items()`

Returns key-value pairs as `(k, v)` tuples — ideal for looping.

```python
d = {"a": 1, "b": 2}
for k, v in d.items():
    print(k, v)     # a 1 / b 2
```

**Interview use:** Filter dict entries by value

```python
dups = [k for k, v in freq.items() if v > 1]
```

---

### `.keys()` / `.values()`

```python
d = {"a": 1, "b": 2}
list(d.keys())    # ['a', 'b']
list(d.values())  # [1, 2]

"a" in d.keys()   # True  (same as: "a" in d)
2 in d.values()   # True
```

**Interview use:** Grouping / building adjacency lists

---

## List Methods

### `.append(x)` vs `.extend(iterable)`

```python
a = [1, 2]
a.append([3, 4])   # [1, 2, [3, 4]]  ← adds as single element
a.extend([3, 4])   # [1, 2, 3, 4]    ← unpacks iterable
```

### `.pop(index=-1)`

Removes **and returns** element at index (default: last).

```python
a = [1, 2, 3]
a.pop()     # returns 3, a = [1, 2]
a.pop(0)    # returns 1, a = [2]
```

### `.sort()` vs `sorted()`

```python
a = [3, 1, 2]
a.sort()            # in-place, returns None
b = sorted(a)       # returns new list, a unchanged

# Custom key
a.sort(key=lambda x: -x)          # descending
sorted(words, key=lambda w: len(w))  # by length
```

### `.count(x)` / `.index(x)`

```python
a = [1, 2, 2, 3]
a.count(2)    # 2
a.index(2)    # 1 (first occurrence)
```

---

## Set Methods

| Method         | What it does                 |
| -------------- | ---------------------------- |
| `s.add(x)`     | Add element                  |
| `s.discard(x)` | Remove (no error if missing) |
| `s1 & s2`      | Intersection                 |
| `s1 \| s2`     | Union                        |
| `s1 - s2`      | Difference                   |
| `s1 ^ s2`      | Symmetric difference         |

**Interview use:** O(1) membership check, deduplication

```python
seen = set()
if x in seen:   # O(1)
    ...
seen.add(x)

uniq = list(set([1, 2, 2, 3]))  # [1, 2, 3]
```

---

## String Methods

### `.split(sep)` / `' '.join(iterable)`

```python
"a,b,c".split(",")       # ['a', 'b', 'c']
",".join(["a","b","c"])  # 'a,b,c'
```

### `.strip()` / `.lower()` / `.upper()`

```python
"  hello  ".strip()   # 'hello'
"Hello".lower()       # 'hello'
```

### `in` membership

```python
"ell" in "hello"   # True
```

---

## List Tricks & Element-wise Operations

### List repetition with `*`

Repeats the entire list `n` times — creates a **new** list.

```python
a = [1, 2, 3]
a * 3   # [1, 2, 3, 1, 2, 3, 1, 2, 3]
```

> ⚠️ Don't use `[[]] * n` for 2D lists — all rows share the same reference!

---

### Multiply every element — loop vs list comprehension

**Loop approach (beginner-friendly):**

```python
list_1 = [1, 2, 3]
list_2 = []
for i in list_1:
    list_2.append(i * 3)
# [3, 6, 9]
```

**List comprehension (Pythonic, preferred in interviews):**

```python
list_2 = [i * 3 for i in list_1]
# [3, 6, 9]
```

**With a condition (filter + transform):**

```python
evens_doubled = [i * 2 for i in list_1 if i % 2 == 0]
# [4]
```

---

### `enumerate()` — loop with index

```python
for i, val in enumerate(["a", "b", "c"]):
    print(i, val)   # 0 a / 1 b / 2 c
```

---

### `zip()` — loop two lists together

```python
names  = ["Alice", "Bob"]
scores = [90, 85]
for name, score in zip(names, scores):
    print(name, score)   # Alice 90 / Bob 85
```

---

## Quick Complexity Reference

| Operation     | List       | Set      | Dict     |
| ------------- | ---------- | -------- | -------- |
| Lookup `x in` | O(n)       | **O(1)** | **O(1)** |
| Append/Add    | O(1)       | O(1)     | O(1)     |
| Delete        | O(n)       | O(1)     | O(1)     |
| Sort          | O(n log n) | —        | —        |
