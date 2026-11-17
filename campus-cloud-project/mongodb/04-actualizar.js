const campus = db.getSiblingDB('campuscloud');
const coleccion = campus.detalles_servicio;
const filtro = { servicio_id: 'SERV-LAB-001' };

print('Antes de actualizar:');
printjson(coleccion.findOne(filtro, { _id: 0 }));

const resultado = coleccion.updateOne(filtro, {
  $set: {
    'configuracion.capacidad': 28,
    'configuracion.equipo': ['routers', 'switches', 'firewalls'],
    ultima_actualizacion: '2026-11-16'
  },
  $addToSet: { etiquetas: 'seguridad' }
});

printjson({ matchedCount: resultado.matchedCount, modifiedCount: resultado.modifiedCount });
print('Después de actualizar:');
printjson(coleccion.findOne(filtro, { _id: 0 }));
