# Plan de pruebas y evidencias

Las capturas definitivas se guardan en `evidencias/unidad-ii/` y deben mostrar resultado visible.

## Pruebas generales

| Evidencia | Comprobación |
|---|---|
| `generales/01-compose-config.png` | Compose validado con `docker compose config` |
| `generales/02-conectividad.png` | Contenedores y puertos activos |
| `generales/03-seguridad.png` | `.env` excluido y ausencia de credenciales en scripts |
| `generales/04-incidencia-solucion.png` | Problema real o prueba preventiva documentada |

## MongoDB

1. Crear la colección.
2. Insertar los seis documentos.
3. Ejecutar los tres filtros.
4. Capturar actualización antes y después.
5. Capturar eliminación y su verificación.
6. Capturar agregación por tipo.
7. Reiniciar el contenedor y consultar nuevamente.

## Neo4j

1. Capturar el grafo con 5 estudiantes, 4 servicios y 8 relaciones.
2. Ejecutar las tres consultas Cypher.
3. Capturar modificación de la capacidad del laboratorio.
4. Reiniciar Neo4j y verificar que los nodos continúan disponibles.

## Cassandra

1. Crear keyspace y tabla.
2. Insertar los 12 eventos.
3. Consultar un estudiante dentro de un intervalo.
4. Actualizar el evento `EVT-010`.
5. Eliminar el evento `EVT-008`.
6. Consultar nuevamente para comprobar cada resultado.
