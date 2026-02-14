import markdown
from xhtml2pdf import pisa
import sys
import os

def generate_pdf(input_md_path, output_pdf_path):
    # CSS Styles for a Clean, Professional Study Guide
    css_styles = """
    @page {
        margin: 1in;
        size: letter;
        @frame footer_frame {
            -pdf-frame-content: footerContent;
            bottom: 0.5cm;
            margin-left: 1in;
            margin-right: 1in;
            height: 1cm;
        }
    }
    
    body {
        font-family: 'Helvetica', 'Arial', sans-serif;
        font-size: 11pt;
        line-height: 1.5;
        color: #333;
    }

    h1 {
        font-size: 24pt;
        color: #2c3e50;
        border-bottom: 2px solid #2c3e50;
        padding-bottom: 10px;
        margin-top: 0;
        margin-bottom: 20px;
    }

    h2 {
        font-size: 18pt;
        color: #e67e22; /* Accent Color similar to some tech docs */
        margin-top: 25px;
        margin-bottom: 10px;
        border-bottom: 1px solid #e67e22;
        padding-bottom: 5px;
    }

    h3 {
        font-size: 14pt;
        color: #2980b9;
        margin-top: 20px;
        margin-bottom: 8px;
        font-weight: bold;
    }

    p {
        margin-bottom: 10px;
        text-align: justify;
    }

    ul {
        margin-left: 20px;
        margin-bottom: 10px;
    }
    
    li {
        margin-bottom: 5px;
    }
    
    strong {
        color: #000;
        font-weight: bold;
    }

    /* Table Styles */
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 15px;
        margin-bottom: 20px;
        border: 1px solid #ddd;
    }
    
    th {
        background-color: #f2f2f2;
        color: #333;
        font-weight: bold;
        padding: 8px;
        text-align: left;
        border: 1px solid #ddd;
    }
    
    td {
        padding: 8px;
        border: 1px solid #ddd;
        vertical-align: top;
    }

    /* Code Blocks */
    pre {
        background-color: #f8f8f8;
        border: 1px solid #ddd;
        padding: 10px;
        font-family: 'Courier New', monospace;
        font-size: 10pt;
        white-space: pre-wrap;
        margin-bottom: 15px;
    }

    code {
        font-family: 'Courier New', monospace;
        background-color: #f4f4f4;
        padding: 2px 4px;
        border-radius: 3px;
    }
    """

    try:
        print(f"Reading markdown from: {input_md_path}")
        with open(input_md_path, 'r', encoding='utf-8') as f:
            md_content = f.read()

        print("Converting to HTML...")
        # Enable extensions for tables and code blocks
        html_body = markdown.markdown(md_content, extensions=['tables', 'fenced_code', 'attr_list', 'nl2br'])

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
            <div id="footerContent" style="text-align: right; color: #888; font-size: 9pt;">
                Page <pdf:pagenumber>
            </div>
        </body>
        </html>
        """

        print(f"Generating PDF to: {output_pdf_path}")
        with open(output_pdf_path, "wb") as pdf_file:
            pisa_status = pisa.CreatePDF(
                full_html,
                dest=pdf_file
            )

        if pisa_status.err:
            print(f"ERROR: Failed to generate PDF. err: {pisa_status.err}")
        else:
            print("SUCCESS: PDF generated successfully.")

    except Exception as e:
        print(f"ERROR: Failed to generate PDF. Reason: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    if len(sys.argv) < 3:
        # Default behavior for easy testing
        input_file = "Phase_1_Basics.md"
        output_file = "Phase_1_Basics_Study_Guide.pdf"
        if os.path.exists(input_file):
            print(f"No arguments provided. Defaulting to {input_file} -> {output_file}")
            generate_pdf(input_file, output_file)
        else:
            print("Usage: python generate_study_guide.py <input_md_file> <output_pdf_file>")
    else:
        generate_pdf(sys.argv[1], sys.argv[2])
