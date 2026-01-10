from markdown_pdf import MarkdownPdf, Section
import os

input_file = '/Users/ejazanwar/Desktop/Interview/Resumes/AppsForBharat_Sr_Product_Analyst_Resume.md'
output_file = '/Users/ejazanwar/Desktop/Interview/Resumes/AppsForBharat_Sr_Product_Analyst_Resume.pdf'

try:
    # Read the markdown content
    with open(input_file, 'r') as f:
        md_content = f.read()

    # Create PDF
    pdf = MarkdownPdf(toc_level=0)
    pdf.add_section(Section(md_content))

    # Save PDF
    pdf.save(output_file)
    print(f"PDF generated successfully: {output_file}")

except ImportError:
    print("Error: markdown_pdf module not found. Please install it using 'pip install markdown-pdf'.")
except Exception as e:
    print(f"An error occurred: {e}")
