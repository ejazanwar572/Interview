import sqlite3

# Connect to database
conn = sqlite3.connect('practice.db')
c = conn.cursor()

# Create table
c.execute('DROP TABLE IF EXISTS orders')
# Note: Added Product_ID and Sales based on the problem description "80% of sales from 20% of products"
# creating columns that were likely cut off in the screenshot.
c.execute('''
CREATE TABLE orders (
    Row_ID INTEGER PRIMARY KEY,
    Order_ID TEXT,
    Order_Date TEXT,
    Ship_Date TEXT,
    Ship_Mode TEXT,
    Customer_ID TEXT,
    Customer_Name TEXT,
    Segment TEXT,
    Country TEXT,
    City TEXT,
    State TEXT,
    Product_ID TEXT,
    Sales REAL
)
''')

# Insert data (Transcribed from screenshot + mocked Product/Sales)
data = [
    (7218, 'CA-2019-150770', '2019-05-03', '2019-05-06', 'First Class', 'LC-16870', 'Lena Cacioppo', 'Consumer', 'United States', 'San Francisco', 'California', 'FUR-BO-10001798', 100.0),
    (7219, 'CA-2019-150770', '2019-05-03', '2019-05-06', 'First Class', 'LC-16870', 'Lena Cacioppo', 'Consumer', 'United States', 'San Francisco', 'California', 'OFF-BI-10004970', 50.0),
    (7220, 'CA-2019-150770', '2019-05-03', '2019-05-06', 'First Class', 'LC-16870', 'Lena Cacioppo', 'Consumer', 'United States', 'San Francisco', 'California', 'TEC-PH-10000215', 300.0),
    (7221, 'CA-2021-154760', '2021-01-09', '2021-01-13', 'Standard Class', 'BP-11290', 'Beth Paige', 'Consumer', 'United States', 'Philadelphia', 'Pennsylvania', 'OFF-AR-10001868', 20.0),
    (7222, 'US-2021-104437', '2021-01-27', '2021-01-31', 'Standard Class', 'TG-21310', 'Toby Gnade', 'Consumer', 'United States', 'New York City', 'New York', 'OFF-FA-10002780', 15.0),
    (7223, 'CA-2021-113075', '2021-09-02', '2021-09-06', 'Standard Class', 'MC-18100', 'Mick Crebagga', 'Consumer', 'United States', 'Chicago', 'Illinois', 'OFF-PA-10002005', 45.0),
    (7224, 'CA-2020-109953', '2020-07-14', '2020-07-18', 'Standard Class', 'RB-19360', 'Raymond Buch', 'Consumer', 'United States', 'San Francisco', 'California', 'TEC-AC-10002167', 1200.0),
    (7225, 'CA-2020-109953', '2020-07-14', '2020-07-18', 'Standard Class', 'RB-19360', 'Raymond Buch', 'Consumer', 'United States', 'San Francisco', 'California', 'OFF-PA-10003302', 200.0),
    (7226, 'CA-2020-109953', '2020-07-14', '2020-07-18', 'Standard Class', 'RB-19360', 'Raymond Buch', 'Consumer', 'United States', 'San Francisco', 'California', 'FUR-CH-10001146', 500.0),
    (7227, 'CA-2021-127397', '2021-02-24', '2021-02-28', 'Standard Class', 'ES-14080', 'Erin Smith', 'Corporate', 'United States', 'Philadelphia', 'Pennsylvania', 'OFF-AP-10002457', 150.0)
    # Added Product_ID and Sales as they are essential for the Pareto problem but were cut off in the image
]

c.executemany('INSERT INTO orders VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)', data)
conn.commit()

print("Pareto Dataset Created Successfully.")
print("-" * 30)

query = """
with tot_sales as 
(SELECT sum(Sales) as total_sales FROM orders)
, top_20 as 
(SELECT Product_ID , Sales , sum(Sales) over(order by Sales desc) as running_sales
FROM orders
WHERE 1=1
GROUP BY 1,2
)
---
SELECT top_20.Product_ID , top_20.Sales , top_20.running_sales 
FROM top_20
WHERE running_sales <= 0.8*(SELECT total_sales FROM tot_sales)
"""
c.execute(query)


columns = [description[0] for description in c.description]
print(columns)
rows = c.fetchall()
for row in rows:
    print(row)
conn.close()
