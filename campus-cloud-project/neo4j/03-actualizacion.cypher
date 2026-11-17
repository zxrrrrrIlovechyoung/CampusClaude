// Modificación controlada de una propiedad de servicio.
MATCH (s:Servicio {servicio_id: 'SERV-LAB', cc_source: 'actividad-2'})
SET s.capacidad = 28,
    s.ultima_actualizacion = date('2026-11-16')
RETURN s.servicio_id AS servicio, s.nombre AS nombre,
       s.capacidad AS nueva_capacidad, s.ultima_actualizacion AS fecha;
