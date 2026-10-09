-- 01_creacion_bd.sql
-- Crea la base de datos principal para CampusCloud.

SELECT 'CREATE DATABASE "CampusCloud"'
WHERE NOT EXISTS (
  SELECT 1
  FROM pg_database
  WHERE datname = 'CampusCloud'
)\gexec
