# Processing Large CSV Files (100GB+)

This document outlines the standard methodologies and best practices for addressing the classic data engineering and data science interview question: _"How do you process a CSV file that is too large to fit into RAM?"_

---

## 1. Chunking with Pandas (`read_csv(chunksize=...)`)

- **The Concept:** Instead of loading the entire 100GB file into memory at once, you read the file in smaller, manageable "chunks" (e.g., 100,000 rows at a time).
- **How it Works:** The `chunksize` parameter in `pd.read_csv()` returns an iterator. You iterate over these chunks, process/clean the data in memory for just that chunk, and then typically write the cleaned data to a new file or insert it into a database before the garbage collector frees the memory for the next chunk.
- **Best For:** Row-by-row cleaning, simple aggregations (keeping a running tally), and ETL pipelines where data is moved into a relational database.

### Example Implementation:

```python
import pandas as pd

chunk_size = 100_000
# Iterate through the massive CSV in chunks
for chunk in pd.read_csv("massive_data.csv", chunksize=chunk_size):
    # 1. Clean the chunk (e.g., drop nulls, format dates)
    cleaned_chunk = chunk.dropna(subset=['important_column'])

    # 2. Append the cleaned chunk to a new file (or database)
    cleaned_chunk.to_csv("cleaned_data.csv", mode='a', header=False, index=False)
```

---

## 2. Using Distributed Frameworks (Dask or PySpark)

- **The Concept:** Transition from single-node, in-memory processing (Pandas) to distributed, out-of-core processing engines.
- **How it Works (Dask):** Dask provides a Pandas-like API but operates lazily. A Dask DataFrame is composed of many smaller Pandas DataFrames partitioned along the index. It coordinates tasks to execute computations on data that doesn't fit in memory, utilizing your disk and multiple CPU cores.
- **How it Works (PySpark):** PySpark is the Python API for Apache Spark, the industry standard for big data processing. It distributes data across a cluster of machines.
- **Best For:** Complex aggregations, group-bys, joins across massive datasets, and scenarios where execution time is as important as memory constraints.

### Example Implementation (Dask):

```python
import dask.dataframe as dd

# Reads metadata only, lazily loads the data
df = dd.read_csv("massive_data.csv")

# Computations are built into a task graph
cleaned_df = df.dropna(subset=['important_column'])
grouped_df = cleaned_df.groupby('category').sum()

# The .compute() method triggers the execution
result = grouped_df.compute()
```

---

## 3. High-Performance Out-of-Core Libraries (Polars / DuckDB)

- **The Concept:** Utilizing modern data processing engines built on Rust or C++ that natively handle out-of-core processing and streaming without the overhead of JVMs (like Spark) or complex cluster setups.
- **How it Works (Polars):** Polars has a `scan_csv()` function that enables "Lazy" execution. Its query engine optimizes the query plan and natively streams data from disk, utilizing all available CPU cores.
- **How it Works (DuckDB):** DuckDB is an in-process SQL OLAP database environment. You can query a raw CSV file directly using standard SQL. DuckDB's execution engine streams the data from disk effortlessly.
- **Best For:** Blistering fast analytics on a single robust machine without the complexity of Spark.

### Example Implementation (Polars Lazy API):

```python
import polars as pl

# scan_csv tells Polars to execute lazily (streaming from disk)
q = (
    pl.scan_csv("massive_data.csv")
    .filter(pl.col("important_column").is_not_null())
    .group_by("category")
    .agg(pl.col("sales").sum())
)

# .collect() executes the query plan
result = q.collect(streaming=True)
```

---

## 4. Standard Python Library (`csv` module)

- **The Concept:** Reverting to Python's built-in, lightweight I/O operations without loading analytical libraries.
- **How it Works:** The `csv` module reads a file line-by-line via a generator. At any given moment, only one line of the file resides in RAM.
- **Best For:** Extremely simple filtering or counting tasks where importing Pandas or Polars is overkill.

### Example Implementation:

```python
import csv

with open('massive_data.csv', 'r') as infile, open('cleaned_data.csv', 'w') as outfile:
    reader = csv.reader(infile)
    writer = csv.writer(outfile)

    headers = next(reader)
    writer.writerow(headers)

    for row in reader:
        # Example condition: keep row if column 2 is not empty
        if row[2] != '':
            writer.writerow(row)
```

---

## Interview Summary Checklist

If asked this in an interview, structure your response as follows:

1. **Start Simple:** Mention **Pandas `chunksize`** for straightforward ETL or Python's built-in **`csv` module** for basic line-by-line filtering.
2. **Push for Modern Tooling:** Introduce **Polars (Lazy execution)** or **DuckDB** as the optimal modern solution for single-machine out-of-core analytics.
3. **Scale Out:** If the dataset is expected to grow from 100GB to 10TB, advise that the architecture should transition to a distributed framework like **PySpark** running on a cluster.
