const { Router } = require('express')
const { obtenerSalud } = require('../controllers/salud.controllers')

const router = Router()

router.get('/', obtenerSalud)

module.exports = router
