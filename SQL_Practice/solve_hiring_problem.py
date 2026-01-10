import sqlite3

# Create in-memory DB
conn = sqlite3.connect(':memory:')
c = conn.cursor()

# Create table
c.execute('''CREATE TABLE candidates (
    emp_id INTEGER PRIMARY KEY,
    experience TEXT,
    salary INTEGER
)''')

# Insert data
data = [
    (1, 'Junior', 10000),
    (2, 'Junior', 15000),
    (3, 'Junior', 4000),
    (4, 'Senior', 16000),
    (5, 'Senior', 20000),
    (6, 'Senior', 50000)
]
c.executemany('INSERT INTO candidates VALUES (?,?,?)', data)
conn.commit()

print("Dataset Created Successfully.")
print("-" * 30)

query = """
with base as 
(SELECT emp_id , experience , salary , sum(salary) over(order by salary) as running_sal
FROM candidates
WHERE 1=1
GROUP BY 1,2,3
)

, Senior_hires as 
(SELECT emp_id , experience , salary as salary
FROM base 
WHERE running_sal <= 70000
)

, Junior_hires as 
(
SELECT emp_id , experience , salary as salary
FROM base
WHERE experience = 'Junior'
AND running_sal <= (70000 - (SELECT sum(salary) from Senior_hires))
)

SELECT * from Senior_hires
UNION ALL
SELECT * from Junior_hires
"""



c.execute(query)
results = c.fetchall()
for row in results:
    print(row)

# The SQL Solution (Hire Seniors First, then Juniors)
