SELECT 'CREATE DATABASE application'
  WHERE NOT EXISTS
    (SELECT FROM pg_database WHERE datname = 'application')\gexec

\c application

BEGIN;
  CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
COMMIT;

BEGIN;
  CREATE TABLE IF NOT EXISTS users (
    id         SERIAL       PRIMARY KEY,
    uuid       uuid         UNIQUE DEFAULT uuid_generate_v4(),
    name       VARCHAR(100) NOT NULL,
    age        INTEGER      NOT NULL,
    score      NUMERIC(5,2) NOT NULL,
    metadata   JSON         NOT NULL,
    enabled    BOOLEAN      NOT NULL DEFAULT false,
    created_at TIMESTAMP    NOT NULL DEFAULT NOW()
  );
COMMIT;

BEGIN;
  CREATE TABLE IF NOT EXISTS debezium_heartbeat (
    id         SERIAL       PRIMARY KEY,
    message    VARCHAR(100) NOT NULL,
    created_at TIMESTAMP    NOT NULL DEFAULT NOW()
  );
COMMIT;

