up:
	make postgres-up
	make zookeeper-up
	make kafka-up
	make kafka-ui-up
	make debezium-up

clear:
	docker remove \
		postgres \
		zookeeper \
		kafka \
		kafka-ui \
		debezium

down:
	docker stop \
		postgres \
		zookeeper \
		kafka \
		debezium \
		kafka-ui
	make clear

postgres-up:
	docker run -d --name postgres \
		-p 5000:5432 \
		-v $(PWD)/postgres_conf/postgresql.conf:/etc/postgresql.conf \
		-v $(PWD)/postgres_conf/pgdata:/var/lib/postgresql/data \
		-v $(PWD)/postgres_conf/database.sql:/docker-entrypoint-initdb.d/database.sql \
		-e PGDATA=/var/lib/postgresql/data/pgdata \
		-e POSTGRES_HOST_AUTH_METHOD=trust \
		-e POSTGRES_USER=postgres \
		-e POSTGRES_PASSWORD=postgres \
		postgres:15-alpine sh -c "docker-entrypoint.sh -c 'config_file=/etc/postgresql.conf'"

postgres-clear:
	sudo rm -rf $(PWD)/postgres_conf/pgdata

zookeeper-up:
	docker run -it -d \
		--name zookeeper \
		-p 2181:2181 -p 2888:2888 -p 3888:3888 \
		debezium/zookeeper:2.6

kafka-up:
	docker run -it -d \
		--name kafka \
		-p 9092:9092 \
		--link zookeeper:zookeeper \
		debezium/kafka:2.6

kafka-ui-up:
	docker run -d \
		--name kafka-ui \
		-p 8080:8080 \
		-e DYNAMIC_CONFIG_ENABLED=true \
		--link=kafka:kafka \
		provectuslabs/kafka-ui

debezium-up:
	docker run -it -ti \
		--name debezium \
		-p 8083:8083 \
		-e GROUP_ID=1 \
		-e CONNECT_LOG4J_LOGGERS="TRACE, stdout" \
		-v $(CURDIR)/debezium_conf/application.properties:/debezium/conf/application.properties \
		--link zookeeper:zookeeper \
		--link postgres:postgres \
		--link kafka:kafka \
		debezium/server:2.7.3.Final

