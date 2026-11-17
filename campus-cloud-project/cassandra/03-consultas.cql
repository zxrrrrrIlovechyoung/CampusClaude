USE campuscloud;

-- Consulta principal: actividad de EST-001 en un intervalo del 16 de noviembre.
SELECT student_id, event_day, event_time, event_id, event_type, service_id, status
FROM eventos_por_estudiante
WHERE student_id = 'EST-001'
  AND event_day = '2026-11-16'
  AND event_time >= '2026-11-16T08:00:00Z'
  AND event_time < '2026-11-16T11:00:00Z';

-- Consulta de validación: todas las actividades de un estudiante en la partición.
SELECT * FROM eventos_por_estudiante
WHERE student_id = 'EST-002';
