#!/bin/bash
### RUN DB
echo "RUN db"
set -e
DIR="$( cd "$( dirname "$0" )" && pwd )"
docker ps -q --filter "name=test-pg" | grep -q . && docker stop test-pg
docker rm -f test-pg
docker run --name test-pg \
-v "$DIR/psql":/psql \
-p 5430:5432 \
-e POSTGRES_USER=user \
-e POSTGRES_PASSWORD=password \
-e POSTGRES_DB=testdb \
-d postgres:13.3
docker start test-pg
NODE_ENV=test DATABASE_URL="postgresql://user:password@localhost:5430/testdb" npx prisma migrate deploy
npm ci
npx  prisma generate --schema=prisma/schema.prisma
NODE_ENV=test DATABASE_URL="postgresql://user:password@localhost:5430/testdb" node index.js
