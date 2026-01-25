from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, ListFlowable, ListItem
from reportlab.lib.enums import TA_LEFT, TA_CENTER, TA_RIGHT
from reportlab.lib.units import inch

def create_resume(output_path):
    doc = SimpleDocTemplate(
        output_path,
        pagesize=A4,
        rightMargin=0.5*inch,
        leftMargin=0.5*inch,
        topMargin=0.5*inch,
        bottomMargin=0.5*inch
    )
    
    styles = getSampleStyleSheet()
    
    # Custom Styles
    name_style = ParagraphStyle(
        'Name',
        parent=styles['Heading1'],
        fontSize=24,
        alignment=TA_CENTER,
        spaceAfter=10,
        textColor=colors.black
    )
    
    contact_style = ParagraphStyle(
        'Contact',
        parent=styles['Normal'],
        fontSize=10,
        alignment=TA_CENTER,
        spaceAfter=20,
        textColor=colors.black
    )
    
    section_header_style = ParagraphStyle(
        'SectionHeader',
        parent=styles['Heading2'],
        fontSize=14,
        spaceBefore=12,
        spaceAfter=6,
        borderPadding=(0, 0, 5, 0),
        borderColor=colors.black,
        borderWidth=0,
        textColor=colors.black,
        fontName='Helvetica-Bold'
    )
    # Add a bottom border manually using a drawing or just simple underline usage if needed, 
    # but strictly following the user's "distinct headers" preference. 
    # We will simulate a line by adding a horizontal rule or just bold headers.
    
    job_title_style = ParagraphStyle(
        'JobTitle',
        parent=styles['Heading3'],
        fontSize=12,
        spaceBefore=6,
        spaceAfter=2,
        fontName='Helvetica-Bold',
        textColor=colors.black
    )
    
    company_style = ParagraphStyle(
        'Company',
        parent=styles['Normal'],
        fontSize=11,
        fontName='Helvetica-BoldOblique',
        spaceAfter=2,
    )
    
    date_loc_style = ParagraphStyle(
        'DateLoc',
        parent=styles['Normal'],
        fontSize=10,
        alignment=TA_RIGHT,
        fontName='Helvetica-Oblique'
    )

    bullet_style = ParagraphStyle(
        'Bullet',
        parent=styles['Normal'],
        fontSize=10,
        firstLineIndent=0,
        leftIndent=15,
        spaceAfter=3,
        leading=14
    )
    
    story = []

    # --- Header ---
    story.append(Paragraph("Ejaz Anwar", name_style))
    story.append(Paragraph(
        'anwar.ejaz181@gmail.com | 9024293714 | <link href="https://www.linkedin.com/in/ejazanwar95/" color="blue">LinkedIn</link>',
        contact_style
    ))
    
    # --- Professional Summary ---
    story.append(Paragraph("PROFESSIONAL SUMMARY", section_header_style))
    story.append(Paragraph(
        "Results-driven <b>Senior Product Analyst</b> with 6 years of experience in B2C/D2C product startups. "
        "Expert in leveraging data to drive product strategy, optimize user experience, and conduct rigorous <b>A/B testing</b>. "
        "Proficient in <b>SQL, Excel, Tableau</b>, and analyzing complex datasets to uncover actionable insights. "
        "Proven track record of cross-functional collaboration with product, engineering, and business teams to deliver "
        "measurable growth and improve key business metrics.",
        styles['Normal']
    ))
    
    # --- Work Experience ---
    story.append(Paragraph("WORK EXPERIENCE", section_header_style))
    
    # Helper to add job
    def add_job(title, company, date, location, bullets):
        # Table for Title/Company and Date/Location to align them
        data = [
            [Paragraph(title, job_title_style), Paragraph(date, date_loc_style)],
            [Paragraph(company, company_style), Paragraph(location, date_loc_style)]
        ]
        t = Table(data, colWidths=[4.5*inch, 2.5*inch])
        t.setStyle(TableStyle([
            ('VALIGN', (0,0), (-1,-1), 'TOP'),
            ('LEFTPADDING', (0,0), (-1,-1), 0),
            ('RIGHTPADDING', (0,0), (-1,-1), 0),
            ('BOTTOMPADDING', (0,0), (-1,-1), 0),
            ('TOPPADDING', (0,0), (-1,-1), 0),
        ]))
        story.append(t)
        
        for b in bullets:
            story.append(Paragraph(f"• {b}", bullet_style))
        story.append(Spacer(1, 10))

    # PayPal
    add_job(
        "Senior Product Analyst",
        "PayPal",
        "04/23 - Present",
        "Bangalore",
        [
            "<b>Product Performance Analysis:</b> Partnered with Product, Engineering, and Strategy teams to define goals, design A/B tests, and monitor performance metrics, directly influencing product roadmaps.",
            "<b>KPI Management:</b> Developed scalable Tableau dashboards for PayPal Shopping, delivering real-time visibility into 50+ KPIs for 100+ stakeholders, enabling data-backed decisions.",
            "<b>Strategic Planning:</b> Forecasted trends and identified business opportunities, leading to optimized investment priorities.",
            "<b>Cross-Functional Collaboration:</b> Mentored 2 junior analysts on SQL/Python best practices and effective A/B test design."
        ]
    )
    
    # OLX Autos
    add_job(
        "Product Analyst",
        "OLX Autos",
        "07/22 - 03/23",
        "Gurgaon",
        [
            "<b>User Experience Optimization:</b> Reduced Zero Result Pages (ZRP) by 40% through rigorous data-driven A/B testing, significantly improving search engagement.",
            "<b>Feature Launch:</b> Led the analytics for the development and launch of a car comparison feature, driving a 10% increase in lead generation.",
            "<b>User Behavior Analysis:</b> Deeply analyzed customer behavior to identify friction points and support product growth initiatives."
        ]
    )

    # Uber
    add_job(
        "Business Analyst",
        "Uber",
        "08/21 - 07/22",
        "Hyderabad",
        [
            "<b>Automated Reporting:</b> Delivered data-driven insights and automated 35+ BAU reports, saving 5+ hours of manual effort weekly.",
            "<b>Dashboard Creation:</b> Built a dynamic U4B dashboard from scratch using Power BI, Google Sheets, and Python (Pandas) for automated daily data updates.",
            "<b>Stakeholder Management:</b> Partnered with diverse stakeholders to distill complex information into actionable business intelligence."
        ]
    )

    # Aditya Birla
    add_job(
        "Analyst",
        "Aditya Birla",
        "07/18 - 07/21",
        "Bangalore",
        [
            "<b>Process Improvement:</b> Supported production and operations teams by analyzing yield and process efficiency data.",
            "<b>Data Analysis:</b> Identified bottlenecks and recommended cost-saving improvements through detailed inventory data analysis."
        ]
    )

    # --- Education ---
    story.append(Paragraph("EDUCATION", section_header_style))
    add_job(
        "B.Tech - Chemical Engineering",
        "BITS Pilani",
        "2014 - 2018",
        "",
        []
    )
    
    # --- Skills ---
    story.append(Paragraph("SKILLS", section_header_style))
    skills = [
        "<b>Languages & Tools:</b> SQL, Python (Pandas, NumPy), Excel, Tableau, PowerBI, Google Data Studio, Git",
        "<b>Analytics:</b> A/B Testing, User Behavior Analysis, Statistical Analysis, Predictive Modelling, ETL",
        "<b>Platforms:</b> Google Analytics, Adobe Analytics, CleverTap, BigQuery, AWS, GCP, JIRA"
    ]
    for s in skills:
        story.append(Paragraph(f"• {s}", bullet_style))
        
    story.append(Spacer(1, 10))

    # --- Certifications ---
    story.append(Paragraph("CERTIFICATIONS", section_header_style))
    story.append(Paragraph("• Google Data Analytics Certificate - Coursera", bullet_style))

    # Build PDF
    doc.build(story)
    print(f"Resume generated at {output_path}")

if __name__ == "__main__":
    create_resume("/Users/ejazanwar/Desktop/Interview/Ejaz_Anwar_resume.pdf")
