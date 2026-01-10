import markdown
from weasyprint import HTML, CSS
import sys
import os
import traceback

def generate_resume(input_md_path, output_pdf_path):
    # CSS Template aiming to match Nielsen Resume Format (inferred from Target script)
    # Characteristics: Centered Header, Clean Sans-Serif, Dense layout, Right-aligned dates.
    css_styles = """
    @page {
        margin: 0.5in 0.5in;
        size: letter;
    }
    body {
        font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
        font-size: 10pt;
        line-height: 1.4;
        color: #000;
        max-width: 100%;
        margin: 0;
        padding: 0;
    }
    
    /* Header Section */
    h1 {
        font-size: 20pt;
        font-weight: 700;
        text-align: center;
        margin-bottom: 5px;
        margin-top: 0;
        text-transform: uppercase;
        color: #000;
        border: none;
    }
    
    /* Contact Info (Paragraph immediately following H1 presumed) */
    h1 + p {
        text-align: center;
        font-size: 9pt;
        margin-bottom: 15px;
        color: #000;
    }

    /* Section Headers */
    h2 {
        font-size: 11pt;
        font-weight: 700;
        text-transform: uppercase;
        border-bottom: 1px solid #000;
        padding-bottom: 2px;
        margin-top: 15px;
        margin-bottom: 10px;
        color: #000;
        text-align: left;
    }

    /* Job Content */
    h3 {
        font-size: 10pt;
        font-weight: 700;
        margin-top: 10px;
        margin-bottom: 2px;
        color: #000;
        /* Ensure title stays on left, date floats right based on span */
    }

    /* Date/Location styling helper */
    /* Usage in markdown: ### Job Title, Company <span class="date">Location | Date</span> */
    .date {
        float: right;
        font-weight: normal;
        font-size: 10pt;
        text-align: right;
        color: #000;
    }
    
    /* Clearfix for floats */
    h3::after {
        content: "";
        display: table;
        clear: both;
    }

    /* Lists */
    ul {
        margin-top: 2px;
        margin-bottom: 8px;
        padding-left: 1.2em;
    }
    li {
        margin-bottom: 2px;
        text-align: justify;
        list-style-type: none; 
        position: relative;
    }
    
    /* Custom Bullet (Dash) to match Nielsen format */
    li::before {
        content: "–"; 
        position: absolute;
        left: -1.2em; 
        font-weight: bold;
    }

    p {
        margin-bottom: 5px;
        text-align: justify;
    }

    a {
        color: #000;
        text-decoration: none;
    }
    """

    try:
        print(f"Reading markdown from: {input_md_path}")
        with open(input_md_path, 'r', encoding='utf-8') as f:
            md_content = f.read()

        print("Converting to HTML...")
        # Enable attribute lists
        html_body = markdown.markdown(md_content, extensions=['attr_list'])

        # Wrap in full HTML structure
        full_html = f"""
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
        </head>
        <body>
            {html_body}
        </body>
        </html>
        """

        print("Generating PDF...")
        html = HTML(string=full_html, base_url=".")
        css = CSS(string=css_styles)
        html.write_pdf(output_pdf_path, stylesheets=[css])

        print(f"SUCCESS: Standardized PDF generated at {output_pdf_path}")

    except Exception as e:
        print(f"ERROR: Failed to generate PDF. Reason: {e}")
        traceback.print_exc()

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python generate_standard_resume_updated.py <input_md_file> <output_pdf_file>")
    else:
        generate_resume(sys.argv[1], sys.argv[2])
