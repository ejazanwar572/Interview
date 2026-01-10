import markdown
from weasyprint import HTML, CSS
import sys
import os

def generate_resume(input_md_path, output_pdf_path):
    # CSS Template from Data_Pipeline_Engineer_Resume.html
    css_styles = """
    @page {
        margin: 0.5in 0.6in;
        size: letter;
    }
    body {
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
        font-size: 10pt;
        line-height: 1.5;
        color: #333;
        max-width: 8.5in;
        margin: 0 auto;
    }
    h1 {
        font-size: 24pt;
        color: #2c3e50;
        border-bottom: 2px solid #2c3e50;
        padding-bottom: 10px;
        margin-top: 0;
        margin-bottom: 10px;
        letter-spacing: 1px;
    }
    h2 {
        font-size: 14pt;
        color: #2980b9; 
        border-bottom: 1px solid #eee;
        padding-bottom: 5px;
        margin-top: 20px;
        margin-bottom: 10px;
        text-transform: uppercase;
        font-weight: 600;
    }
    h3 {
        font-size: 11pt;
        font-weight: 700;
        margin-top: 15px;
        margin-bottom: 3px;
        color: #34495e;
    }
    p {
        margin-bottom: 8px;
        text-align: justify;
    }
    ul {
        padding-left: 1.2em;
        margin-top: 5px;
        margin-bottom: 15px;
        list-style-type: disc;
    }
    li {
        margin-bottom: 6px;
        padding-left: 5px;
        display: list-item;
        text-align: left;
    }
    strong {
        font-weight: 700;
        color: #2c3e50;
    }
    a {
        color: #2980b9;
        text-decoration: none;
    }
    /* Header Contact Info Styling - targets the first paragraph which usually contains contact info */
    p:first-of-type {
         text-align: center;
         font-size: 9pt;
         margin-bottom: 20px;
         color: #7f8c8d;
    }
    """

    try:
        print(f"Reading markdown from: {input_md_path}")
        with open(input_md_path, 'r', encoding='utf-8') as f:
            md_content = f.read()

        print("Converting to HTML...")
        html_body = markdown.markdown(md_content)

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

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python generate_standard_resume.py <input_md_file> <output_pdf_file>")
    else:
        generate_resume(sys.argv[1], sys.argv[2])
