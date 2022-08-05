#!/bin/bash

# ecs-cli allows you to deploy a Docker stack very easily on AWS ECS
# using the same syntax as the docker-compose file format version 1, 2 and 3

# The selling point of ecs-cli is to reuse your docker-compose.yml files
# to deploy your containers to AWS

# ecs-cli translates a docker-compose-yml to ECS Task Desfinitions and Services

# required files to work with this approach
# `ecs-cli.asc`, `ecs.cer`, `public_key_ecs.txt`

# change directory
cd backend/infrastructure/aws-ecs

# configure cluster
ecs-cli configure --region us-east-1 --cluster color-tracking --config-name color-tracking

# setup cloud formation template (`--force` applies only when updating a cluster)
# `--size 2` means having 2 ECS Instances in 2 different Availability Zones
ecs-cli up --keypair ecs --capability-iam --size 2 --instance-type t3.medium --cluster-config color-tracking --force

# always specify cluster name to avoid issues with other clusters
ecs-cli compose up --cluster color-tracking --create-log-groups

# otherwise we'd need to specifiy it with
# ecs-cli compose --file custom-compose.yml up

# check containers status
ecs-cli ps --cluster color-tracking

# check AWS ECS console
# https://console.aws.amazon.com/ecs/home#/clusters

# checking logs inside ECS Container Instance
# First, add `Inbound Rule` for `SSH` connections within `Security Group` associated with ECS Instances

# Then, get [Public DNS] provided within ECS Cluster -> Container Instance -> Public DNS

# ssh -i "ecs.cer" ec2-user@[Public DNS]
# docker ps
# docker exec -it [container name] bash
# tail -f log/production.log

# Delete clouster resources
ecs-cli down --cluster colo-tracking --force
