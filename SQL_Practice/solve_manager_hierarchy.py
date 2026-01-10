import sqlite3


# Connect to database (or create if not exists)
conn = sqlite3.connect('practice.db')
c = conn.cursor()

# Create table
c.execute('DROP TABLE IF EXISTS employees')
c.execute('''
CREATE TABLE employees (
    emp_id INTEGER PRIMARY KEY,
    emp_name TEXT,
    manager_id INTEGER
)
''')

# Insert data
data = [
    (1, 'Ankit', 4),
    (2, 'Mohit', 5),
    (3, 'Vikas', 4),
    (4, 'Rohit', 2),
    (5, 'Mudit', 6),
    (6, 'Agam', 2),
    (7, 'Sanjay', 2),
    (8, 'Ashish', 2),
    (9, 'Mukesh', 6),
    (10, 'Rakesh', 6)
]

c.executemany('INSERT INTO employees VALUES (?,?,?)', data)
conn.commit()

print("Dataset Created Successfully.")
print("-" * 30)

# Example Query to verify
query = """
SELECT employees.emp_id, employees.emp_name, manager.emp_name AS manager_name , manager2.emp_name AS Senior_Manager
FROM employees
LEFT JOIN employees AS manager ON employees.manager_id = manager.emp_id
LEFT JOIN employees AS manager2 ON manager.manager_id = manager2.emp_id
"""

c.execute(query)
results = c.fetchall()

# Display results
columns = [description[0] for description in c.description]
print(columns)
for row in results:
    print(row)

conn.close()
