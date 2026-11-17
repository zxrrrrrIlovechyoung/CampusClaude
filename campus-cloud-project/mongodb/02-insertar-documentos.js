const campus = db.getSiblingDB('campuscloud');
const coleccion = campus.detalles_servicio;

const ids = ['SERV-BIB-001', 'SERV-BIB-002', 'SERV-LAB-001', 'SERV-LAB-002', 'SERV-TUT-001', 'SERV-DEP-001'];
coleccion.deleteMany({ servicio_id: { $in: ids } });

const documentos = [
  {
    servicio_id: 'SERV-BIB-001',
    nombre: 'Biblioteca digital',
    tipo: 'biblioteca',
    descripcion: 'Consulta de libros y recursos académicos.',
    etiquetas: ['libros', 'digital', 'consulta'],
    configuracion: { modalidad: 'en línea', requiere_reserva: false },
    activo: true
  },
  {
    servicio_id: 'SERV-BIB-002',
    nombre: 'Sala de lectura',
    tipo: 'biblioteca',
    descripcion: 'Espacio de lectura con préstamo interno.',
    etiquetas: ['lectura', 'presencial'],
    configuracion: { modalidad: 'presencial', capacidad: 40 },
    activo: true
  },
  {
    servicio_id: 'SERV-LAB-001',
    nombre: 'Laboratorio de redes',
    tipo: 'laboratorio',
    descripcion: 'Prácticas de redes y administración de dispositivos.',
    etiquetas: ['redes', 'routers', 'prácticas'],
    configuracion: { modalidad: 'presencial', capacidad: 24, equipo: ['routers', 'switches'] },
    activo: true
  },
  {
    servicio_id: 'SERV-LAB-002',
    nombre: 'Laboratorio de programación',
    tipo: 'laboratorio',
    descripcion: 'Sala para ejercicios de desarrollo de software.',
    etiquetas: ['programación', 'código'],
    configuracion: { modalidad: 'presencial', capacidad: 30, software: ['Node.js', 'Docker'] },
    activo: true
  },
  {
    servicio_id: 'SERV-TUT-001',
    nombre: 'Tutoría académica',
    tipo: 'tutoria',
    descripcion: 'Orientación para dudas y seguimiento académico.',
    etiquetas: ['asesoría', 'seguimiento'],
    configuracion: { modalidad: 'híbrida', horarios: ['09:00-11:00', '16:00-18:00'] },
    activo: true
  },
  {
    servicio_id: 'SERV-DEP-001',
    nombre: 'Gimnasio universitario',
    tipo: 'deportivo',
    descripcion: 'Espacio deportivo con reservación de horarios.',
    etiquetas: ['deporte', 'salud', 'reservación'],
    configuracion: { modalidad: 'presencial', capacidad: 20, requiere_reserva: true },
    activo: true
  }
];

const resultado = coleccion.insertMany(documentos);
print(`Documentos insertados: ${Object.keys(resultado.insertedIds).length}`);
printjson(coleccion.find({}, { _id: 0 }).sort({ servicio_id: 1 }).toArray());
