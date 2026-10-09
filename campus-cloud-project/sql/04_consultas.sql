-- 04_consultas.sql
-- Consultas y operaciones CRUD demostrables.

\connect "CampusCloud"

-- SELECT: listado relacionado estudiante - servicio - estado.
SELECT
  sol.id_solicitud,
  e.matricula,
  e.nombre AS estudiante,
  s.nombre_servicio,
  sol.estado,
  sol.fecha_solicitud
FROM solicitudes sol
JOIN estudiantes e ON e.id_estudiante = sol.id_estudiante
JOIN servicios s ON s.id_servicio = sol.id_servicio
ORDER BY sol.id_solicitud;

-- Consulta 1: solicitudes pendientes o en proceso.
SELECT
  e.nombre AS estudiante,
  s.nombre_servicio,
  sol.estado
FROM solicitudes sol
JOIN estudiantes e ON e.id_estudiante = sol.id_estudiante
JOIN servicios s ON s.id_servicio = sol.id_servicio
WHERE sol.estado IN ('Pendiente', 'En proceso')
ORDER BY sol.estado, e.nombre;

-- Consulta 2: cantidad de solicitudes por servicio.
SELECT
  s.nombre_servicio,
  COUNT(sol.id_solicitud) AS total_solicitudes
FROM servicios s
LEFT JOIN solicitudes sol ON sol.id_servicio = s.id_servicio
GROUP BY s.nombre_servicio
ORDER BY total_solicitudes DESC, s.nombre_servicio;

-- Consulta 3: solicitudes por estudiante.
SELECT
  e.matricula,
  e.nombre,
  COUNT(sol.id_solicitud) AS total_solicitudes
FROM estudiantes e
LEFT JOIN solicitudes sol ON sol.id_estudiante = e.id_estudiante
GROUP BY e.matricula, e.nombre
ORDER BY total_solicitudes DESC, e.matricula;

-- INSERT: nueva solicitud de prueba.
INSERT INTO solicitudes (id_estudiante, id_servicio, estado, comentario)
SELECT e.id_estudiante, s.id_servicio, 'Pendiente', 'Solicitud de prueba CRUD.'
FROM estudiantes e
JOIN servicios s ON s.nombre_servicio = 'Soporte de plataforma'
WHERE e.matricula = 'CC260010'
RETURNING *;

-- UPDATE: cambio de estado de la solicitud recien creada.
UPDATE solicitudes
SET estado = 'En proceso',
    comentario = 'Solicitud de prueba CRUD actualizada.'
WHERE comentario = 'Solicitud de prueba CRUD.'
RETURNING *;

-- DELETE: eliminacion controlada de la solicitud de prueba.
DELETE FROM solicitudes
WHERE comentario = 'Solicitud de prueba CRUD actualizada.'
RETURNING *;
