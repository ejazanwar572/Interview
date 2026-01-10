import sqlite3

# Connect to database
conn = sqlite3.connect('practice.db')
c = conn.cursor()

# Create table
c.execute('DROP TABLE IF EXISTS student_marks')
c.execute('''
CREATE TABLE student_marks (
    studentid INTEGER,
    studentname TEXT,
    subject TEXT,
    marks INTEGER,
    testid INTEGER,
    testdate TEXT
)
''')

# Insert data from image
data = [
    (1, 'John Deo', 'Subject2', 60, 1, '2022-01-02'),
    (2, 'Max Ruin', 'Subject3', 29, 3, '2022-01-03'),
    (2, 'Max Ruin', 'Subject1', 63, 1, '2022-01-02'),
    (2, 'Max Ruin', 'Subject2', 84, 1, '2022-01-02'),
    (3, 'Arnold', 'Subject2', 32, 1, '2022-01-02'),
    (3, 'Arnold', 'Subject1', 95, 1, '2022-01-02'),
    (4, 'Krish Star', 'Subject1', 61, 1, '2022-01-02'),
    (4, 'Krish Star', 'Subject2', 71, 1, '2022-01-02'),
    (5, 'John Mike', 'Subject2', 61, 2, '2022-11-02'),
    (5, 'John Mike', 'Subject1', 91, 1, '2022-01-02'),
    (5, 'John Mike', 'Subject3', 98, 2, '2022-11-02')
]

c.executemany('INSERT INTO student_marks VALUES (?,?,?,?,?,?)', data)
conn.commit()

print("Student Marks Dataset Created Successfully.")
print("-" * 30)

# Verify
query = """
with base as 
(SELECT subject , marks , row_number() over (partition by subject order by marks desc) as row_num
FROM student_marks
UNION ALL
SELECT subject , marks , row_number() over (partition by subject order by marks) as row_num
FROM student_marks
)
select subject , marks from base where row_num = 2
order by subject,marks DESC
"""
c.execute(query) 

# Display results
columns = [description[0] for description in c.description]
print(columns)
for row in c.fetchall():
    print(row)

conn.close()
