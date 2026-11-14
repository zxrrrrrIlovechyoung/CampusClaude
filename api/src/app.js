const express = require('express')
const catalogoServiciosRoutes = require('./routes/catalogo-servicios.routes')
const saludRoutes = require('./routes/salud.routes')

const app = express()

app.use(express.json())

app.get('/', (_req, res) => {
  res.json({ message: 'CampusCloud API en funcionamiento' })
})

app.use('/api/catalogo-servicios', catalogoServiciosRoutes)
app.use('/api/salud', saludRoutes)

app.use((error, _req, res, _next) => {
  console.error('Error en la API:', error)
  res.status(500).json({ mensaje: 'Error interno del servidor' })
})

module.exports = app
