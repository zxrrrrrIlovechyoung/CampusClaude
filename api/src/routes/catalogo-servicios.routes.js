const { Router } = require('express')
const {
  obtenerServicios,
  crearServicio
} = require('../controllers/catalogo-servicios.controllers')

const router = Router()

router.get('/', obtenerServicios)
router.post('/', crearServicio)

module.exports = router
