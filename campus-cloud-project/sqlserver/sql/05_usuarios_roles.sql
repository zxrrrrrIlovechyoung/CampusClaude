-- 05_usuarios_roles.sql
-- Logins, usuarios, roles y privilegios diferenciados en SQL Server.
-- Ejecutar con sqlcmd y variables seguras, por ejemplo:
-- sqlcmd -v CC_ADMIN_PASSWORD="<local>" CC_OPERADOR_PASSWORD="<local>" CC_CONSULTA_PASSWORD="<local>" CC_REMOTO_PASSWORD="<local>"
-- Nunca escribas contraseñas reales en este archivo ni las publiques en Git.

USE master;
GO

IF NOT EXISTS (SELECT 1 FROM sys.sql_logins WHERE name = N'cc_admin')
    CREATE LOGIN cc_admin WITH PASSWORD = '$(CC_ADMIN_PASSWORD)', CHECK_POLICY = OFF;
GO

IF NOT EXISTS (SELECT 1 FROM sys.sql_logins WHERE name = N'cc_operador')
    CREATE LOGIN cc_operador WITH PASSWORD = '$(CC_OPERADOR_PASSWORD)', CHECK_POLICY = OFF;
GO

IF NOT EXISTS (SELECT 1 FROM sys.sql_logins WHERE name = N'cc_consulta')
    CREATE LOGIN cc_consulta WITH PASSWORD = '$(CC_CONSULTA_PASSWORD)', CHECK_POLICY = OFF;
GO

IF NOT EXISTS (SELECT 1 FROM sys.sql_logins WHERE name = N'marianofool')
    CREATE LOGIN marianofool WITH PASSWORD = '$(CC_REMOTO_PASSWORD)', CHECK_POLICY = OFF;
GO

USE CampusCloud;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'rol_administrador')
    CREATE ROLE rol_administrador;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'rol_operador')
    CREATE ROLE rol_operador;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'rol_consulta')
    CREATE ROLE rol_consulta;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'rol_remoto_limitado')
    CREATE ROLE rol_remoto_limitado;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'cc_admin')
    CREATE USER cc_admin FOR LOGIN cc_admin;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'cc_operador')
    CREATE USER cc_operador FOR LOGIN cc_operador;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'cc_consulta')
    CREATE USER cc_consulta FOR LOGIN cc_consulta;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'marianofool')
    CREATE USER marianofool FOR LOGIN marianofool;
GO

ALTER ROLE rol_administrador ADD MEMBER cc_admin;
ALTER ROLE rol_operador ADD MEMBER cc_operador;
ALTER ROLE rol_consulta ADD MEMBER cc_consulta;
ALTER ROLE rol_remoto_limitado ADD MEMBER marianofool;
GO

GRANT CONTROL ON DATABASE::CampusCloud TO rol_administrador;

GRANT SELECT, INSERT, UPDATE ON dbo.Estudiantes TO rol_operador;
GRANT SELECT, INSERT, UPDATE ON dbo.Servicios TO rol_operador;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Solicitudes TO rol_operador;

GRANT SELECT ON dbo.Estudiantes TO rol_consulta;
GRANT SELECT ON dbo.Servicios TO rol_consulta;
GRANT SELECT ON dbo.Solicitudes TO rol_consulta;

GRANT SELECT ON dbo.Servicios TO rol_remoto_limitado;
GRANT SELECT ON dbo.Solicitudes TO rol_remoto_limitado;
DENY SELECT ON dbo.Estudiantes TO rol_remoto_limitado;
DENY INSERT ON dbo.Estudiantes TO rol_remoto_limitado;
DENY INSERT ON dbo.Servicios TO rol_remoto_limitado;
DENY INSERT ON dbo.Solicitudes TO rol_remoto_limitado;
GO
