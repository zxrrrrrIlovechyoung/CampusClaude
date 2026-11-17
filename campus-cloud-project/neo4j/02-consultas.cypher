// Consulta 1: servicios utilizados por un estudiante.
MATCH (e:Estudiante {estudiante_id: 'EST-001'})-[r:USA]->(s:Servicio)
RETURN e.nombre AS estudiante, s.nombre AS servicio, r.desde AS desde
ORDER BY servicio;

// Consulta 2: estudiantes que comparten un servicio.
MATCH (e1:Estudiante)-[:USA]->(s:Servicio)<-[:USA]-(e2:Estudiante)
WHERE e1.estudiante_id < e2.estudiante_id
RETURN s.nombre AS servicio, collect(e1.nombre) + collect(e2.nombre) AS estudiantes
ORDER BY servicio;

// Consulta 3: recomendación básica para EST-001.
// Busca servicios usados por estudiantes que comparten otro servicio con EST-001.
MATCH (objetivo:Estudiante {estudiante_id: 'EST-001'})-[:USA]->(compartido:Servicio)<-[:USA]-(otro:Estudiante)-[:USA]->(recomendado:Servicio)
WHERE NOT (objetivo)-[:USA]->(recomendado)
RETURN recomendado.nombre AS recomendacion,
       count(*) AS coincidencias,
       collect(DISTINCT otro.nombre) AS basada_en
ORDER BY coincidencias DESC, recomendacion;
