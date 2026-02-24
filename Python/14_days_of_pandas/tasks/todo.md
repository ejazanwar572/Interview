# Plan: Group Files into Difficulty Folders

## Objective
The files are currently sorted sequentially based on difficulty (e.g., `Easy_01_name`, `Medium_20_name`). However, to make it visually cleaner, this plan will organize the files directly into difficulty-based subfolders and re-index them per folder.

## Steps
- [x] **Step 1: Create Folders**
  - Create directories: `Easy`, `Medium`, and `Hard` inside `14_days_of_pandas`.
- [x] **Step 2: Move and Re-index Files**
  - Write a Python script to scan all files.
  - Move files starting with `Easy_` into the `Easy/` folder, and so on.
  - Strip the `Difficulty_` prefix from the file names since they are now in the difficulty folders.
  - Rename the files to start from `01` within each folder independently (e.g., `Easy/01_2nd_highest_salary.ipynb`, `Medium/01_split_data.ipynb`).
- [x] **Step 3: Update README**
  - Update the `README.md` file links to point to the new subdirectory paths correctly.
- [x] **Step 4: Execution**
  - Run the moving/renaming process and clean up scripts.

## Review Required
Does organizing them into `Easy/`, `Medium/`, and `Hard/` separate folders (with numbering restarting at `01` in each) sound like the sorting method you are looking for?
