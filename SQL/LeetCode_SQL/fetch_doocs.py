
import json
import os
import urllib.request
import re
import sys

MISSING_FILE = "missing.json"
BASE_DIR = "/Users/ejazanwar/Downloads/Interview/SQL/LeetCode_SQL"

def to_snake_case(text):
    text = re.sub(r'[^a-zA-Z0-9\s]', '', text)
    return text.lower().replace(" ", "_")

def get_doocs_url(id, title):
    id_int = int(id)
    start = (id_int // 100) * 100
    end = start + 99
    range_str = f"{start}-{end}"
    
    # Doocs title formatting: . replace with nothing usually, but let's see. 
    # title in URL is spaces replaced by %20.
    # symbols: usually kept or encoded.
    # The example 2004 worked with "The%20Number...".
    encoded_title = urllib.parse.quote(title)
    
    url = f"https://raw.githubusercontent.com/doocs/leetcode/main/solution/{range_str}/{id}.{encoded_title}/README_EN.md"
    return url

def fetch_and_create(problem):
    id = problem["id"]
    title = problem["title"]
    difficulty = problem["difficulty"]
    
    # Determine directory
    # Difficulty might be "Med." or "Medium" or "Hard"
    if difficulty == "Med.": difficulty = "Medium"
    
    target_dir = os.path.join(BASE_DIR, difficulty)
    if not os.path.exists(target_dir):
        # Fallback or create? List showed Easy, Medium, Hard exist.
        # If difficulty is blank?
        if not difficulty: difficulty = "Medium" # Default
        target_dir = os.path.join(BASE_DIR, difficulty)
    
    snake_title = to_snake_case(title)
    filename = f"{id}_{snake_title}.sql"
    filepath = os.path.join(target_dir, filename)
    
    # URL construction
    url = get_doocs_url(id, title)
    
    print(f"Fetching {id} from {url}...")
    
    try:
        with urllib.request.urlopen(url) as response:
            content = response.read().decode('utf-8')
            
            # Create file content
            # Extract description? It's the whole README usually.
            # We want to comment it out.
            
            # Simple conversion of markdown to SQL comments
            commented_content = ""
            for line in content.splitlines():
                commented_content += f"-- {line}\n"
                
            file_content = f"""-- {id}. {title}
-- Difficulty: {difficulty}

-- Description:
{commented_content}

-- Solution:
-- Write your MySQL query statement below

"""
            with open(filepath, "w") as f:
                f.write(file_content)
            print(f"Created {filepath}")
            return True
            
    except Exception as e:
        print(f"Failed to fetch {id}: {e}")
        return False

def main():
    with open(MISSING_FILE, "r") as f:
        problems = json.load(f)
        
    # Process remaining problems
    count = 0
    success = 0
    for p in problems[20:]:
        if fetch_and_create(p):
            success += 1
        count += 1
        
    print(f"Processed {count} problems. Success: {success}")

if __name__ == "__main__":
    main()
