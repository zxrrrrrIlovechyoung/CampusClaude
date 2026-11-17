const campus = db.getSiblingDB('campuscloud');
const coleccion = campus.detalles_servicio;
const filtro = { servicio_id: 'SERV-BIB-002' };

print('Documento seleccionado para eliminar:');
printjson(coleccion.findOne(filtro, { _id: 0 }));

const resultado = coleccion.deleteOne(filtro);
printjson({ deletedCount: resultado.deletedCount });
print('Verificación posterior:');
printjson(coleccion.findOne(filtro, { _id: 0 }));
