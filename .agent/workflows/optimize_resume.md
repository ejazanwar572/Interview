---
description: Optimize a resume for a specific job posting using the standard template.
---

# Optimized Resume Workflow

Follow these steps exactly to create a tailored resume that matches the user's standard formatting.


1.  **Cleanup Old Resumes**
    - **Goal**: Remove resume files older than 24 hours to keep the workspace clean.
    - **Command**:
      ```bash
      # Find and delete .md and .pdf files in Resumes folder modified more than 24 hours ago
      find /Users/ejazanwar/Downloads/Interview/Resumes -type f \( -name "*.md" -o -name "*.pdf" \) -mtime +1 -delete
      ```

2.  **Analyze Job Description**
    - Extract: Job Title, Company, Key Responsibilities, Required Skills, and core keywords.
    - Plan: Decide how to frame the user's experience (PayPal, OLX, Uber) to match the role.

3.  **Create Resume Markdown**
    - File Path: `/Users/ejazanwar/Downloads/Interview/Resumes/[Company]_[Role]_Resume.md`
    - Content: Write the optimized content in Markdown.
    - **Header**: Use standard header format:
      `**Email:** ... | **Phone:** ... | **LinkedIn:** [Link]`
    - **Bold Keywords**: Bold key terms throughout the text.

4.  **Generate Standard PDF**
    - Use the standard generator script. **DO NOT** use `markdown-pdf` or custom scripts.
    - Command:
      ```bash
      python3 /Users/ejazanwar/Downloads/Interview/Scripts/generate_standard_resume_updated.py "/Users/ejazanwar/Downloads/Interview/Resumes/[Company]_[Role]_Resume.md" "/Users/ejazanwar/Downloads/Interview/Resumes/[Company]_[Role]_Resume.pdf"
      ```
    - **Note**: Ensure `python3` is available and has `markdown` and `xhtml2pdf` installed.

5.  **Verify Output**
    - Check that the PDF was created.
    - Confirm it uses the standard blue header style.

6.  **Notify User**
    - Provide the path to the PDF.

