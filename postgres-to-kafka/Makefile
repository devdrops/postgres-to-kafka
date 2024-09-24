up:
	make postgres-up
	make zookeeper-up
	make kafka-up
	make connect-up

clear:
	docker remove postgres zookeeper kafka connect

down:
	docker stop postgres
	docker stop zookeeper
	docker stop kafka
	docker stop connect
	make clear

postgres-up:
	docker run -d \
		--name postgres \
		-p 5000:5432 \
		-e POSTGRES_HOST_AUTH_METHOD=trust \
		debezium/postgres

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

connect-up:
	docker run -it -d \
		--name connect \
		-p 8083:8083 \
		-e GROUP_ID=1 -e CONFIG_STORAGE_TOPIC=my-connect-configs -e OFFSET_STORAGE_TOPIC=my-connect-offsets -e ADVERTISED_HOST_NAME=$(shell echo $DOCKER_HOST | cut -f3 -d'/' | cut -f1 -d':') \
		--link zookeeper:zookeeper --link postgres:postgres --link kafka:kafka \
		debezium/connect:2.6
