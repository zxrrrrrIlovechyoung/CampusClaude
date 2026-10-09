-- 01_creacion_bd.sql
-- Crea la base de datos principal para CampusCloud en SQL Server.

IF DB_ID(N'CampusCloud') IS NULL
BEGIN
    CREATE DATABASE CampusCloud;
END;
GO
