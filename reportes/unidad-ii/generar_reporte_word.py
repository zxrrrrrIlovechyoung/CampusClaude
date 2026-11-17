from pathlib import Path
from docx import Document
from docx.enum.section import WD_SECTION
from docx.enum.style import WD_STYLE_TYPE
from docx.enum.table import WD_CELL_VERTICAL_ALIGNMENT, WD_TABLE_ALIGNMENT
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.oxml import OxmlElement
from docx.oxml.ns import qn
from docx.shared import Inches, Pt, RGBColor


PROJECT = Path(__file__).resolve().parents[2]
EVIDENCE = PROJECT / "campus-cloud-project" / "evidencias" / "unidad-ii"
OUTPUT = PROJECT / "output" / "docx" / "Cruz_Raul_ReportePracticas_NoSQL_editable.docx"

BLUE = "234A68"
LIGHT_GRAY = "F3F5F6"
GRID = "D9D9D9"


def find(folder: str, pattern: str) -> Path:
    matches = sorted((EVIDENCE / folder).glob(pattern))
    if not matches:
        raise FileNotFoundError(f"No se encontro evidencia: {folder}/{pattern}")
    return matches[0]


def shade(cell, fill):
    tc_pr = cell._tc.get_or_add_tcPr()
    shd = tc_pr.find(qn("w:shd"))
    if shd is None:
        shd = OxmlElement("w:shd")
        tc_pr.append(shd)
    shd.set(qn("w:fill"), fill)


def set_cell_border(cell, color=GRID, size="4"):
    tc = cell._tc
    tc_pr = tc.get_or_add_tcPr()
    borders = tc_pr.first_child_found_in("w:tcBorders")
    if borders is None:
        borders = OxmlElement("w:tcBorders")
        tc_pr.append(borders)
    for edge in ("top", "left", "bottom", "right", "insideH", "insideV"):
        tag = "w:" + edge
        element = borders.find(qn(tag))
        if element is None:
            element = OxmlElement(tag)
            borders.append(element)
        element.set(qn("w:val"), "single")
        element.set(qn("w:sz"), size)
        element.set(qn("w:space"), "0")
        element.set(qn("w:color"), color)


def set_cell_margins(cell, top=110, start=130, bottom=110, end=130):
    tc = cell._tc
    tc_pr = tc.get_or_add_tcPr()
    margins = tc_pr.first_child_found_in("w:tcMar")
    if margins is None:
        margins = OxmlElement("w:tcMar")
        tc_pr.append(margins)
    for side, value in (("top", top), ("start", start), ("bottom", bottom), ("end", end)):
        node = margins.find(qn(f"w:{side}"))
        if node is None:
            node = OxmlElement(f"w:{side}")
            margins.append(node)
        node.set(qn("w:w"), str(value))
        node.set(qn("w:type"), "dxa")


def set_cell_text(cell, text, bold=False, color="000000", size=9):
    cell.text = ""
    p = cell.paragraphs[0]
    p.paragraph_format.space_after = Pt(0)
    run = p.add_run(str(text))
    run.bold = bold
    run.font.name = "Arial"
    run.font.size = Pt(size)
    run.font.color.rgb = RGBColor.from_string(color)
    cell.vertical_alignment = WD_CELL_VERTICAL_ALIGNMENT.CENTER


def add_table(doc, rows, widths):
    tbl = doc.add_table(rows=1, cols=len(rows[0]))
    tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    tbl.autofit = False
    # Leave a visible breathing margin on both sides of every table.
    # The previous version used the entire text width, which made tables
    # look attached to the page edges in Word.
    widths = [width * 0.93 for width in widths]
    total_width_twips = int(sum(widths) * 1440)
    tbl_pr = tbl._tbl.tblPr
    tbl_w = tbl_pr.find(qn("w:tblW"))
    if tbl_w is None:
        tbl_w = OxmlElement("w:tblW")
        tbl_pr.append(tbl_w)
    tbl_w.set(qn("w:w"), str(total_width_twips))
    tbl_w.set(qn("w:type"), "dxa")
    layout = tbl_pr.find(qn("w:tblLayout"))
    if layout is None:
        layout = OxmlElement("w:tblLayout")
        tbl_pr.append(layout)
    layout.set(qn("w:type"), "fixed")
    for idx, width in enumerate(widths):
        for cell in tbl.columns[idx].cells:
            cell.width = Inches(width)
            set_cell_margins(cell)
    for j, value in enumerate(rows[0]):
        set_cell_text(tbl.rows[0].cells[j], value, bold=True, color="FFFFFF", size=9)
        shade(tbl.rows[0].cells[j], BLUE)
        set_cell_border(tbl.rows[0].cells[j])
    for i, row in enumerate(rows[1:], start=1):
        cells = tbl.add_row().cells
        for j, value in enumerate(row):
            set_cell_text(cells[j], value, size=9)
            cells[j].width = Inches(widths[j])
            set_cell_margins(cells[j])
            if i % 2 == 0:
                shade(cells[j], LIGHT_GRAY)
            set_cell_border(cells[j])
    doc.add_paragraph().paragraph_format.space_after = Pt(0)
    return tbl


