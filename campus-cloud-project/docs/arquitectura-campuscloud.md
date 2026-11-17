# Arquitectura de persistencia de CampusCloud

CampusCloud utiliza persistencia políglota. SQL Server conserva las entidades transaccionales de la Unidad I: `Estudiantes`, `Servicios` y `Solicitudes`. Los motores NoSQL complementan esas tablas sin sustituirlas ni duplicar indiscriminadamente su información.

| Necesidad | Motor | Información almacenada |
|---|---|---|
| Operaciones académicas y solicitudes | SQL Server | Datos relacionales, integridad referencial y transacciones |
| Detalles variables de un servicio | MongoDB | Documentos con arrays y subdocumentos |
| Conexiones y recomendaciones | Neo4j | Nodos y relaciones entre estudiantes y servicios |
| Bitácora de actividad | Cassandra | Eventos consultados por estudiante y periodo |

Todos los contenedores se conectan a la red `campuscloud_net`. Cada gestor mantiene su volumen persistente independiente. La aplicación puede identificar los registros de SQL Server mediante `servicio_id` o `estudiante_id`, mientras que MongoDB, Neo4j y Cassandra guardan únicamente la información especializada de sus consultas.

```text
                         CAMPUSCLOUD
                              |
       -------------------------------------------------
       |                 |              |              |
   SQL Server         MongoDB         Neo4j        Cassandra
 transacciones     documentos       relaciones      eventos
```
