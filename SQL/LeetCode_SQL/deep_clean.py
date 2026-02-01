
import os
import re

BASE_DIR = "/Users/ejazanwar/Downloads/Interview/SQL/LeetCode_SQL"

def clean_html(text):
    # Basic HTML to text conversions
    text = re.sub(r'</?(p|div|ul|pre|code|strong|em|span)[^>]*>', '', text)
    text = re.sub(r'<li>', '- ', text)
    text = re.sub(r'</li>', '', text)
    text = re.sub(r'<br\s*/?>', '\n', text)
    text = text.replace('&nbsp;', ' ').replace('&lt;', '<').replace('&gt;', '>').replace('&ge;', '>=').replace('&le;', '<=').replace('&#39;', "'")
    return text

def clean_file(filepath):
    with open(filepath, "r") as f:
        lines = f.readlines()
        
    # Check if this is a Doocs file (look for markers or just the files we touched)
    # The previous script might have already removed markers.
    # Let's check for the existence of "Solution:" and check for commented metadata
    
    print(f"Deep cleaning {filepath}...")
    
    new_lines = []
    
    # buffers
    header_kept = False
    
    # Mode: 0=Header, 1=Description, 2=Solution
    mode = 0
    
    final_desc_lines = []
    solution_lines = []
    
    for line in lines:
        content = line.strip()
        
        if line.strip() == "-- Solution:":
            mode = 2
            continue
            
        if mode == 2:
            solution_lines.append(line)
            continue
            
        # We are in header/description block.
        # It is all commented with "-- "
        # We want to keep the top ID/Title header, but strip the Doocs metadata.
        
        if not line.startswith("--"):
            # Empty line or code?
            if mode == 0 and line.strip() == "": continue
            final_desc_lines.append(line)
            continue
            
        comment_content = line[3:].rstrip() if line.startswith("-- ") else line[2:].rstrip()
        
        # Header preservation (lines 1-2 generally)
        if re.match(r'^\d+\.', comment_content) or comment_content.startswith("Difficulty:"):
            final_desc_lines.append(line)
            continue

        # Skip unwanted metadata
        if "中文文档" in comment_content or "edit_url:" in comment_content or "comments:" in comment_content or "tags:" in comment_content or "difficulty:" in comment_content:
            continue
            
        # Skip Doocs branding headers
        if comment_content.startswith("# [") and "](" in comment_content:
            continue
            
        if comment_content == "Description":
            final_desc_lines.append("-- \n-- Description:\n")
            continue
            
        if comment_content == "---":
            continue
            
        # Clean HTML from description
        cleaned_text = clean_html(comment_content)
        
        # If line became empty but wasn't, maybe skip?
        if cleaned_text.strip() == "" and comment_content.strip() != "":
            # If it was just a tag line, skip it
            continue
            
        final_desc_lines.append(f"-- {cleaned_text}\n")


    # Post-process description to remove excessive blank lines
    cleaned_desc = []
    prev_blank = False
    for l in final_desc_lines:
        is_blank = l.strip() == "--"
        if is_blank and prev_blank:
            continue
        cleaned_desc.append(l)
        prev_blank = is_blank

    with open(filepath, "w") as f:
        f.writelines(cleaned_desc)
        f.write("-- Solution:\n")
        f.writelines(solution_lines)
        
    return True

def main():
    count = 0
    # Targeted sweep - mainly the one user complained about plus others
    # Actually let's just run on all files to be safe, it's fast.
    for root, dirs, files in os.walk(BASE_DIR):
        for file in files:
            if file.endswith(".sql"):
                path = os.path.join(root, file)
                clean_file(path)
                count += 1
    print(f"Cleaned {count} files.")

if __name__ == "__main__":
    main()
