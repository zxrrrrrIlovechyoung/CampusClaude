const { MongoClient } = require('mongodb')
const env = require('./env')

const client = new MongoClient(`mongodb://${encodeURIComponent(env.mongo.host)}:${env.mongo.port}`, {
  auth: {
    username: env.mongo.user,
    password: env.mongo.password
  },
  authSource: env.mongo.authSource,
  serverSelectionTimeoutMS: 5000
})

let database

const connectMongo = async () => {
  await client.connect()
  database = client.db(env.mongo.database)
  await database.command({ ping: 1 })
  console.log(`MongoDB autenticado en ${env.mongo.database}`)
  return database
}

const getDb = () => {
  if (!database) {
    throw new Error('MongoDB todavía no está conectado')
  }

  return database
}

const closeMongo = async () => {
  await client.close()
}

module.exports = { client, connectMongo, getDb, closeMongo }
