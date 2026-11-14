const { getDb } = require('../config/mongodb')

const collectionName = 'catalogo_servicios'

const obtenerServicios = async (_req, res) => {
  const servicios = await getDb()
    .collection(collectionName)
    .find({})
    .sort({ nombre: 1 })
    .toArray()

  res.json({
    total: servicios.length,
    datos: servicios
  })
}

const crearServicio = async (req, res) => {
  const { codigo, nombre, categoria, activo = true, modalidades = [], caracteristicas = {} } = req.body

  if (!codigo || !nombre || !categoria) {
    return res.status(400).json({
      mensaje: 'codigo, nombre y categoria son obligatorios'
    })
  }

  const servicio = {
    codigo,
    nombre,
    categoria,
    activo,
    modalidades,
    caracteristicas,
    creadoEn: new Date()
  }

  const resultado = await getDb().collection(collectionName).insertOne(servicio)

  res.status(201).json({
    mensaje: 'Servicio creado',
    id: resultado.insertedId,
    datos: servicio
  })
}

module.exports = { obtenerServicios, crearServicio }
