import os

repo_path = "/Users/ejazanwar/Desktop/Interview/All-Hackerrank-SQL-Solutions"
output_file = "/Users/ejazanwar/Desktop/Interview/HackerRank_SQL_Solutions_Summary.md"

with open(output_file, "w") as outfile:
    outfile.write("# HackerRank SQL Solutions Summary\n\n")
    outfile.write("Extracted from: [CuriosityLeonardo/All-Hackerrank-SQL-Solutions](https://github.com/CuriosityLeonardo/All-Hackerrank-SQL-Solutions)\n\n")
    
    # Get all files and sort them
    files = sorted([f for f in os.listdir(repo_path) if os.path.isfile(os.path.join(repo_path, f)) and f != ".DS_Store" and not f.startswith(".git")])
    
    for filename in files:
        if filename == "README.md":
            continue
            
        file_path = os.path.join(repo_path, filename)
        try:
            with open(file_path, "r", encoding="utf-8") as infile:
                content = infile.read().strip()
                
            outfile.write(f"### {filename}\n")
            outfile.write("```sql\n")
            outfile.write(content)
            outfile.write("\n```\n\n")
            print(f"Processed: {filename}")
        except Exception as e:
            print(f"Error reading {filename}: {e}")

print(f"Compilation complete. Output written to {output_file}")
