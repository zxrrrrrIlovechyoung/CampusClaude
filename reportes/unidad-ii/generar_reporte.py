from pathlib import Path
from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER, TA_LEFT
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch
from reportlab.platypus import (
    BaseDocTemplate, Frame, PageTemplate, Paragraph, Spacer, PageBreak,
    Table, TableStyle, Image, KeepTogether
)
from reportlab.lib.utils import ImageReader


PROJECT = Path(__file__).resolve().parents[2]
EVIDENCE = PROJECT / "campus-cloud-project" / "evidencias" / "unidad-ii"
OUTPUT = PROJECT / "output" / "pdf" / "Cruz_Raul_ReportePracticas_NoSQL.pdf"

BLUE = colors.HexColor("#234a68")
LIGHT_BLUE = colors.HexColor("#e8f0f5")
GRAY = colors.HexColor("#5b6570")
LIGHT_GRAY = colors.HexColor("#f3f5f6")


def find(folder: str, pattern: str) -> Path:
    matches = sorted((EVIDENCE / folder).glob(pattern))
    if not matches:
        raise FileNotFoundError(f"No se encontro evidencia: {folder}/{pattern}")
    return matches[0]


def img(path: Path, max_width=6.55 * inch, max_height=4.55 * inch):
    reader = ImageReader(str(path))
    width, height = reader.getSize()
    scale = min(max_width / width, max_height / height)
    image = Image(str(path), width=width * scale, height=height * scale)
    image.hAlign = "CENTER"
    return image


def evidence(folder: str, pattern: str, caption: str, max_height=4.4 * inch):
    path = find(folder, pattern)
    return [
        img(path, max_height=max_height),
        Paragraph(caption, STYLES["Caption"]),
        Spacer(1, 8),
    ]


def on_page(canvas, doc):
    canvas.saveState()
    width, height = letter
    canvas.setStrokeColor(colors.HexColor("#d6dde2"))
    canvas.line(0.55 * inch, height - 0.55 * inch, width - 0.55 * inch, height - 0.55 * inch)
    canvas.setFont("Helvetica", 8)
    canvas.setFillColor(GRAY)
    canvas.drawString(0.55 * inch, height - 0.42 * inch, "CampusCloud - Practicas NoSQL - Unidad II")
    canvas.drawRightString(width - 0.55 * inch, 0.38 * inch, f"Pagina {doc.page}")
    canvas.restoreState()


STYLES = getSampleStyleSheet()
STYLES.add(ParagraphStyle(
    name="ReportTitle", parent=STYLES["Title"], fontName="Helvetica-Bold",
    fontSize=21, leading=25, alignment=TA_CENTER, textColor=BLUE, spaceAfter=12
))
STYLES.add(ParagraphStyle(
    name="Subtitle", parent=STYLES["Normal"], fontName="Helvetica",
    fontSize=11, leading=15, alignment=TA_CENTER, textColor=GRAY, spaceAfter=18
))
STYLES.add(ParagraphStyle(
    name="H1Local", parent=STYLES["Heading1"], fontName="Helvetica-Bold",
    fontSize=15, leading=18, textColor=BLUE, spaceBefore=0, spaceAfter=9
))
STYLES.add(ParagraphStyle(
    name="H2Local", parent=STYLES["Heading2"], fontName="Helvetica-Bold",
    fontSize=11, leading=14, textColor=BLUE, spaceBefore=8, spaceAfter=5
))
STYLES.add(ParagraphStyle(
    name="BodyLocal", parent=STYLES["BodyText"], fontName="Helvetica",
    fontSize=9.5, leading=13, alignment=TA_LEFT, textColor=colors.HexColor("#20252a"),
    spaceAfter=7
))
STYLES.add(ParagraphStyle(
    name="SmallLocal", parent=STYLES["BodyText"], fontName="Helvetica",
    fontSize=8.5, leading=11, textColor=GRAY, spaceAfter=5
))
STYLES.add(ParagraphStyle(
    name="Caption", parent=STYLES["BodyText"], fontName="Helvetica-Oblique",
    fontSize=8, leading=10, alignment=TA_CENTER, textColor=GRAY, spaceAfter=5
))


