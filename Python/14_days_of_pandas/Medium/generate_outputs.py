import pandas as pd
import numpy as np

# PQ4 Data
feed_comments_data = {
    'ad_id': [1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 4, 4, 4, 4, 5],
    'user_id': [101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118],
    'comment_id': [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18],
}
feed_comments = pd.DataFrame(feed_comments_data)

moments_comments_data = {
    'ad_id': [1, 1, 1, 1, 2, 3, 3, 3, 3, 3, 3, 4, 4, 5, 5, 5, 5, 5, 5],
    'user_id': [201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219],
    'comment_id': [19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37],
}
moments_comments = pd.DataFrame(moments_comments_data)

ads_data = {
    'id': [1, 2, 3, 4, 5],
    'name': ['Labor Day', 'Polo Shirts', 'Christmas Sale', 'Black Friday', 'Spring Clearance']
}
ads = pd.DataFrame(ads_data)

# Q4: Outer merge and fillna
feed_usr = feed_comments.groupby('user_id')['comment_id'].count().reset_index(name='feed_count')
mom_usr = moments_comments.groupby('user_id')['comment_id'].count().reset_index(name='moments_count')
q4_ans = pd.merge(feed_usr, mom_usr, on='user_id', how='outer').fillna(0)
q4_ans['total_comments'] = q4_ans['feed_count'] + q4_ans['moments_count']
# make user_id int, but since there are no overlapping users, feed_count and moments_count will be float. 
# actually wait: is there overlapping users in mock data? 
# feed: 101-118. mom: 201-219. So NO overlapping users. Let's make some overlapping manually just for the question, OR it doesn't matter user_ids are unique.
print("--- Q4 ---")
print(q4_ans.head().to_string())

# Q5: concat and groupby
f = feed_comments.assign(source='feed')
m = moments_comments.assign(source='moments')
q5_stacked = pd.concat([f,m])
q5_ans = q5_stacked.groupby('user_id')['comment_id'].count().reset_index(name='total_comments').sort_values('total_comments', ascending=False).head(3)
print("--- Q5 ---")
print(q5_ans.to_string())

# Q6: assign math
campaigns_data = {
    'ad_id': [1, 2, 3, 4, 5],
    'budget': [1000, 2000, 1500, 3000, 500],
    'spend': [1200, 1800, 1500, 1000, 600]
}
campaigns = pd.DataFrame(campaigns_data)
q6_ans = campaigns.assign(
    remaining_budget = lambda x: x['budget'] - x['spend'],
    is_over_budget = lambda x: x['spend'] > x['budget'],
    utilization_rate = lambda x: (x['spend'] / x['budget']).round(2)
)
print("--- Q6 ---")
print(q6_ans.to_string())

# Q7: Map dict
user_df = pd.DataFrame({'user_id': [101, 102, 103, 104, 105, 999, 888]})
user_tiers = {101: 'Premium', 102: 'Free', 103: 'Premium', 104: 'Free', 105: 'Premium'}
q7_ans = user_df.assign(
    tier = lambda x: x['user_id'].map(user_tiers).fillna('Unknown')
)
print("--- Q7 ---")
print(q7_ans.to_string())

# Q8: Crosstab
np.random.seed(42)
comments_df = pd.DataFrame({
    'user_id': range(1, 21),
    'device_type': np.random.choice(['iOS', 'Android'], size=20),
    'day_of_week': np.random.choice(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'], size=20)
})
q8_ans = pd.crosstab(index=comments_df['device_type'], columns=comments_df['day_of_week'])
print("--- Q8 ---")
print(q8_ans.to_string())

