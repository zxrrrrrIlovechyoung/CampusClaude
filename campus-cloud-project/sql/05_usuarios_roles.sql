-- 05_usuarios_roles.sql
-- Roles y usuarios con privilegios diferenciados.

\connect "CampusCloud"

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'campuscloud_admin') THEN
    CREATE ROLE campuscloud_admin;
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'campuscloud_operador') THEN
    CREATE ROLE campuscloud_operador;
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'campuscloud_consulta') THEN
    CREATE ROLE campuscloud_consulta;
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'campuscloud_remoto_limitado') THEN
    CREATE ROLE campuscloud_remoto_limitado;
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'cc_admin') THEN
    CREATE USER cc_admin WITH PASSWORD 'AdminCampusCloud2026#';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'cc_operador') THEN
    CREATE USER cc_operador WITH PASSWORD 'OperadorCampusCloud2026#';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'cc_consulta') THEN
    CREATE USER cc_consulta WITH PASSWORD 'ConsultaCampusCloud2026#';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'marianofool') THEN
    CREATE USER marianofool WITH PASSWORD 'CompaneroCampusCloud2026#';
  END IF;
END $$;

GRANT CONNECT ON DATABASE "CampusCloud" TO campuscloud_admin, campuscloud_operador, campuscloud_consulta, campuscloud_remoto_limitado;
GRANT USAGE ON SCHEMA public TO campuscloud_admin, campuscloud_operador, campuscloud_consulta, campuscloud_remoto_limitado;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO campuscloud_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO campuscloud_admin;
GRANT CREATE ON SCHEMA public TO campuscloud_admin;

GRANT SELECT, INSERT, UPDATE ON estudiantes, servicios, solicitudes TO campuscloud_operador;
GRANT DELETE ON solicitudes TO campuscloud_operador;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO campuscloud_operador;

GRANT SELECT ON estudiantes, servicios, solicitudes TO campuscloud_consulta;

GRANT SELECT ON servicios, solicitudes TO campuscloud_remoto_limitado;
REVOKE ALL PRIVILEGES ON estudiantes FROM campuscloud_remoto_limitado;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT ALL PRIVILEGES ON TABLES TO campuscloud_admin;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT SELECT, INSERT, UPDATE ON TABLES TO campuscloud_operador;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT SELECT ON TABLES TO campuscloud_consulta;

GRANT campuscloud_admin TO cc_admin;
GRANT campuscloud_operador TO cc_operador;
GRANT campuscloud_consulta TO cc_consulta;
GRANT campuscloud_remoto_limitado TO marianofool;

-- Prueba autorizada: este usuario puede consultar.
-- psql -h localhost -p 5432 -U cc_consulta -d CampusCloud -c "SELECT * FROM estudiantes;"

-- Prueba denegada: este usuario NO debe poder insertar.
-- psql -h localhost -p 5432 -U cc_consulta -d CampusCloud -c "INSERT INTO servicios (nombre_servicio, descripcion) VALUES ('No permitido', 'Debe fallar');"
