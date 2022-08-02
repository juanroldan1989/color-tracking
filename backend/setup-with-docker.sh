#!/bin/bash

# This is the approach triggering 1 container at a time
# to be interacting in the same network `color-tracking-net`

# This approach precedes using `docker-compose up` and `docker-compose down -v`

# build the Rails API image from Dockerfile
docker build -t juanroldan1989/color-tracking-api .

# in case is required when pushing image
# docker login

# Docker image uploaded into https://hub.docker.com/u/juanroldan1989
docker push juanroldan1989/color-tracking-api

# create the network
docker network create color-tracking-net

# start Postgres container
docker run -d --name db --net color-tracking-net -e POSTGRES_USER=juan -e POSTGRES_PASSWORD=123456 -p 5432:5432 postgres:9.6-alpine

# start Zookeeper container
docker run -d --name zookeeper --net color-tracking-net -e ZOOKEEPER_CLIENT_PORT=2181 -e ZOOKEEPER_TICK_TIME=2000 -p 2181:2181 confluentinc/cp-zookeeper:latest

# start Kafka container
docker run -d --name kafka --net color-tracking-net -e KAFKA_BROKER_ID=1 -e KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181 -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://kafka:9092,PLAINTEXT_HOST://localhost:29092 -e KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT -e KAFKA_INTER_BROKER_LISTENER_NAME=PLAINTEXT -e KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 -p 9092:9092 confluentinc/cp-kafka:latest

# start Rails API container
docker run -d --name api --net color-tracking-net -p 3000:3000 -e SECRET_KEY_BASE=secret_key_base juanroldan1989/color-tracking-api
