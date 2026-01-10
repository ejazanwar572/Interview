import sqlite3

# Connect to database
conn = sqlite3.connect('practice.db')
c = conn.cursor()

# Create table
c.execute('DROP TABLE IF EXISTS rental_amenities')
c.execute('''
CREATE TABLE rental_amenities (
    rental_id INTEGER,
    amenity TEXT
)
''')

# Insert data from image
data = [
    (123, 'pool'),
    (123, 'kitchen'),
    (234, 'hot tub'),
    (234, 'fireplace'),
    (345, 'kitchen'),
    (345, 'pool'),
    (456, 'pool')
]

c.executemany('INSERT INTO rental_amenities VALUES (?,?)', data)
conn.commit()

print("Rental Amenities Dataset Created Successfully.")
print("-" * 30)

# Likely Interview Question: "Find rentals that have BOTH a Pool and a Kitchen"

print("Query: Rentals with both 'pool' and 'kitchen'")

# Logic: Group by rental_id and filter where the count of distinct amenities (filtered to pool/kitchen) is 2.
# query = """
# SELECT rental_id
# FROM rental_amenities
# WHERE amenity IN ('pool', 'kitchen')
# GROUP BY rental_id
# HAVING COUNT(DISTINCT amenity) = 2
# """

# c.execute(query)

# # Display results
# columns = [description[0] for description in c.description]
# print(columns)
# for row in c.fetchall():
#     print(row)

query_2 = """
SELECT r1.rental_id || '-' || r2.rental_id AS rental_pair, GROUP_CONCAT(r1.amenity) AS shared_amenities
FROM rental_amenities AS r1
JOIN rental_amenities AS r2 ON r1.rental_id < r2.rental_id AND r1.amenity = r2.amenity 
GROUP BY 1
"""
c.execute(query_2)

# Display results
columns = [description[0] for description in c.description]
print(columns)
for row in c.fetchall():
    print(row)

conn.close()
