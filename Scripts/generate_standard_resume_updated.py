import markdown
from xhtml2pdf import pisa
import sys
import os
import traceback

def generate_resume(input_md_path, output_pdf_path):
    # CSS Template aiming to match Nielsen Resume Format
    css_styles = """
    @page {
        margin: 0.45in;
        size: letter;
        @frame footer_frame {
            -pdf-frame-content: footerContent;
            bottom: 0.2cm;
            margin-left: 0.45in;
            margin-right: 0.45in;
            height: 1cm;
        }
    }
    body {
        font-family: Helvetica, Arial, sans-serif;
        font-size: 10.5pt; /* Balanced for readability and space */
        line-height: 1.25;
        color: #000;
        text-align: justify;
    }
    
    /* Header Section */
    h1 {
        font-size: 24pt;
        font-weight: bold;
        text-align: center;
        margin-bottom: 3px;
        color: #2E74B5;
    }
    
    /* Contact Info */
    .contact-info {
        text-align: center;
        font-size: 10pt;
        margin-bottom: 10px;
        margin-top: 2px;
        color: #333;
    }

    /* Section Headers */
    h2 {
        font-size: 12pt;
        font-weight: bold;
        text-transform: uppercase;
        border-bottom: 1px solid #2E74B5;
        padding-bottom: 2px;
        margin-top: 12px;
        margin-bottom: 6px;
        color: #2E74B5;
        text-align: left;
    }

    /* Job Content */
    h3 {
        font-size: 10.5pt;
        font-weight: bold;
        margin-top: 8px;
        margin-bottom: 2px;
        color: #000;
        width: 100%;
    }
    
    /* Date Alignment - Table Approach (Robust) */
    table.job-header {
        width: 100%;
        border: none;
        margin-top: 8px;
        margin-bottom: 2px;
        border-collapse: collapse;
    }
    td {
        padding: 0;
        vertical-align: baseline;
    }
    .job-title {
        text-align: left;
        font-weight: bold;
        font-size: 10.5pt;
        color: #000;
        width: 70%;
    }
    .job-location {
        text-align: right;
        font-weight: bold;
        font-size: 10pt;
        color: #000;
        width: 30%;
        white-space: nowrap;
    }

    /* Lists */
    ul {
        margin-top: 2px;
        margin-bottom: 6px;
        padding-left: 16px;
    }
    li {
        margin-bottom: 2px;
        text-align: justify;
        list-style-type: disc; 
    }
    
    p {
        margin-bottom: 3px;
        text-align: justify;
    }

    a {
        color: #2E74B5;
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
            <style>
            {css_styles}
            </style>
        </head>
        <body>
            {html_body}
        </body>
        </html>
        """

        print("Generating PDF with xhtml2pdf...")
        with open(output_pdf_path, "wb") as pdf_file:
            pisa_status = pisa.CreatePDF(
                full_html,                # the HTML to convert
                dest=pdf_file             # file handle to recieve result
            )

        if pisa_status.err:
            print(f"ERROR: Failed to generate PDF. err: {pisa_status.err}")
        else:
            print(f"SUCCESS: Standardized PDF generated at {output_pdf_path}")

    except Exception as e:
        print(f"ERROR: Failed to generate PDF. Reason: {e}")
        traceback.print_exc()

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python generate_standard_resume_updated.py <input_md_file> <output_pdf_file>")
    else:
        generate_resume(sys.argv[1], sys.argv[2])

