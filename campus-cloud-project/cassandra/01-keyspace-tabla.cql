-- CampusCloud / Actividad 2 / Cassandra 5
-- Modelo orientado a la consulta: actividad de un estudiante por día y hora.

CREATE KEYSPACE IF NOT EXISTS campuscloud
WITH replication = {
  'class': 'SimpleStrategy',
  'replication_factor': 1
};

USE campuscloud;

CREATE TABLE IF NOT EXISTS eventos_por_estudiante (
  student_id text,
  event_day date,
  event_time timestamp,
  event_id text,
  event_type text,
  service_id text,
  status text,
  metadata text,
  PRIMARY KEY ((student_id), event_day, event_time, event_id)
) WITH CLUSTERING ORDER BY (event_day DESC, event_time DESC);

-- Partition key: student_id, porque la consulta principal parte de un estudiante.
-- Clustering: event_day y event_time permiten recuperar un periodo ordenado.
