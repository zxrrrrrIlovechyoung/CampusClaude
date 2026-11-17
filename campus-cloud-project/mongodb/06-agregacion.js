const campus = db.getSiblingDB('campuscloud');

print('Conteo de servicios por tipo:');
printjson(campus.detalles_servicio.aggregate([
  { $group: { _id: '$tipo', total: { $sum: 1 } } },
  { $sort: { _id: 1 } },
  { $project: { _id: 0, tipo: '$_id', total: 1 } }
]).toArray());
