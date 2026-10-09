-- 03_datos.sql
-- Datos minimos: 10 estudiantes, 5 servicios y 15 solicitudes.

\connect "CampusCloud"

INSERT INTO estudiantes (matricula, nombre, correo) VALUES
  ('CC260001', 'Ana Martinez Lopez', 'ana.martinez@campuscloud.local'),
  ('CC260002', 'Bruno Hernandez Soto', 'bruno.hernandez@campuscloud.local'),
  ('CC260003', 'Carla Ruiz Torres', 'carla.ruiz@campuscloud.local'),
  ('CC260004', 'Diego Flores Garcia', 'diego.flores@campuscloud.local'),
  ('CC260005', 'Elena Morales Diaz', 'elena.morales@campuscloud.local'),
  ('CC260006', 'Fernando Castro Luna', 'fernando.castro@campuscloud.local'),
  ('CC260007', 'Gabriela Navarro Cruz', 'gabriela.navarro@campuscloud.local'),
  ('CC260008', 'Hugo Ramirez Vega', 'hugo.ramirez@campuscloud.local'),
  ('CC260009', 'Iris Sanchez Rojas', 'iris.sanchez@campuscloud.local'),
  ('CC260010', 'Jorge Mendoza Perez', 'jorge.mendoza@campuscloud.local')
ON CONFLICT (matricula) DO NOTHING;

INSERT INTO servicios (nombre_servicio, descripcion, activo) VALUES
  ('Constancia de estudios', 'Emision de constancia academica para tramites escolares.', TRUE),
  ('Beca academica', 'Solicitud y seguimiento de apoyo economico institucional.', TRUE),
  ('Soporte de plataforma', 'Atencion a problemas de acceso a servicios digitales.', TRUE),
  ('Prestamo bibliotecario', 'Gestion de prestamos y devoluciones de material bibliografico.', TRUE),
  ('Credencial universitaria', 'Reposicion o renovacion de credencial de estudiante.', TRUE)
ON CONFLICT (nombre_servicio) DO NOTHING;

INSERT INTO solicitudes (id_estudiante, id_servicio, fecha_solicitud, estado, comentario)
SELECT e.id_estudiante, s.id_servicio, v.fecha_solicitud::timestamp, v.estado, v.comentario
FROM (
  VALUES
    ('CC260001', 'Constancia de estudios', '2026-10-01 09:00:00', 'Pendiente', 'Constancia para tramite externo.'),
    ('CC260002', 'Beca academica', '2026-10-01 10:15:00', 'En proceso', 'Revision de promedio.'),
    ('CC260003', 'Soporte de plataforma', '2026-10-02 08:30:00', 'Aprobada', 'Restablecimiento de acceso.'),
    ('CC260004', 'Prestamo bibliotecario', '2026-10-02 11:20:00', 'Pendiente', 'Solicitud de libro de bases de datos.'),
    ('CC260005', 'Credencial universitaria', '2026-10-03 12:00:00', 'Rechazada', 'Fotografia no valida.'),
    ('CC260006', 'Constancia de estudios', '2026-10-03 13:10:00', 'Aprobada', 'Documento entregado.'),
    ('CC260007', 'Beca academica', '2026-10-04 09:45:00', 'Pendiente', 'Falta comprobante de ingresos.'),
    ('CC260008', 'Soporte de plataforma', '2026-10-04 15:30:00', 'En proceso', 'Validando correo institucional.'),
    ('CC260009', 'Prestamo bibliotecario', '2026-10-05 08:50:00', 'Cancelada', 'Solicitud cancelada por estudiante.'),
    ('CC260010', 'Credencial universitaria', '2026-10-05 14:40:00', 'Pendiente', 'Reposicion por extravio.'),
    ('CC260001', 'Beca academica', '2026-10-06 10:00:00', 'En proceso', 'Documentos recibidos.'),
    ('CC260002', 'Soporte de plataforma', '2026-10-06 10:30:00', 'Aprobada', 'Cuenta desbloqueada.'),
    ('CC260003', 'Credencial universitaria', '2026-10-07 09:15:00', 'Pendiente', 'Validacion de pago.'),
    ('CC260004', 'Constancia de estudios', '2026-10-07 12:25:00', 'Aprobada', 'Constancia generada.'),
    ('CC260005', 'Prestamo bibliotecario', '2026-10-08 08:05:00', 'En proceso', 'Buscando disponibilidad.')
) AS v(matricula, nombre_servicio, fecha_solicitud, estado, comentario)
JOIN estudiantes e ON e.matricula = v.matricula
JOIN servicios s ON s.nombre_servicio = v.nombre_servicio
WHERE NOT EXISTS (
  SELECT 1
  FROM solicitudes sol
  WHERE sol.id_estudiante = e.id_estudiante
    AND sol.id_servicio = s.id_servicio
    AND sol.fecha_solicitud = v.fecha_solicitud::timestamp
);
