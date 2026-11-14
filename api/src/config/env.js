const path = require('node:path')
const dotenv = require('dotenv')

dotenv.config({ path: path.resolve(__dirname, '../../.env') })

const required = (name) => {
  const value = process.env[name]

  if (!value) {
    throw new Error(`Falta la variable de entorno ${name}`)
  }

  return value
}

const port = Number(process.env.PORT || 3001)

if (!Number.isInteger(port) || port < 1 || port > 65535) {
  throw new Error('PORT debe ser un puerto válido')
}

const mongoPort = Number(required('MONGO_PORT'))

if (!Number.isInteger(mongoPort) || mongoPort < 1 || mongoPort > 65535) {
  throw new Error('MONGO_PORT debe ser un puerto válido')
}

const env = {
  port,
  mongo: {
    host: required('MONGO_HOST'),
    port: mongoPort,
    user: required('MONGO_USER'),
    password: required('MONGO_PASSWORD'),
    database: required('MONGO_DATABASE'),
    authSource: required('MONGO_AUTH_SOURCE')
  }
}

module.exports = env
