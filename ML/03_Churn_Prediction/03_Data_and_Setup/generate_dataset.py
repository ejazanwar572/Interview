import numpy as np
import pandas as pd
import random
import os

def generate_synthetic_data(num_users=100000, seed=42):
    """
    Generates a synthetic dataset for shopping extension churn prediction.
    Models the first 90 days of feature usage.
    """
    np.random.seed(seed)
    random.seed(seed)
    
    print(f"Generating synthetic dataset for {num_users} users...")
    
    # 1. Base User IDs
    user_ids = [f"USR_{str(i).zfill(6)}" for i in range(1, num_users + 1)]
    
    # 2. Base Interaction Levels (used to drive other metrics)
    # 0 = Low (20%), 1 = Medium (50%), 2 = High (30%)
    interaction_levels = np.random.choice([0, 1, 2], size=num_users, p=[0.20, 0.50, 0.30])
    
    # 3. Generate Features based on interaction levels
    price_comp_views = []
    coupon_attempts = []
    cashback_clicks = []
    
    for level in interaction_levels:
        if level == 0:
            price_comp_views.append(np.random.poisson(2))
            coupon_attempts.append(np.random.poisson(1))
            cashback_clicks.append(np.random.poisson(0.5))
        elif level == 1:
            price_comp_views.append(np.random.poisson(15))
            coupon_attempts.append(np.random.poisson(10))
            cashback_clicks.append(np.random.poisson(5))
        else:
            price_comp_views.append(np.random.poisson(45))
            coupon_attempts.append(np.random.poisson(30))
            cashback_clicks.append(np.random.poisson(15))
            
    # Vectorize successes and amounts based on attempts
    # Success rate varies. Higher attempts generally correlate to slightly lower per-attempt success rate due to edge-case sites.
    coupon_success_rates = np.random.uniform(0.1, 0.6, size=num_users)
    coupon_successes = np.round(np.array(coupon_attempts) * coupon_success_rates).astype(int)
    
    # Ensure successes don't exceed attempts
    coupon_successes = np.minimum(coupon_successes, coupon_attempts)
    
    # Savings per success (log-normal distribution for realistic monetary values)
    # Median savings ~$5, mean ~$8
    savings_per_success = np.random.lognormal(mean=1.6, sigma=0.8, size=num_users)
    amount_saved = np.round(coupon_successes * savings_per_success, 2)
    
    # Cashback earned per click
    cashback_per_click = np.random.lognormal(mean=0.5, sigma=1.0, size=num_users)
    cashback_earned = np.round(np.array(cashback_clicks) * cashback_per_click, 2)
    
    # Days since install (all > 90 to fit the cohort)
    days_since_install = np.random.randint(120, 365, size=num_users)
    
    # 4. CHURN LOGIC (The crucial part)
    # We want a base churn rate, modified by the user's experience.
    # Higher value = more likely to churn. Lower value = more likely to retain.
    base_churn_prob = np.full(num_users, 0.30) # 30% baseline
    
    # Frustration modifying: High attempts, low success rate increases churn
    frustration_mask = (np.array(coupon_attempts) > 5) & (coupon_success_rates < 0.2)
    base_churn_prob[frustration_mask] += 0.25 
    
    # Value modifying: High total saved or cashback decreases churn
    total_value = amount_saved + cashback_earned
    value_percentiles = np.percentile(total_value, [25, 50, 75])
    
    # Highly engaged users making money rarely churn
    base_churn_prob[total_value > value_percentiles[2]] -= 0.15
    base_churn_prob[(total_value > value_percentiles[1]) & (total_value <= value_percentiles[2])] -= 0.05
    
    # Apathy modifying: Very low interactions across the board increases churn
    total_interactions = np.array(price_comp_views) + np.array(coupon_attempts) + np.array(cashback_clicks)
    apathy_mask = total_interactions < 5
    base_churn_prob[apathy_mask] += 0.35
    
    # Bound probabilities between 0.01 and 0.99
    final_churn_prob = np.clip(base_churn_prob, 0.01, 0.99)
    
    # Generate binary churn variable
    rand_vals = np.random.rand(num_users)
    churn_flag = (rand_vals < final_churn_prob).astype(int)
    
    # 5. Create DataFrame
    df = pd.DataFrame({
        'user_id': user_ids,
        'days_since_install': days_since_install,
        'price_comp_views': price_comp_views,
        'coupon_attempts': coupon_attempts,
        'coupon_successes': coupon_successes,
        'amount_saved': amount_saved,
        'cashback_clicks': cashback_clicks,
        'cashback_earned': cashback_earned,
        'total_interactions': total_interactions,
        'churned': churn_flag
    })
    
    print(f"Dataset generated. Overall Churn Rate: {df['churned'].mean():.2%}")
    
    # Ensure directory exists and save
    os.makedirs(os.path.dirname(os.path.abspath(__file__)), exist_ok=True)
    file_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'shopping_extension_data.csv')
    df.to_csv(file_path, index=False)
    print(f"Saved dataset to {file_path}")

if __name__ == "__main__":
    generate_synthetic_data(100000)
