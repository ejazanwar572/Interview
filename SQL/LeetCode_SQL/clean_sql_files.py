
import os
import re

BASE_DIR = "/Users/ejazanwar/Downloads/Interview/SQL/LeetCode_SQL"

def clean_file(filepath):
    with open(filepath, "r") as f:
        lines = f.readlines()
        
    # Check if this is a Doocs file (look for markers)
    is_doocs = False
    for line in lines:
        if "<!-- problem:start -->" in line:
            is_doocs = True
            break
            
    if not is_doocs:
        return False
        
    print(f"Cleaning {filepath}...")
    
    new_lines = []
    
    # buffers
    description_lines = []
    solution_lines = []
    
    in_solution_section = False
    in_mysql_block = False
    found_mysql = False
    
    # We will iterate and build the description until we hit "## Solutions" or "<!-- solution:start -->"
    # Then we look for the MySQL block.
    
    for line in lines:
        # Strip the "-- " prefix for analysis
        content = line.replace("-- ", "", 1).rstrip()
        
        # Detect start of solution section
        if "<!-- solution:start -->" in content or "## Solutions" in content:
            in_solution_section = True
            
        if not in_solution_section:
            # We are in description or header.
            # Clean up some garbage tags from description
            if "<!--" in content or "-->" in content:
                continue
            if content.strip() == "---" or content.startswith("edit_url:") or content.startswith("comments:") or content.startswith("tags:"):
                continue
                
            # If line is header or just comments, keep it.
            # But the Doocs content was all prefixed with --
            # The original header I added: 
            # -- <ID>. <Title>
            # -- Difficulty: ...
            # -- Description:
            new_lines.append(line)
        else:
            # We are in the solution section (or metadata after description)
            # We want to find the MySQL code block
            
            # Pattern: 
            # -- #### MySQL
            # -- 
            # -- ```sql
            # -- THE CODE
            # -- ```
            
            if "#### MySQL" in content:
                # We are approaching the block
                pass
            
            if "```sql" in content and not in_mysql_block and not found_mysql:
                in_mysql_block = True
                continue # Don't add the ```sql line
                
            if "```" in content and in_mysql_block:
                in_mysql_block = False
                found_mysql = True
                continue # Don't add the ``` line
                
            if in_mysql_block:
                # This is the code! Uncomment it.
                # The line currently is "-- code" or "--    code"
                # We want just "code" or "   code"
                # But careful strictly removing "-- " might break if indentation is weird, 
                # but usually Doocs is "-- code".
                # Actually, my fetch script did `commented_content += f"-- {line}\n"`
                # So stripping the first 3 chars "-- " should work exactly.
                
                code_line = line[3:] if line.startswith("-- ") else line
                solution_lines.append(code_line)

    # Reassemble
    
    # 1. Header & Description (already in new_lines)
    # Filter out the trailing "Write your MySQL query statement below" placeholder I added if present
    final_lines = []
    for l in new_lines:
        if "Write your MySQL query statement below" not in l and "-- Solution:" not in l:
            final_lines.append(l)
            
    # Add Solution Header
    final_lines.append("\n-- Solution:\n")
    
    if solution_lines:
        final_lines.extend(solution_lines)
    else:
        # If no MySQL block found, keep original placeholder? 
        # Or maybe it was just a description file.
        final_lines.append("-- No MySQL solution found in parsed content.\n")

    with open(filepath, "w") as f:
        f.writelines(final_lines)
        
    return True

def main():
    count = 0
    for root, dirs, files in os.walk(BASE_DIR):
        for file in files:
            if file.endswith(".sql"):
                path = os.path.join(root, file)
                if clean_file(path):
                    count += 1
    print(f"Cleaned {count} files.")

if __name__ == "__main__":
    main()
