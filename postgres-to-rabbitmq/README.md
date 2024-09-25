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

3. Inicia o conector do Debezium Server:

```sh
make start-debezium-server
```

4. Abrir uma conexão com o banco de dados:

```sh
make open-postgres
```

5. Execute o SQL abaixo:

```sql
INSERT INTO users (name) VALUES ('Mais Um Silva');
```

6. Acompanhe na [dashboard do RabbitMQ](http://0.0.0.0:15672/#/queues/%2F/cdc.users) a entrada de mensagens na fila
   `cdc.users`.

7. Leia mensagens individualmente:

```sh
make read-queue
```

8. Para encerrar:

```sh
make stop
```

---

## Exemplos

## INSERT

```json
{
    "id": 1,
    "name": "Mais Um Silva",
    "__deleted": "false",
    "operation": "c",
    "table": "users",
    "database": "sample_database",
    "lsn": 26708824,
    "source_ts_ms": 1727291746372
}
```

## UPDATE

```json
{
    "id": 1,
    "name": "Outro Silva",
    "__deleted": "false",
    "operation": "u",
    "table": "users",
    "database": "sample_database",
    "lsn": 26710104,
    "source_ts_ms": 1727291797975
}
```

## DELETE

```json
{
    "id": 1,
    "name": "",
    "__deleted": "true",
    "operation": "d",
    "table": "users",
    "database": "sample_database",
    "lsn": 26710296,
    "source_ts_ms": 1727291845804
}
```

