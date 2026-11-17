const campus = db.getSiblingDB('campuscloud');
const coleccion = campus.detalles_servicio;

print('Filtro 1 - servicios de laboratorio:');
printjson(coleccion.find({ tipo: 'laboratorio' }, { _id: 0, servicio_id: 1, nombre: 1, tipo: 1 }).toArray());

print('Filtro 2 - servicios que requieren reservación:');
printjson(coleccion.find({ 'configuracion.requiere_reserva': true }, { _id: 0, servicio_id: 1, nombre: 1 }).toArray());

print('Filtro 3 - servicios con etiqueta de consulta o asesoría:');
printjson(coleccion.find({ etiquetas: { $in: ['consulta', 'asesoría'] } }, { _id: 0, servicio_id: 1, nombre: 1, etiquetas: 1 }).toArray());
