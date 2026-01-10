import sqlite3

# Connect to database
conn = sqlite3.connect('practice.db')
c = conn.cursor()

# Create table
c.execute('DROP TABLE IF EXISTS company_users')
c.execute('''
CREATE TABLE company_users (
    company_id INTEGER,
    user_id INTEGER,
    language TEXT
)
''')

# Insert data from image
data = [
    (1, 1, 'English'),
    (1, 1, 'German'),
    (1, 2, 'English'),
    (1, 3, 'German'),
    (1, 3, 'English'),
    (1, 4, 'English'),
    (2, 5, 'English'),
    (2, 5, 'German'),
    (2, 5, 'Spanish'),
    (2, 6, 'German'),
    (2, 6, 'Spanish'),
    (2, 7, 'English')
]

c.executemany('INSERT INTO company_users VALUES (?,?,?)', data)
conn.commit()

print("Company Users Dataset Created Successfully.")
print("-" * 30)

# Common Interview Question: "Find companies where at least 2 users speak English"
# OR "Find companies where ALL users speak English" (This is a more interesting logic)

print("Query: Companies where ALL users speak English")
# Logic: 
# 1. Get total users per company.
# 2. Get count of users who speak English per company.
# 3. If numbers match (and total > 0), then all users speak English.

query = """
WITH company_stats AS (
    SELECT 
        company_id,user_id,
        max(case when language = 'English' then 1 else 0 end) as eng_speaker,
        max(case when language = 'German' then 1 else 0 end) as ger_speaker
    FROM company_users
    GROUP BY 1,2
)
SELECT DISTINCT company_id
FROM company_stats
WHERE eng_speaker = 1 AND ger_speaker = 1

"""

c.execute(query)

# Display results
columns = [description[0] for description in c.description]
print(columns)
for row in c.fetchall():
    print(row)

conn.close()
