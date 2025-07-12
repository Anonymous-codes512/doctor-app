from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A4
from reportlab.lib.units import inch
from reportlab.lib.utils import ImageReader
import os
from datetime import datetime
from reportlab.lib import colors
from reportlab.lib.utils import simpleSplit


def generate_dictation_pdf(
    file_name,
    doctor_name,
    doctor_email,
    doctor_practice,
    doctor_practice_address,
    patient_name,
    patient_email,
    date,
    time,
    dictation_text
):
    base_folder = os.path.join('static/uploads', 'dictations')
    os.makedirs(base_folder, exist_ok=True)
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    pdf_filename = f"{file_name}_{timestamp}.pdf"
    file_path = os.path.join(base_folder, pdf_filename)

    c = canvas.Canvas(file_path, pagesize=A4)
    width, height = A4

    # Colors
    dark_blue = colors.Color(27/255, 79/255, 114/255)
    light_blue = colors.Color(214/255, 234/255, 248/255)

    # Background Header Strip
    c.setFillColor(light_blue)
    c.rect(0, height - 100, width, 100, fill=1)

    # Logo Image
    try:
        logo_path = os.path.join('static', 'Medical_sign.png')
        logo = ImageReader(logo_path)
        c.drawImage(logo, width - 100, height - 90, width=60, height=60, preserveAspectRatio=True, mask='auto')
    except Exception as e:
        print("⚠️ Image load failed:", e)

    # Doctor Info
    c.setFont("Helvetica-Bold", 18)
    c.setFillColor(dark_blue)
    c.drawString(25, height - 40, f"Dr. {doctor_name}")

    c.setFont("Helvetica", 10)
    c.setFillColor(colors.black)
    c.drawString(25, height - 65, doctor_practice)
    c.drawString(25, height - 80, doctor_practice_address)
    c.drawString(25, height - 95, f"Email: {doctor_email}")

    # Patient + Date Info
    y_cursor = height - 120
    c.setFont("Helvetica", 11)
    c.drawString(25, y_cursor, f"Patient Name: {patient_name}")
    c.drawString(500, y_cursor, f"Date: {date}")
    y_cursor -= 20
    c.drawString(25, y_cursor, f"Email: {patient_email}")
    c.drawString(500, y_cursor, f"Time: {time}")

    # Watermark image
    try:
        c.saveState()
        c.setFillAlpha(0.5)
        c.translate(width / 2 - 100, height / 2 - 140)
        c.drawImage(logo, 0, 0, width=200, height=200, mask='auto')
        c.restoreState()
    except Exception as e:
        print("⚠️ Watermark image failed:", e)


    # Dictation Text Body
    text_y = y_cursor - 100
    text_object = c.beginText(50, text_y)
    text_object.setFont("Helvetica", 12)
    text_object.setFillColor(colors.black)

    max_width = width - 100
    lines = simpleSplit(dictation_text, "Helvetica", 12, max_width)

    for line in lines:
        text_object.textLine(line)

    c.drawText(text_object)


    # Signature Line
    c.line(width - 150, 100, width - 50, 100)
    c.drawString(width - 130, 85, "Signature")

    # Footer Bar
    c.setFillColor(dark_blue)
    c.rect(0, 0, width, 40, fill=1)
    c.setFont("Helvetica", 9)
    c.setFillColor(colors.white)
    c.drawString(25, 15, "HOSPITAL NAME - www.website.com")
    c.drawRightString(width - 50, 15, "Phone: 123-456-789 | Email: hospital@email.com")

    c.showPage()
    c.save()

    return file_path