def p(text, style="BodyLocal"):
    return Paragraph(text, STYLES[style])


def table(data, widths):
    t = Table(data, colWidths=widths, repeatRows=1)
    t.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), BLUE),
        ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
        ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
        ("FONTNAME", (0, 1), (-1, -1), "Helvetica"),
        ("FONTSIZE", (0, 0), (-1, -1), 8.3),
        ("LEADING", (0, 0), (-1, -1), 10),
        ("GRID", (0, 0), (-1, -1), 0.35, colors.HexColor("#c7d0d7")),
        ("VALIGN", (0, 0), (-1, -1), "TOP"),
        ("ROWBACKGROUNDS", (0, 1), (-1, -1), [colors.white, LIGHT_GRAY]),
        ("LEFTPADDING", (0, 0), (-1, -1), 5),
        ("RIGHTPADDING", (0, 0), (-1, -1), 5),
        ("TOPPADDING", (0, 0), (-1, -1), 5),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 5),
    ]))
    return t


def build():
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    doc = BaseDocTemplate(
        str(OUTPUT), pagesize=letter,
        leftMargin=0.55 * inch, rightMargin=0.55 * inch,
        topMargin=0.72 * inch, bottomMargin=0.62 * inch,
        title="Reporte de Practicas NoSQL CampusCloud",
        author="Raul Cruz",
    )
    frame = Frame(doc.leftMargin, doc.bottomMargin, doc.width, doc.height, id="normal")
    doc.addPageTemplates([PageTemplate(id="main", frames=[frame], onPage=on_page)])

    story = []

    # 1. Portada y resumen
    story += [Spacer(1, 0.55 * inch), p("Reporte tecnico de practicas NoSQL", "ReportTitle"),
              p("CampusCloud - Unidad II", "Subtitle"), Spacer(1, 0.12 * inch)]
    story.append(table([
        ["Dato", "Descripcion"],
        ["Estudiante", "Raul Cruz"],
        ["Proyecto", "CampusCloud"],
        ["Motores", "MongoDB, Neo4j y Cassandra"],
        ["Modalidad", "Despliegue local con Docker Compose"],
        ["Fecha de cierre", "16 de noviembre de 2026"],
    ], [1.55 * inch, 5.0 * inch]))
    story += [Spacer(1, 16), p("Resumen", "H1Local"),
              p("Este reporte documenta la ampliacion de CampusCloud con tres motores NoSQL. MongoDB se uso para detalles semiestructurados de servicios; Neo4j para relaciones entre estudiantes y servicios; y Cassandra para una bitacora de eventos consultada por estudiante y periodo. Las pruebas se ejecutaron en contenedores locales y las capturas incluidas muestran las salidas obtenidas.")]
    story.append(table([
        ["Practica", "Resultado comprobado"],
        ["MongoDB", "Coleccion, documentos, filtros, actualizacion, eliminacion, agregacion, Compass y persistencia."],
        ["Neo4j", "5 estudiantes, 4 servicios, 8 relaciones, consultas Cypher, actualizacion y persistencia."],
        ["Cassandra", "Keyspace, tabla, 12 eventos, consulta por intervalo, actualizacion, eliminacion y persistencia."],
        ["Operacion", "Compose validado, conectividad, seguridad basica y recuperacion de una incidencia de Docker."],
    ], [1.25 * inch, 5.3 * inch]))
    story += [Spacer(1, 12), p("Todos los datos usados son ficticios y las credenciales locales se mantienen fuera de este reporte y del paquete final.", "SmallLocal"), PageBreak()]

    # 2. Arquitectura y despliegue
    story += [p("1. Arquitectura y despliegue local", "H1Local"),
              p("La arquitectura conserva el modelo relacional de la Unidad I y agrega persistencia especializada. Cada motor tiene su propio contenedor, volumen y funcion de consulta. La red externa campuscloud_net permite que los servicios se comuniquen sin mezclar sus estructuras internas."),
              table([
                  ["Necesidad", "Motor", "Modelo"],
                  ["Transacciones academicas", "SQL Server", "Relacional"],
                  ["Detalles variables de servicios", "MongoDB", "Documentos"],
                  ["Conexiones y recomendaciones", "Neo4j", "Grafo"],
                  ["Bitacora de eventos", "Cassandra", "Columnas anchas"],
              ], [2.25 * inch, 1.25 * inch, 3.05 * inch]),
              Spacer(1, 10), p("El despliegue se realizo con Docker Compose y volumenes persistentes. Se validaron los servicios con docker compose config y docker ps, y se conservaron los volumenes durante las comprobaciones de reinicio."),
              p("Seguridad aplicada", "H2Local"),
              p("El archivo .env se usa solamente de forma local y esta excluido por .gitignore. El repositorio contiene .env.example con valores de ejemplo. Las capturas finales no muestran contrasenas. La captura que contenia una clave fue retirada de la carpeta destinada a la entrega."),
              Spacer(1, 8)]
    story += evidence("generales", "01-compose-config.png", "Evidencia general 1. Validacion de la configuracion Compose sin exponer credenciales.", 3.3 * inch)
    story.append(PageBreak())

    # 3. MongoDB operations
    story += [p("2. Practica 1: MongoDB", "H1Local"),
              p("MongoDB se configuro como sector documental para almacenar detalles de servicios de CampusCloud. La coleccion contiene documentos con campos variables, arreglos y un subdocumento de contacto. La operacion se hizo sobre la base campuscloud."),
              p("Operaciones realizadas", "H2Local"),
              p("1) Creacion de la coleccion e indice. 2) Insercion de seis registros ficticios. 3) Filtros por tipo, modalidad y capacidad. 4) Actualizacion de un registro. 5) Eliminacion por identificador. 6) Agregacion para resumir por tipo de servicio."),
              Spacer(1, 5)]
    story += evidence("mongodb", "02.png", "Evidencia MongoDB 1. Insercion de documentos con arreglos y subdocumentos.", 3.15 * inch)
    story += evidence("mongodb", "03.png", "Evidencia MongoDB 2. Consultas de filtrado con resultados visibles.", 2.05 * inch)
    story.append(PageBreak())

    # 4. MongoDB Compass and persistence
    story += [p("MongoDB: actualizacion, agregacion y persistencia", "H1Local"),
              p("Las salidas de consola muestran que la actualizacion encontro y modifico el documento esperado. La eliminacion se comprobo con el contador de documentos eliminados y la agregacion genero un resumen agrupado por tipo de servicio."),
              p("La conexion desde MongoDB Compass se realizo con autenticacion y permitio navegar la base campuscloud, la coleccion detalles_servicio y sus documentos. Esta comprobacion complementa la ejecucion por mongosh."),
              Spacer(1, 4)]
    story += evidence("mongodb", "06.png", "Evidencia MongoDB 3. Agregacion de datos por tipo de servicio.", 2.65 * inch)
    story += evidence("mongodb", "07 compass documentos.png", "Evidencia MongoDB 4. MongoDB Compass conectado y mostrando documentos persistidos.", 2.75 * inch)
    story.append(PageBreak())

    # 5. Neo4j model and queries
    story += [p("3. Practica 2: Neo4j", "H1Local"),
              p("Neo4j representa la red de CampusCloud mediante nodos Estudiante y Servicio unidos por la relacion USA. El modelo se eligio porque permite consultar conexiones y generar recomendaciones a partir de servicios compartidos."),
              table([
                  ["Elemento", "Cantidad comprobada"],
                  ["Nodos Estudiante", "5"],
                  ["Nodos Servicio", "4"],
                  ["Relaciones USA", "8"],
                  ["Consultas", "Servicios de un estudiante; estudiantes que comparten servicio; recomendacion."],
              ], [2.2 * inch, 4.35 * inch]),
              Spacer(1, 8),
              p("Las consultas Cypher se ejecutaron en el contenedor Neo4j. La actualizacion cambio la capacidad del servicio de laboratorio y la comprobacion posterior al reinicio confirmo la permanencia de los nodos.")]
    story += evidence("neo4j", "01.png", "Evidencia Neo4j 1. Conteo de relaciones por estudiante y servicios identificados.", 2.9 * inch)
    story += evidence("neo4j", "02.png", "Evidencia Neo4j 2. Consultas Cypher sobre uso, coincidencias y recomendacion.", 2.35 * inch)
    story.append(PageBreak())

    # 6. Neo4j graph, update, persistence
    story += [p("Neo4j: visualizacion y persistencia", "H1Local"),
              p("La visualizacion del navegador Neo4j muestra 9 nodos en total: 5 estudiantes y 4 servicios. Tambien muestra 8 relaciones USA, lo que permite verificar de manera visual la estructura solicitada."),
              Spacer(1, 3)]
    story += evidence("neo4j", "05 grafos .png", "Evidencia Neo4j 3. Grafo visual con 9 nodos y 8 relaciones.", 3.55 * inch)
    story += evidence("neo4j", "03 actualizaciones.png", "Evidencia Neo4j 4. Actualizacion de la capacidad del servicio de laboratorio.", 1.65 * inch)
    story += evidence("neo4j", "04 persistencia.png", "Evidencia Neo4j 5. Conteo de etiquetas despues del reinicio.", 1.55 * inch)
    story.append(PageBreak())

    # 7. Cassandra model and operations
    story += [p("4. Practica 3: Cassandra", "H1Local"),
              p("Se selecciono Cassandra para el sector de columnas anchas. La tabla fue disenada a partir de la consulta principal: recuperar eventos de un estudiante dentro de un intervalo. Por eso student_id es la clave de particion y event_day/event_time ayudan a ordenar y acotar los resultados."),
              table([
                  ["Elemento", "Resultado"],
                  ["Keyspace", "campuscloud_logs"],
                  ["Tabla", "eventos_campuscloud"],
                  ["Datos", "12 eventos ficticios distribuidos entre 3 estudiantes"],
                  ["Operaciones", "Insercion, consulta por periodo, actualizacion y eliminacion"],
              ], [1.55 * inch, 5.0 * inch]),
              Spacer(1, 8)]
    story += evidence("cassandra", "02 insercion de los eventos.png", "Evidencia Cassandra 1. Insercion de los eventos de prueba.", 2.35 * inch)
    story += evidence("cassandra", "03 consulta por periodo.png", "Evidencia Cassandra 2. Consulta por estudiante e intervalo de tiempo.", 2.35 * inch)
    story.append(PageBreak())

    # 8. Cassandra and closure
    story += [p("Cassandra: cambios, persistencia y cierre", "H1Local"),
              p("La actualizacion del evento EVT-010 y la eliminacion de EVT-008 se documentaron con estado anterior y posterior. La captura de persistencia confirma que los datos permanecen despues de reiniciar el contenedor sin borrar su volumen."),
              Spacer(1, 3)]
    story += evidence("cassandra", "04 actualizacion antes y despues.png", "Evidencia Cassandra 3. Actualizacion de un evento.", 2.3 * inch)
    story += evidence("cassandra", "06 persistencia definitiva.png", "Evidencia Cassandra 4. Datos disponibles despues del reinicio.", 2.35 * inch)
    story += [p("Incidencia y recuperacion", "H2Local"),
              p("Durante el trabajo Docker Desktop presento una espera temporal de un socket interno. El registro mostro el estado de espera y despues la conexion exitosa. Una vez recuperado Docker, los contenedores de MongoDB y Cassandra quedaron saludables y Neo4j quedo operativo. La captura de esta recuperacion se incluye en las evidencias generales."),
              p("Comparacion local y cloud", "H2Local"),
              p("El despliegue local facilita el aprendizaje y el control directo de imagenes, redes, volumenes y comandos. Un servicio administrado reduce la operacion del servidor, pero mantiene la responsabilidad del cliente sobre el modelo de datos, claves, consultas, permisos y costos."),
              p("Conclusion", "H2Local"),
              p("La ampliacion cumple el objetivo de demostrar persistencia poliglota en CampusCloud. Las pruebas muestran operaciones reales en los tres motores seleccionados y las evidencias permiten relacionar cada criterio con una salida verificable.")]

    doc.build(story)
    print(OUTPUT)


if __name__ == "__main__":
    build()
