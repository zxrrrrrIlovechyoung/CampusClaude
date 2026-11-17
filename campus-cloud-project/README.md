# CampusCloud — Prácticas integradas NoSQL

Proyecto de la Unidad II para demostrar MongoDB, Neo4j y Cassandra como complementos especializados de SQL Server. Todos los datos de esta práctica son ficticios.

## Servicios

| Servicio | Contenedor | Puerto local | Uso en la práctica |
|---|---|---:|---|
| SQL Server | `campuscloud-sqlserver` | 1433 | Información relacional heredada de la Unidad I |
| PostgreSQL | `campuscloud-postgres` | 5432 | Servicio auxiliar existente del proyecto |
| MongoDB | `campuscloud-mongo` | 27017 | Detalles flexibles de servicios |
| Neo4j | `campuscloud-neo4j` | 7474 / 7687 | Relaciones entre estudiantes y servicios |
| Cassandra | `campuscloud-cassandra` | 9042 | Eventos consultados por estudiante y periodo |

## Requisitos

- Docker Desktop iniciado.
- Docker Compose v2.
- Un archivo `.env` local basado en `.env.example`.
- No publicar `.env`, contraseñas, volúmenes ni datos personales.

## Preparación inicial

El Compose actual conserva volúmenes y red externos para no perder el trabajo de la Unidad I. En una instalación nueva, crea la red y los volúmenes indicados en tu `.env` antes de levantar el proyecto. Si el entorno ya estaba funcionando, conserva sus nombres actuales.

```powershell
Copy-Item .env.example .env
docker network create campuscloud_net
docker volume create campuscloud-postgres-data
docker volume create campuscloud-pgadmin-data
docker volume create campuscloud-sqlserver-data
docker volume create campuscloud-neo4j-data
docker volume create campuscloud-mongo-data
docker volume create campuscloud-cassandra-data
```

## Operación Docker

Desde `campus-cloud-project/`:

```powershell
docker compose -f docker-compose.yml config --quiet
docker compose -f docker-compose.yml up -d cassandra-cloud mongodb-cloud neo4j-cloud
docker compose -f docker-compose.yml ps
docker compose -f docker-compose.yml logs --tail=80 cassandra-cloud
docker compose -f docker-compose.yml stop cassandra-cloud
```

No es necesario iniciar todos los servicios al mismo tiempo. Para las pruebas de persistencia se detiene y vuelve a iniciar el contenedor sin eliminar su volumen.

## Cassandra

Los scripts están en `cassandra/` y deben ejecutarse en este orden:

```powershell
Get-Content -Raw cassandra/01-keyspace-tabla.cql | docker exec -i campuscloud-cassandra cqlsh
Get-Content -Raw cassandra/02-insertar-eventos.cql | docker exec -i campuscloud-cassandra cqlsh
Get-Content -Raw cassandra/03-consultas.cql | docker exec -i campuscloud-cassandra cqlsh
Get-Content -Raw cassandra/04-actualizar.cql | docker exec -i campuscloud-cassandra cqlsh
Get-Content -Raw cassandra/05-eliminar.cql | docker exec -i campuscloud-cassandra cqlsh
```

La tabla usa `student_id` como clave de partición porque la consulta principal comienza por estudiante. `event_day` y `event_time` son claves de clustering para recuperar los eventos ordenados y acotados a un periodo.

## MongoDB

Los scripts están en `mongodb/`. Sustituye los valores de usuario y contraseña por los de tu `.env` sin escribirlos en los scripts:

```powershell
Get-Content -Raw mongodb/01-crear-coleccion.js | docker exec -i campuscloud-mongo mongosh --quiet --username <USUARIO_ROOT> --password <CONTRASENA_ROOT> --authenticationDatabase admin campuscloud
```

También pueden ejecutarse desde MongoDB Compass usando la base `campuscloud` y una conexión autenticada contra `admin`. La secuencia requerida es creación, inserción, filtros, actualización, eliminación y agregación.

## Neo4j

Abre `http://localhost:7474` con el usuario `neo4j` y la contraseña local definida en `.env`. Ejecuta los archivos de `neo4j/` en este orden:

1. `01-nodos-relaciones.cypher`
2. `02-consultas.cypher`
3. `03-actualizacion.cypher`

La primera consulta crea 5 estudiantes, 4 servicios y 8 relaciones ficticias.

## Evidencias

Las capturas y resultados se guardan en:

```text
evidencias/unidad-ii/mongodb/
evidencias/unidad-ii/neo4j/
evidencias/unidad-ii/cassandra/
evidencias/unidad-ii/generales/
```

Cada captura debe mostrar la operación y su resultado. El reporte técnico final se entrega en `output/pdf/`.

## Seguridad

Los datos son simulados. No se incluyen credenciales reales, archivos `.env`, volúmenes Docker ni información personal. Si una credencial se publica accidentalmente, debe cambiarse y también retirarse del historial del repositorio.
