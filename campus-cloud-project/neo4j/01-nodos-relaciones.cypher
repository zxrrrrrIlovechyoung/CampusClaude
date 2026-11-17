// CampusCloud / Actividad 2 / Neo4j 5
// Datos completamente ficticios y reiniciables para la demostración.

MATCH (n)
WHERE n.cc_source = 'actividad-2'
DETACH DELETE n;

CREATE CONSTRAINT estudiante_id IF NOT EXISTS
FOR (e:Estudiante) REQUIRE e.estudiante_id IS UNIQUE;

CREATE CONSTRAINT servicio_id IF NOT EXISTS
FOR (s:Servicio) REQUIRE s.servicio_id IS UNIQUE;

UNWIND [
  {id: 'EST-001', nombre: 'Ana Torres', programa: 'Desarrollo de Software'},
  {id: 'EST-002', nombre: 'Bruno Reyes', programa: 'Desarrollo de Software'},
  {id: 'EST-003', nombre: 'Carla Mendoza', programa: 'Redes Inteligentes'},
  {id: 'EST-004', nombre: 'Diego Cruz', programa: 'Desarrollo de Software'},
  {id: 'EST-005', nombre: 'Elena Vargas', programa: 'Sistemas Productivos'}
] AS datos
CREATE (:Estudiante {
  estudiante_id: datos.id,
  nombre: datos.nombre,
  programa: datos.programa,
  cc_source: 'actividad-2'
});

UNWIND [
  {id: 'SERV-BIB', nombre: 'Biblioteca digital', tipo: 'biblioteca', capacidad: 100},
  {id: 'SERV-LAB', nombre: 'Laboratorio de redes', tipo: 'laboratorio', capacidad: 24},
  {id: 'SERV-TUT', nombre: 'Tutoría académica', tipo: 'tutoria', capacidad: 12},
  {id: 'SERV-DEP', nombre: 'Gimnasio universitario', tipo: 'deportivo', capacidad: 20}
] AS datos
CREATE (:Servicio {
  servicio_id: datos.id,
  nombre: datos.nombre,
  tipo: datos.tipo,
  capacidad: datos.capacidad,
  cc_source: 'actividad-2'
});

UNWIND [
  ['EST-001', 'SERV-BIB'],
  ['EST-001', 'SERV-LAB'],
  ['EST-002', 'SERV-BIB'],
  ['EST-002', 'SERV-TUT'],
  ['EST-003', 'SERV-LAB'],
  ['EST-003', 'SERV-DEP'],
  ['EST-004', 'SERV-TUT'],
  ['EST-005', 'SERV-BIB']
] AS relacion
MATCH (e:Estudiante {estudiante_id: relacion[0], cc_source: 'actividad-2'})
MATCH (s:Servicio {servicio_id: relacion[1], cc_source: 'actividad-2'})
CREATE (e)-[:USA {desde: date('2026-11-01')}]->(s);

MATCH (e:Estudiante {cc_source: 'actividad-2'})
OPTIONAL MATCH (e)-[r:USA]->(s:Servicio)
RETURN e.estudiante_id AS estudiante, count(r) AS relaciones, collect(s.servicio_id) AS servicios
ORDER BY estudiante;
