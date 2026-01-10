import sqlite3

# Connect to database
conn = sqlite3.connect('practice.db')
c = conn.cursor()

# Create tables
c.execute('DROP TABLE IF EXISTS users')
c.execute('DROP TABLE IF EXISTS orders')
c.execute('DROP TABLE IF EXISTS items')

c.execute('''
CREATE TABLE users (
    user_id INTEGER,
    join_date TEXT,
    favorite_brand TEXT
)
''')

c.execute('''
CREATE TABLE orders (
    order_id INTEGER,
    order_date TEXT,
    item_id INTEGER,
    buyer_id INTEGER,
    seller_id INTEGER
)
''')

c.execute('''
CREATE TABLE items (
    item_id INTEGER,
    item_brand TEXT
)
''')

# Insert data from image
users_data = [
    (1, '2019-01-01', 'Lenovo'),
    (2, '2019-02-09', 'Samsung'),
    (3, '2019-01-19', 'LG'),
    (4, '2019-05-21', 'HP')
]

orders_data = [
    (1, '2019-08-01', 4, 1, 2),
    (2, '2019-08-02', 2, 1, 3),
    (3, '2019-08-03', 3, 2, 3),
    (4, '2019-08-04', 1, 4, 2),
    (5, '2019-08-04', 1, 3, 4),
    (6, '2019-08-05', 2, 2, 4)
]

items_data = [
    (1, 'Samsung'),
    (2, 'Lenovo'),
    (3, 'LG'),
    (4, 'HP')
]

c.executemany('INSERT INTO users VALUES (?,?,?)', users_data)
c.executemany('INSERT INTO orders VALUES (?,?,?,?,?)', orders_data)
c.executemany('INSERT INTO items VALUES (?,?)', items_data)
conn.commit()

print("Market Analysis Dataset Created Successfully.")
print("-" * 30)

# Common Question: Market Analysis I (LeetCode 1158)
# "Write an SQL query to find for each user, the join date and the number of orders they made as a buyer in 2019."

print("Query: Join Date and Orders in 2019 per User")

query = """
SELECT 
    u.user_id, 
    u.join_date,
    COUNT(o.order_id) as orders_in_2019
FROM users u
LEFT JOIN orders o 
    ON u.user_id = o.buyer_id 
    AND strftime('%Y', o.order_date) = '2019'
GROUP BY u.user_id, u.join_date
ORDER BY u.user_id
"""

c.execute(query)

# Display results
columns = [description[0] for description in c.description]
print(columns)
for row in c.fetchall():
    print(row)

print("-" * 30)
print("Bonus Logic: Check if Buyer's Favorite Brand matches Item Brand bought")

query_bonus = """
SELECT 
    o.order_id,
    u.user_id,
    u.favorite_brand,
    i.item_brand,
    CASE WHEN u.favorite_brand = i.item_brand THEN 'Match' ELSE 'No Match' END as is_favorite
FROM orders o
JOIN users u ON o.buyer_id = u.user_id
JOIN items i ON o.item_id = i.item_id
"""

c.execute(query_bonus)
columns = [description[0] for description in c.description]
print(columns)
for row in c.fetchall():
    print(row)

conn.close()
