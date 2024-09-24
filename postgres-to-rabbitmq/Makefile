start-postgres:
	docker rm -f postgres
	docker run -d --name postgres \
		-p 5432:5432 \
		-v $(CURDIR)/postgres_conf/postgresql.conf:/etc/postgresql.conf \
		-v $(CURDIR)/pgdata:/var/lib/postgresql/data/pgdata \
		-e PGDATA=/var/lib/postgresql/data/pgdata \
		-e POSTGRES_HOST_AUTH_METHOD=trust \
		-e POSTGRES_USER=postgres \
		-e POSTGRES_PASSWORD=postgres \
		postgres:15-alpine sh -c "docker-entrypoint.sh -c 'config_file=/etc/postgresql.conf'"

stop-postgres:
	docker stop postgres

start-rabbitmq:
	docker rm -f rabbitmq
	docker run -d --name rabbitmq \
		-p 5672:5672 \
		-p 15672:15672 \
		-p 25672:25672 \
		-p 5552:5552 \
		-e RABBITMQ_ERLANG_COOKIE="a-secret-hash" \
		-e RABBITMQ_DEFAULT_VHOST="/" \
		-e RABBITMQ_DEFAULT_USER="guest" \
		-e RABBITMQ_DEFAULT_PASS="guest" \
		-e RABBITMQ_SERVER_ADDITIONAL_ERL_ARGS='-rabbitmq_stream advertised_host localhost -rabbit loopback_users "none"' \
		rabbitmq:3-management-alpine
	sleep 3 # É necessário esperar antes de habilitar os plugins abaixo ¬¬
	docker exec rabbitmq rabbitmq-plugins enable rabbitmq_stream
	docker exec rabbitmq rabbitmq-plugins enable rabbitmq_stream_management
	docker exec rabbitmq rabbitmq-plugins enable rabbitmq_management
	docker cp $(CURDIR)/rabbitmq_conf/rabbitmq.conf rabbitmq:/etc/rabbitmq
	docker cp $(CURDIR)/rabbitmq_conf/definitions.json rabbitmq:/etc/rabbitmq
	sleep 2 # Esperar 2 segundos para declarar a exchange
	docker exec rabbitmq sh -c "rabbitmqadmin declare exchange name='cdc.users' type='direct'"
	docker exec rabbitmq sh -c "rabbitmqadmin declare queue --vhost=/ name='cdc.users' durable='true'"
	docker exec rabbitmq sh -c "rabbitmqadmin declare binding --vhost=/ source='cdc.users' destination_type='queue' destination='cdc.users' routing_key='users'"

stop-rabbitmq:
	docker stop rabbitmq

start-debezium-server:
	docker rm -f debezium
	docker run -ti --name debezium \
		-p 8080:8080 \
		-v $(CURDIR)/debezium_conf/application.properties:/debezium/conf/application.properties \
		--link postgres:postgres \
		--link rabbitmq:rabbitmq \
		debezium/server

stop-debezium-server:
	docker stop debezium

open-postgres:
	docker exec -ti postgres sh -c 'psql -U postgres'

read-queue:
	docker exec -ti rabbitmq sh -c "rabbitmqadmin get queue=cdc.users ackmode=ack_requeue_false"

start: start-postgres start-rabbitmq start-debezium-server

stop: stop-debezium-server stop-rabbitmq stop-postgres
