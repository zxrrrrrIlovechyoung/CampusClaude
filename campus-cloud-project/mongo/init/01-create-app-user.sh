#!/bin/bash
set -e

mongosh --quiet \
  --username "$MONGO_INITDB_ROOT_USERNAME" \
  --password "$MONGO_INITDB_ROOT_PASSWORD" \
  --authenticationDatabase admin \
  --eval "
    const databaseName = '$MONGO_INITDB_DATABASE';
    const username = '$MONGO_APP_USER';
    const password = '$MONGO_APP_PASSWORD';
    const databaseHandle = db.getSiblingDB(databaseName);
    const existingUser = databaseHandle.getUser(username);

    if (existingUser) {
      databaseHandle.updateUser(username, {
        pwd: password,
        roles: [{ role: 'readWrite', db: databaseName }]
      });
    } else {
      databaseHandle.createUser({
        user: username,
        pwd: password,
        roles: [{ role: 'readWrite', db: databaseName }]
      });
    }
  "
