# PostgreSQL -> RabbitMQ

Replicação de dados do PostgreSQL para stream no RabbitMQ.

Siga os passos na ordem abaixo.

1. Iniciar o banco de dados Postgres, aplicando configurações de Write-Ahead Log:

```sh
make start-postgres
```

2. Iniciar o RabbitMQ, habilitando os plugins de Stream:

```sh
make start-rabbitmq
```

3. Criando uma estrutura padrão no banco de dados, que será observada:

```sh
make open-postgres

# Uma vez feita a conexão, executar na ordem abaixo:
CREATE DATABASE sample_database;
\c sample_database;
CREATE TABLE users(id SERIAL PRIMARY KEY, name VARCHAR);

# Mantenha a conexão aberta ;)
```

4. Inicia o conector do Debezium Server:

```sh
make start-debezium-server
```

