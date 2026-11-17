const campus = db.getSiblingDB('campuscloud');

if (!campus.getCollectionNames().includes('detalles_servicio')) {
  campus.createCollection('detalles_servicio');
  print('Coleccion detalles_servicio creada.');
} else {
  print('Coleccion detalles_servicio ya existe.');
}

campus.detalles_servicio.createIndex({ tipo: 1 });
campus.detalles_servicio.createIndex({ activo: 1 });
printjson(campus.detalles_servicio.getIndexes());
