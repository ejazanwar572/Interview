---
description: Optimize a resume for a specific job posting using the standard template.
---

# Optimized Resume Workflow

Follow these steps exactly to create a tailored resume that matches the user's standard formatting.

1.  **Analyze Job Description**
    - Extract: Job Title, Company, Key Responsibilities, Required Skills, and core keywords.
    - Plan: Decide how to frame the user's experience (PayPal, OLX, Uber) to match the role.

2.  **Create Resume Markdown**
    - File Path: `/Users/ejazanwar/Desktop/Interview/Resumes/[Company]_[Role]_Resume.md`
    - Content: Write the optimized content in Markdown.
    - **Header**: Use standard header format:
      `**Email:** ... | **Phone:** ... | **LinkedIn:** [Link]`
    - **Bold Keywords**: Bold key terms throughout the text.

3.  **Generate Standard PDF**
    - Use the standard generator script. **DO NOT** use `markdown-pdf` or custom scripts.
    - Command:
      ```bash
      /Users/ejazanwar/Desktop/AI_Agents/venv/bin/python3 /Users/ejazanwar/Desktop/Interview/Scripts/generate_standard_resume_updated.py "/Users/ejazanwar/Desktop/Interview/Resumes/[Company]_[Role]_Resume.md" "/Users/ejazanwar/Desktop/Interview/Resumes/[Company]_[Role]_Resume.pdf"
      ```

4.  **Verify Output**
    - Check that the PDF was created.
    - Confirm it uses the standard blue header style.

5.  **Notify User**
    - Provide the path to the PDF.