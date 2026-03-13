# Lessons Learned

_This file tracks any corrections, rules, or pattern improvements encountered during the execution of this project._

## Core Guidelines

- Always follow the established user global rules (Simplicity First, No Laziness, Minimal Impact).
- Check assumptions and verify all code steps.

## Notebook Generation

- **NEVER** use standard bash `cat` or `sed` to generate or write to `.ipynb` files. This resulted in an empty file because the JSON format was corrupted or the command failed silently.
- **ALWAYS** write a separate Python script utilizing `nbformat` or `json` to programmatically build the cell dictionary when creating or editing a Jupyter Notebook.
