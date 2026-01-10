import sqlite3

# Connect to database
conn = sqlite3.connect('practice.db')
c = conn.cursor()

# Create table
c.execute('DROP TABLE IF EXISTS spending')
c.execute('''
CREATE TABLE spending (
    user_id INTEGER,
    spend_date TEXT,
    platform TEXT,
    amount INTEGER
)
''')

# Insert data from image
data = [
    (1, '2019-07-01', 'mobile', 100),
    (1, '2019-07-01', 'desktop', 100),
    (2, '2019-07-01', 'mobile', 100),
    (2, '2019-07-02', 'mobile', 100),
    (3, '2019-07-01', 'desktop', 100),
    (3, '2019-07-02', 'desktop', 100)
]

c.executemany('INSERT INTO spending VALUES (?,?,?,?)', data)
conn.commit()

print("Spending Dataset Created Successfully.")
print("-" * 30)

# Solution for "Total Market Value by Platform (Mobile, Desktop, Both)"
# Logic: 
# 1. For each (user, date), determine the 'platform_type':
#    - If count(platform) = 2 -> 'both'
#    - If count = 1 and platform='mobile' -> 'mobile'
#    - If count = 1 and platform='desktop' -> 'desktop'
# 2. Sum amounts grouped by date and this new platform_type.

query_1 = """
WITH user_daily AS (
    SELECT 
        spend_date,
        user_id,
        CASE 
            WHEN COUNT(DISTINCT platform) = 2 THEN 'both'
            ELSE MAX(platform) 
        END as platform_cat,
        SUM(amount) as total_amount
    FROM spending
    GROUP BY 1, 2
)
, all_dates_platforms AS (
    -- Generating all combinations if needed (Solution typically requires showing all categories even if 0)
    -- Simpler version: Just group by result of CTE
    SELECT DISTINCT spend_date, 'mobile' as platform_cat FROM spending
    UNION
    SELECT DISTINCT spend_date, 'desktop' as platform_cat FROM spending
    UNION
    SELECT DISTINCT spend_date, 'both' as platform_cat FROM spending
)

SELECT 
    p.spend_date,
    p.platform_cat as platform,
    COALESCE(SUM(u.total_amount), 0) as total_amount,
    COALESCE(COUNT(u.user_id), 0) as total_users
FROM all_dates_platforms p
LEFT JOIN user_daily u 
    ON p.spend_date = u.spend_date 
    AND p.platform_cat = u.platform_cat
GROUP BY 1, 2
ORDER BY 1, 2
"""


query_2  = """
with base as 
(SELECT user_id , spend_date
    , case when COUNT(DISTINCT platform) = 2 THEN  1 ELSE 0 END as both_platform
    , case when platform = 'mobile' THEN  1 ELSE 0 END as mobile_platform
    , case when platform = 'desktop' THEN  1 ELSE 0 END as desktop_platform
    , sum(amount) as total_amount
    FROM spending
    GROUP BY 1,2
)
SELECT spend_date , 'both' as platform , sum(total_amount) as total_amount
FROM base 
WHERE both_platform = 1 
GROUP BY 1

UNION ALL

SELECT spend_date , 'mobile' as platform , sum(total_amount) as total_amount
FROM base 
WHERE mobile_platform = 1 AND (both_platform = 0 AND desktop_platform = 0)
GROUP BY 1

UNION ALL

SELECT spend_date , 'desktop' as platform , sum(total_amount) as total_amount
FROM base 
WHERE desktop_platform = 1 AND (both_platform = 0 AND mobile_platform = 0)
GROUP BY 1
"""

c.execute(query_1)

# Display results
columns = [description[0] for description in c.description]
print(columns)
for row in c.fetchall():
    print(row)

conn.close()