def add_body(doc, text):
    p = doc.add_paragraph(style="Body Text")
    p.add_run(text)
    return p


def add_caption(doc, text):
    p = doc.add_paragraph(style="Caption")
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p.add_run(text)
    return p


def add_evidence(doc, folder, pattern, caption, width=6.15):
    path = find(folder, pattern)
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p.paragraph_format.space_after = Pt(2)
    p.add_run().add_picture(str(path), width=Inches(width))
    add_caption(doc, caption)


def add_heading(doc, text, level=1):
    p = doc.add_paragraph(style=f"Heading {level}")
    p.add_run(text)
    return p


def set_page_number(paragraph):
    paragraph.alignment = WD_ALIGN_PARAGRAPH.RIGHT
    run = paragraph.add_run("Pagina ")
    run.font.size = Pt(8)
    fld = OxmlElement("w:fldSimple")
    fld.set(qn("w:instr"), "PAGE")
    paragraph._p.append(fld)


def build():
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    doc = Document()
    section = doc.sections[0]
    section.top_margin = Inches(0.7)
    section.bottom_margin = Inches(0.65)
    section.left_margin = Inches(0.65)
    section.right_margin = Inches(0.65)
    section.header_distance = Inches(0.3)
    section.footer_distance = Inches(0.3)

    styles = doc.styles
    normal = styles["Normal"]
    normal.font.name = "Arial"
    normal.font.size = Pt(10.5)
    normal.font.color.rgb = RGBColor(0, 0, 0)
    normal.paragraph_format.space_after = Pt(7)
    normal.paragraph_format.line_spacing = 1.08

    for style_name, size, bold in (("Title", 20, True), ("Heading 1", 15, True), ("Heading 2", 11, True)):
        st = styles[style_name]
        st.font.name = "Arial"
        st.font.size = Pt(size)
        st.font.bold = bold
        st.font.color.rgb = RGBColor(0, 0, 0)
        st.paragraph_format.space_before = Pt(6)
        st.paragraph_format.space_after = Pt(7)
    styles["Title"].paragraph_format.alignment = WD_ALIGN_PARAGRAPH.CENTER
    styles["Subtitle"].font.name = "Arial"
    styles["Subtitle"].font.size = Pt(11)
    styles["Subtitle"].font.color.rgb = RGBColor(89, 101, 112)
    styles["Subtitle"].paragraph_format.alignment = WD_ALIGN_PARAGRAPH.CENTER
    styles["Caption"].font.name = "Arial"
    styles["Caption"].font.size = Pt(8)
    styles["Caption"].font.italic = True
    styles["Caption"].font.color.rgb = RGBColor(89, 101, 112)

    header = section.header.paragraphs[0]
    header.text = "CampusCloud - Practicas NoSQL - Unidad II"
    header.runs[0].font.name = "Arial"
    header.runs[0].font.size = Pt(8)
    header.runs[0].font.color.rgb = RGBColor(89, 101, 112)
    footer = section.footer.paragraphs[0]
    set_page_number(footer)

    # 1. Portada y resumen
    doc.add_paragraph("Reporte tecnico de practicas NoSQL", style="Title")
    doc.add_paragraph("CampusCloud - Unidad II", style="Subtitle")
    add_table(doc, [
        ["Dato", "Descripcion"],
        ["Estudiante", "Raul Cruz"],
        ["Proyecto", "CampusCloud"],
        ["Motores", "MongoDB, Neo4j y Cassandra"],
        ["Modalidad", "Despliegue local con Docker Compose"],
        ["Fecha de cierre", "16 de noviembre de 2026"],
    ], [1.55, 5.65])
    add_heading(doc, "Resumen", 1)
    add_body(doc, "Este reporte documenta la ampliacion de CampusCloud con tres motores NoSQL. MongoDB se uso para detalles semiestructurados de servicios; Neo4j para relaciones entre estudiantes y servicios; y Cassandra para una bitacora de eventos consultada por estudiante y periodo. Las pruebas se ejecutaron en contenedores locales y las capturas incluidas muestran las salidas obtenidas.")
    add_table(doc, [
        ["Practica", "Resultado comprobado"],
        ["MongoDB", "Coleccion, documentos, filtros, actualizacion, eliminacion, agregacion, Compass y persistencia."],
        ["Neo4j", "5 estudiantes, 4 servicios, 8 relaciones, consultas Cypher, actualizacion y persistencia."],
        ["Cassandra", "Keyspace, tabla, 12 eventos, consulta por intervalo, actualizacion, eliminacion y persistencia."],
        ["Operacion", "Compose validado, conectividad, seguridad basica y recuperacion de una incidencia de Docker."],
    ], [1.25, 5.95])
    add_body(doc, "Todos los datos usados son ficticios y las credenciales locales se mantienen fuera de este reporte y del paquete final.")
    doc.add_page_break()

    # 2. Arquitectura y despliegue
    add_heading(doc, "1. Arquitectura y despliegue local", 1)
    add_body(doc, "La arquitectura conserva el modelo relacional de la Unidad I y agrega persistencia especializada. Cada motor tiene su propio contenedor, volumen y funcion de consulta. La red externa campuscloud_net permite que los servicios se comuniquen sin mezclar sus estructuras internas.")
    add_table(doc, [
        ["Necesidad", "Motor", "Modelo"],
        ["Transacciones academicas", "SQL Server", "Relacional"],
        ["Detalles variables de servicios", "MongoDB", "Documentos"],
        ["Conexiones y recomendaciones", "Neo4j", "Grafo"],
        ["Bitacora de eventos", "Cassandra", "Columnas anchas"],
    ], [2.55, 1.35, 3.3])
    add_body(doc, "El despliegue se realizo con Docker Compose y volumenes persistentes. Se validaron los servicios con docker compose config y docker ps, y se conservaron los volumenes durante las comprobaciones de reinicio.")
    add_heading(doc, "Seguridad aplicada", 2)
    add_body(doc, "El archivo .env se usa solamente de forma local y esta excluido por .gitignore. El repositorio contiene .env.example con valores de ejemplo. Las capturas finales no muestran contrasenas. La captura que contenia una clave fue retirada de la carpeta destinada a la entrega.")
    add_evidence(doc, "generales", "01-compose-config.png", "Evidencia general 1. Validacion de la configuracion Compose sin exponer credenciales.", 6.1)
    doc.add_page_break()

    # 3. MongoDB
    add_heading(doc, "2. Practica 1 MongoDB", 1)
    add_body(doc, "MongoDB se configuro como sector documental para almacenar detalles de servicios de CampusCloud. La coleccion contiene documentos con campos variables, arreglos y un subdocumento de contacto. La operacion se hizo sobre la base campuscloud.")
    add_heading(doc, "Operaciones realizadas", 2)
    add_body(doc, "1) Creacion de la coleccion e indice. 2) Insercion de seis registros ficticios. 3) Filtros por tipo, modalidad y capacidad. 4) Actualizacion de un registro. 5) Eliminacion por identificador. 6) Agregacion para resumir por tipo de servicio.")
    add_evidence(doc, "mongodb", "02.png", "Evidencia MongoDB 1. Insercion de documentos con arreglos y subdocumentos.", 6.1)
    add_evidence(doc, "mongodb", "03.png", "Evidencia MongoDB 2. Consultas de filtrado con resultados visibles.", 6.1)
    doc.add_page_break()

    add_heading(doc, "MongoDB actualizacion agregacion y persistencia", 1)
    add_body(doc, "Las salidas de consola muestran que la actualizacion encontro y modifico el documento esperado. La eliminacion se comprobo con el contador de documentos eliminados y la agregacion genero un resumen agrupado por tipo de servicio.")
    add_body(doc, "La conexion desde MongoDB Compass se realizo con autenticacion y permitio navegar la base campuscloud, la coleccion detalles_servicio y sus documentos. Esta comprobacion complementa la ejecucion por mongosh.")
    add_evidence(doc, "mongodb", "06.png", "Evidencia MongoDB 3. Agregacion de datos por tipo de servicio.", 6.1)
    add_evidence(doc, "mongodb", "07 compass documentos.png", "Evidencia MongoDB 4. MongoDB Compass conectado y mostrando documentos persistidos.", 6.1)
    doc.add_page_break()

    # 5. Neo4j
    add_heading(doc, "3. Practica 2 Neo4j", 1)
    add_body(doc, "Neo4j representa la red de CampusCloud mediante nodos Estudiante y Servicio unidos por la relacion USA. El modelo se eligio porque permite consultar conexiones y generar recomendaciones a partir de servicios compartidos.")
    add_table(doc, [
        ["Elemento", "Cantidad comprobada"],
        ["Nodos Estudiante", "5"],
        ["Nodos Servicio", "4"],
        ["Relaciones USA", "8"],
        ["Consultas", "Servicios de un estudiante; estudiantes que comparten servicio; recomendacion."],
    ], [2.25, 4.95])
    add_body(doc, "Las consultas Cypher se ejecutaron en el contenedor Neo4j. La actualizacion cambio la capacidad del servicio de laboratorio y la comprobacion posterior al reinicio confirmo la permanencia de los nodos.")
    add_evidence(doc, "neo4j", "01.png", "Evidencia Neo4j 1. Conteo de relaciones por estudiante y servicios identificados.", 6.1)
    add_evidence(doc, "neo4j", "02.png", "Evidencia Neo4j 2. Consultas Cypher sobre uso, coincidencias y recomendacion.", 6.1)
    doc.add_page_break()

    add_heading(doc, "Neo4j visualizacion y persistencia", 1)
    add_body(doc, "La visualizacion del navegador Neo4j muestra 9 nodos en total: 5 estudiantes y 4 servicios. Tambien muestra 8 relaciones USA, lo que permite verificar de manera visual la estructura solicitada.")
    add_evidence(doc, "neo4j", "05 grafos .png", "Evidencia Neo4j 3. Grafo visual con 9 nodos y 8 relaciones.", 6.1)
    add_evidence(doc, "neo4j", "03 actualizaciones.png", "Evidencia Neo4j 4. Actualizacion de la capacidad del servicio de laboratorio.", 6.1)
    add_evidence(doc, "neo4j", "04 persistencia.png", "Evidencia Neo4j 5. Conteo de etiquetas despues del reinicio.", 6.1)
    doc.add_page_break()

    # 7. Cassandra
    add_heading(doc, "4. Practica 3 Cassandra", 1)
    add_body(doc, "Se selecciono Cassandra para el sector de columnas anchas. La tabla fue disenada a partir de la consulta principal: recuperar eventos de un estudiante dentro de un intervalo. Por eso student_id es la clave de particion y event_day/event_time ayudan a ordenar y acotar los resultados.")
    add_table(doc, [
        ["Elemento", "Resultado"],
        ["Keyspace", "campuscloud_logs"],
        ["Tabla", "eventos_campuscloud"],
        ["Datos", "12 eventos ficticios distribuidos entre 3 estudiantes"],
        ["Operaciones", "Insercion, consulta por periodo, actualizacion y eliminacion"],
    ], [1.55, 5.65])
    add_evidence(doc, "cassandra", "02 insercion de los eventos.png", "Evidencia Cassandra 1. Insercion de los eventos de prueba.", 6.1)
    add_evidence(doc, "cassandra", "03 consulta por periodo.png", "Evidencia Cassandra 2. Consulta por estudiante e intervalo de tiempo.", 6.1)
    doc.add_page_break()

    add_heading(doc, "Cassandra cambios persistencia y cierre", 1)
    add_body(doc, "La actualizacion del evento EVT-010 y la eliminacion de EVT-008 se documentaron con estado anterior y posterior. La captura de persistencia confirma que los datos permanecen despues de reiniciar el contenedor sin borrar su volumen.")
    add_evidence(doc, "cassandra", "04 actualizacion antes y despues.png", "Evidencia Cassandra 3. Actualizacion de un evento.", 6.1)
    add_evidence(doc, "cassandra", "06 persistencia definitiva.png", "Evidencia Cassandra 4. Datos disponibles despues del reinicio.", 6.1)
    add_heading(doc, "Incidencia y recuperacion", 2)
    add_body(doc, "Durante el trabajo Docker Desktop presento una espera temporal de un socket interno. El registro mostro el estado de espera y despues la conexion exitosa. Una vez recuperado Docker, los contenedores de MongoDB y Cassandra quedaron saludables y Neo4j quedo operativo. La captura de esta recuperacion se incluye en las evidencias generales.")
    add_heading(doc, "Comparacion local y cloud", 2)
    add_body(doc, "El despliegue local facilita el aprendizaje y el control directo de imagenes, redes, volumenes y comandos. Un servicio administrado reduce la operacion del servidor, pero mantiene la responsabilidad del cliente sobre el modelo de datos, claves, consultas, permisos y costos.")
    add_heading(doc, "Conclusion", 2)
    add_body(doc, "La ampliacion cumple el objetivo de demostrar persistencia poliglota en CampusCloud. Las pruebas muestran operaciones reales en los tres motores seleccionados y las evidencias permiten relacionar cada criterio con una salida verificable.")

    doc.save(str(OUTPUT))
    print(OUTPUT)


if __name__ == "__main__":
    build()
