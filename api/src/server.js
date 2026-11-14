const app = require('./app')
const env = require('./config/env')
const { connectMongo, closeMongo } = require('./config/mongodb')

const start = async () => {
  await connectMongo()

  const server = app.listen(env.port, () => {
    console.log(`CampusCloud API escuchando en el puerto ${env.port}`)
  })

  const shutdown = async (signal) => {
    console.log(`\n${signal}: cerrando CampusCloud API`)
    server.close(async () => {
      await closeMongo()
      process.exit(0)
    })
  }

  process.once('SIGINT', () => shutdown('SIGINT'))
  process.once('SIGTERM', () => shutdown('SIGTERM'))
}

start().catch((error) => {
  console.error('No fue posible iniciar CampusCloud API:', error.message)
  process.exit(1)
})
