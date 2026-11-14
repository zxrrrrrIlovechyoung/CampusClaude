const obtenerSalud = (_req, res) => {
  res.status(200).json({
    estado: 'ok',
    aplicacion: 'CampusCloud API',
    mensaje: 'El servidor está funcionando'
  })
}

module.exports = { obtenerSalud }
