USE campuscloud;

DELETE FROM eventos_por_estudiante
WHERE student_id = 'EST-002'
  AND event_day = '2026-11-16'
  AND event_time = '2026-11-16T13:20:00Z'
  AND event_id = 'EVT-008';

SELECT * FROM eventos_por_estudiante
WHERE student_id = 'EST-002';
