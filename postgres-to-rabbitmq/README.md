# PostgreSQL -> RabbitMQ

Replicação de dados do PostgreSQL para stream no RabbitMQ.

Siga os passos na ordem abaixo.

1. Iniciar o banco de dados Postgres, aplicando configurações de Write-Ahead Log:

```sh
make start-postgres
```

2. Iniciar o RabbitMQ, habilitando os plugins de Stream e Admin e criando exchange, queue e binding:

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

5. Insira algumas linhas no banco de dados usando a conexão aberta no passo 3:

```sql
INSERT INTO users (name) VALUES ('Fulano da Silva'), ('Beltrano da Silva'), ('Cicrana da Silva');
```

6. Acompanhe na [dashboard do RabbitMQ](http://0.0.0.0:15672/#/queues/%2F/cdc.users) a entrada de mensagens na fila
   `cdc.users`.

7. Leia mensagens individualmente:

```sh
make read-queue
```

---

Para encerrar:

```sh
make stop
```
