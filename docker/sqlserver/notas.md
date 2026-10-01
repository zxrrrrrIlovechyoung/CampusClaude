# notas
## comandos de creacion de carpetas y archivos del proyecto


´´´bash
# CampusCloud

Proyecto académico de la asignatura Bases de Datos en la Nube.

## Objetivo

Construir progresivamente una Nube Académica Local que permita comprender:

- bases de datos relacionales;
- bases de datos NoSQL;
- persistencia;
- usuarios, roles y privilegios;
- conexión local y remota;
- integración mediante API;
- Docker y Docker Compose como herramientas de soporte.

## Unidad I

Primera implementación:

PC → Docker → SQL Server → Volumen → CampusCloud

Tecnología inicial:

- Docker Desktop
- SQL Server 2025
- Cliente SQL
- Git
- Visual Studio Code

mkdir CampusCloud 
cd CampusCloud

mkdir docs
mkdir docker
mkdir docker\sqlserver
mkdir compose
mkdir sql
mkdir evidencias

New-Item README.md
New-Item .gitignore
New-Item docs\bitacora.md
New-Item docs\arquitectura.md
New-Item docker\sqlserver\docker-run.ps1
New-Item docker\sqlserver\.env.example
New-Item docker\sqlserver\notas.md
New-Item compose\docker-compose.yml
New-Item sql\01-create-database.sql
New-Item sql\02-create-tables.sql
New-Item sql\03-insert-data.sql
New-Item sql\04-queries.sql
New-Item sql\05-security.sql