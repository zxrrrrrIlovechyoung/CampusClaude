USE campuscloud;

INSERT INTO eventos_por_estudiante
  (student_id, event_day, event_time, event_id, event_type, service_id, status, metadata)
VALUES ('EST-001', '2026-11-16', '2026-11-16T08:15:00Z', 'EVT-001', 'LOGIN', 'PORTAL', 'SUCCESS', '{"device":"web"}');

INSERT INTO eventos_por_estudiante
  (student_id, event_day, event_time, event_id, event_type, service_id, status, metadata)
VALUES ('EST-001', '2026-11-16', '2026-11-16T09:10:00Z', 'EVT-002', 'VIEW', 'SERV-BIB', 'SUCCESS', '{"section":"catalogo"}');

INSERT INTO eventos_por_estudiante
  (student_id, event_day, event_time, event_id, event_type, service_id, status, metadata)
VALUES ('EST-001', '2026-11-16', '2026-11-16T10:30:00Z', 'EVT-003', 'RESERVATION', 'SERV-LAB', 'SUCCESS', '{"resource":"router-04"}');

INSERT INTO eventos_por_estudiante
  (student_id, event_day, event_time, event_id, event_type, service_id, status, metadata)
VALUES ('EST-001', '2026-11-16', '2026-11-16T12:05:00Z', 'EVT-004', 'LOGOUT', 'PORTAL', 'SUCCESS', '{"duration_min":230}');

INSERT INTO eventos_por_estudiante
  (student_id, event_day, event_time, event_id, event_type, service_id, status, metadata)
VALUES ('EST-002', '2026-11-16', '2026-11-16T08:45:00Z', 'EVT-005', 'LOGIN', 'PORTAL', 'SUCCESS', '{"device":"mobile"}');

INSERT INTO eventos_por_estudiante
  (student_id, event_day, event_time, event_id, event_type, service_id, status, metadata)
VALUES ('EST-002', '2026-11-16', '2026-11-16T09:25:00Z', 'EVT-006', 'VIEW', 'SERV-TUT', 'SUCCESS', '{"topic":"bases"}');

INSERT INTO eventos_por_estudiante
  (student_id, event_day, event_time, event_id, event_type, service_id, status, metadata)
VALUES ('EST-002', '2026-11-16', '2026-11-16T11:00:00Z', 'EVT-007', 'DOWNLOAD', 'SERV-BIB', 'SUCCESS', '{"file":"guia-nosql.pdf"}');

INSERT INTO eventos_por_estudiante
  (student_id, event_day, event_time, event_id, event_type, service_id, status, metadata)
VALUES ('EST-002', '2026-11-16', '2026-11-16T13:20:00Z', 'EVT-008', 'LOGOUT', 'PORTAL', 'SUCCESS', '{"duration_min":275}');

INSERT INTO eventos_por_estudiante
  (student_id, event_day, event_time, event_id, event_type, service_id, status, metadata)
VALUES ('EST-003', '2026-11-16', '2026-11-16T07:55:00Z', 'EVT-009', 'LOGIN', 'PORTAL', 'SUCCESS', '{"device":"web"}');

INSERT INTO eventos_por_estudiante
  (student_id, event_day, event_time, event_id, event_type, service_id, status, metadata)
VALUES ('EST-003', '2026-11-16', '2026-11-16T10:15:00Z', 'EVT-010', 'RESERVATION', 'SERV-DEP', 'PENDING', '{"space":"gimnasio"}');

INSERT INTO eventos_por_estudiante
  (student_id, event_day, event_time, event_id, event_type, service_id, status, metadata)
VALUES ('EST-003', '2026-11-16', '2026-11-16T14:40:00Z', 'EVT-011', 'VIEW', 'SERV-BIB', 'SUCCESS', '{"section":"prestamos"}');

INSERT INTO eventos_por_estudiante
  (student_id, event_day, event_time, event_id, event_type, service_id, status, metadata)
VALUES ('EST-003', '2026-11-16', '2026-11-16T16:10:00Z', 'EVT-012', 'LOGOUT', 'PORTAL', 'SUCCESS', '{"duration_min":495}');

SELECT COUNT(*) FROM eventos_por_estudiante;
