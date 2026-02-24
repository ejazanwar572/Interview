# Lessons Learned

## Modifying Jupyter Notebooks (`.ipynb`)
- **NEVER** edit `.ipynb` files using AI text edit tools (like replace content or multi-replace) or sed/awk/grep commands. The JSON structure is easily broken, and there are strict format/escaping requirements.
- **ALWAYS** modify `.ipynb` files programmatically using a Python script with the `nbformat` library to read, modify, and rewrite the cells safely.

# Instructions for modifying .ipynb files
- Never use standard text replacement (like `sed` or standard write tools) to modify `.ipynb` files, as this destroys their JSON structure or causes silent sync issues in VS Code.
- ALWAYS write a short, dedicated Python script that loads the `.ipynb` with `json.load()`, modifies the `nb["cells"]` array, and saves it with `json.dump()`. 
- Run this `.py` script via terminal to update the file, and then remove the script. This ensures the Notebook UI picks up the formatted JSON cleanly without corruption.
- **NO RELOAD NEEDED:** The file will automatically update in the user's VS Code editor. DO NOT ask the user to close and reopen the file tab.
