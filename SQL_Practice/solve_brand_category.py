import sqlite3

# Connect to database
conn = sqlite3.connect('practice.db')
c = conn.cursor()

# Create table
c.execute('DROP TABLE IF EXISTS brands')
c.execute('''
CREATE TABLE brands (
    category TEXT,
    brand_name TEXT
)
''')

# Insert data from image
data = [
    ('chocolates', '5-star'),
    (None, 'dairy milk'),
    (None, 'perk'),
    (None, 'eclair'),
    ('Biscuits', 'britannia'),
    (None, 'good day'),
    (None, 'boost')
]

c.executemany('INSERT INTO brands VALUES (?,?)', data)
conn.commit()

print("Brand Dataset Created Successfully.")
print("-" * 30)

# Verify
# Forward Fill Solution
# 1. Create a grouping ID: count(category) increments only when a category is present.
# 2. Use that group ID to spread the max(category) to all members of the group.
query = """
WITH grouped AS (
    SELECT 
        rowid, 
        brand_name, 
        category,
        COUNT(category) OVER (ORDER BY rowid) as grp
    FROM brands
)
SELECT 
    category as original_category,
    brand_name,
    MAX(category) OVER (PARTITION BY grp) as filled_category
FROM grouped
ORDER BY rowid
"""
c.execute(query)

# Display results
columns = [description[0] for description in c.description]
print(columns)
for row in c.fetchall():
    print(row)

conn.close()
