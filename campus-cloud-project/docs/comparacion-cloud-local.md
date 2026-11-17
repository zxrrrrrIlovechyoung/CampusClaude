# Comparación local y servicios administrados

La implementación local usa Docker Compose: el estudiante administra imágenes, contenedores, red, volúmenes, actualizaciones, credenciales y respaldos.

En un entorno administrado, el proveedor cloud opera parte de la infraestructura, pero el cliente sigue definiendo el modelo, las claves, los índices, permisos, datos, consultas y costos.

| Necesidad | AWS | Azure | Google Cloud | Responsabilidad del cliente |
|---|---|---|---|---|
| Documentos | Amazon DocumentDB o MongoDB Atlas sobre AWS | Azure Cosmos DB (API compatible con MongoDB) | MongoDB Atlas en Google Cloud | Modelo documental, índices y consultas |
| Grafos | Amazon Neptune | Azure Cosmos DB Gremlin | Neo4j Aura en Google Cloud | Modelo de nodos, relaciones y Cypher/Gremlin |
| Columnas anchas | Amazon Keyspaces o Cassandra administrado | Azure Managed Instance for Apache Cassandra | Bigtable o Cassandra administrado por un tercero | Claves de partición, consultas y distribución |
| Relacional | Amazon RDS for SQL Server | Azure SQL Managed Instance | Cloud SQL/SQL Server según disponibilidad | Esquema, transacciones y permisos |

No existe una equivalencia uno a uno entre todos los servicios. La Nube Académica Local y Docker requieren administrar más infraestructura; los servicios administrados reducen la operación del servidor, pero no eliminan las responsabilidades de diseño, seguridad y control de costos.
