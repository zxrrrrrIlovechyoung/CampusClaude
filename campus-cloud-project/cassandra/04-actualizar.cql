USE campuscloud;

UPDATE eventos_por_estudiante
SET status = 'CONFIRMED', metadata = '{"space":"gimnasio","confirmed_by":"system"}'
WHERE student_id = 'EST-003'
  AND event_day = '2026-11-16'
  AND event_time = '2026-11-16T10:15:00Z'
  AND event_id = 'EVT-010';

SELECT * FROM eventos_por_estudiante
WHERE student_id = 'EST-003'
  AND event_day = '2026-11-16'
  AND event_time = '2026-11-16T10:15:00Z'
  AND event_id = 'EVT-010';
