# Instalación y operación local

## 1. Preparar credenciales

Copiar `.env.example` como `.env` y cambiar las credenciales únicamente en el equipo local. El archivo `.env` está excluido por `.gitignore`.

## 2. Validar Compose

```powershell
docker compose -f docker-compose.yml config
```

La validación debe terminar sin errores de sintaxis ni variables faltantes.

## 3. Iniciar Cassandra

```powershell
docker compose -f docker-compose.yml up -d cassandra-cloud
docker compose -f docker-compose.yml ps cassandra-cloud
```

Esperar a que el estado sea `running` y que el log indique que Cassandra acepta conexiones CQL en el puerto 9042.

## 4. Detener sin perder datos

```powershell
docker compose -f docker-compose.yml stop cassandra-cloud
docker compose -f docker-compose.yml start cassandra-cloud
```

No utilizar `docker compose down -v` durante la demostración porque elimina los datos del volumen.
