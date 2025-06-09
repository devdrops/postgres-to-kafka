# Replicando Dados do Postgres para Kafka

1. Com o terminal, abra o diretório deste arquivo. Inicie todos os serviços com o comando abaixo:

```sh
make up
```

2. Em outra janela do terminal, conecte-se ao banco de dados com o comando abaixo:

```sh
docker exec -ti postgres sh -c 'psql -h localhost -p 5432 -U postgres'
```

3. Uma vez conectado, execute os comandos na ordem abaixo:

```sql
\c application

insert into users (name, age, score, metadata) values ('Fulano da Silva', 18, 89.03, '{"data":{"some":"stuff"}}');
```

4. No browser, acesse [localhost:8080](http://localhost:8080) para verificar a criação do tópico e mensagens no Kafka.
Exemplo de evento publicado no Kafka:

```json
{
  "id": 1,
  "uuid": "b3f3ca3e-b694-45b8-9418-79c4916613f5",
  "name": "Fulano da Silva",
  "age": 18,
  "score": "89.03",
  "metadata": "{\"data\":{\"some\":\"stuff\"}}",
  "enabled": false,
  "created_at": 1749502893788301,
  "operation": "r"
}
```

## Referências

- https://hevodata.com/learn/postgresql-kafka-connector/
- https://debezium.io/documentation/reference/stable/connectors/postgresql.html
- https://github.com/docker-library/docs/blob/master/postgres/README.md
- https://docs.confluent.io/kafka/operations-tools/kafka-tools.html
- https://kafka.apache.org/quickstart
- https://www.baeldung.com/ops/kafka-list-topics
- https://www.yugabyte.com/blog/change-data-capture-cdc-run-debezium-server-kafka-sink/

