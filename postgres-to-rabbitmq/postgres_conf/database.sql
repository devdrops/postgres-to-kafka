SELECT 'CREATE DATABASE sample_database'
    WHERE NOT EXISTS
        (SELECT FROM pg_database WHERE datname = 'sample_database')\gexec

\c sample_database

SET timezone = 'America/Sao_Paulo';

BEGIN;
    -- Create users table
    CREATE TABLE IF NOT EXISTS users (
        id         SERIAL      PRIMARY KEY,
        name       VARCHAR(50) NOT NULL,
        document   VARCHAR(20) NOT NULL,
        age        SMALLINT    NOT NULL,
        active     BOOLEAN     NOT NULL,
        created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
    -- Create debezium_server_heartbeat table
    CREATE TABLE IF NOT EXISTS debezium_server_heartbeat (
        id         SERIAL      PRIMARY KEY,
        text       VARCHAR(20) NOT NULL,
        created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
    COMMENT ON COLUMN debezium_server_heartbeat.id IS 'ID para demonstrar sequência de execução.';
    COMMENT ON COLUMN debezium_server_heartbeat.text IS 'Mensagem escrita pelo Debezium Server.';
    COMMENT ON COLUMN debezium_server_heartbeat.created_at IS 'Momento quando o heartbeat foi criado.';
COMMIT;
