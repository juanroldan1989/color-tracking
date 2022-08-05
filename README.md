# Color Tracking App

<div align="left">
  <img width="800" src="https://github.com/juanroldan1989/color-tracking/blob/main/color-tracking-screenshot.png" />
</div>

# TODO

Add Logo structure from: https://github.com/thelounge/thelounge#readme

Add Table of contents https://github.com/Ileriayo/markdown-badges

Add badges from https://github.com/Ileriayo/markdown-badges

Twitter link from: https://github.com/ArmynC/ArminC-AutoExec/#readme

Video walkthrough like this: https://github.com/ajeetdsouza/zoxide#readme - https://github.com/create-go-app/cli#readme

Say Thanks link like this: https://github.com/amitmerchant1990/electron-markdownify#readme

Add Mobile view of how app looks like: https://github.com/gitpoint/git-point#introduction

Contribute section like this: https://github.com/gofiber/fiber#-contribute

# Thoughts and Inspiration

<div align="left">
  <img width="400" src="https://github.com/juanroldan1989/color-tracking/blob/main/color-tracking.jpeg" />
</div>

# Local Development

Starting up:

```ruby
$ git clone git@github.com:juanroldan1989/color-tracking.git
$ cd color-tracking
$ docker-compose up
```

Cleaning up:

```ruby
$ docker-compose down -v
```

# AWS Deployment

## ECS

Deployment instructions:

```ruby
backend/infrastructure/aws-ecs/setup-aws-ecs.sh
```

This script takes care of:

- Cluster configuration and creation
```ruby
$ ecs-cli configure --region us-east-1 --cluster color-tracking --config-name color-tracking
```

- ECS Key Pair configuration, EC2 Instance Types and Cluster capability
```ruby
$ ecs-cli up --keypair ecs --capability-iam --size 2 --instance-type t3.medium --cluster-config color-tracking --force
```

- ECS Deployment of tasks with containers
```ruby
$ ecs-cli compose up --cluster color-tracking --create-log-groups
```

- Check containers status
```ruby
$ ecs-cli ps --cluster color-tracking
```

- Cluster deletion and resources cleanup
```ruby
$ ecs-cli down --cluster colo-tracking --force
```

## Terraform

- TODO

# Kafka & Libraries

## Kafka Troubleshooting

For local development:

```ruby
$ brew services stop/start kafka
$ brew services stop/start zookeeper
```

## Karafka Consumer Troubleshooting

For local development:

Run Karafka server and see the consumption magic happen:
https://github.com/karafka/karafka#tldr-1-minute-from-setup-to-publishing-and-consuming-messages

```ruby
$ bundle exec karafka server (start and stop)
```

For Docker Compose development:

```ruby
$ docker stop/start karafka-consumer
```

**The above also triggers topics creation (in case they don't exist yet)**

## Kafka Topics Creation

`KAFKA_AUTO_CREATE_TOPICS_ENABLE` environment variable is passed to `wurstmeister/kafka` container.

If `true`:

- Topics will be created **as and when they're first referenced** by the producer or consumer.

If `false`:

- Then we need to to pass **a different** environment variable to `wurstmeister/kafka` container:

```ruby
KAFKA_CREATE_TOPICS: "hover_on_colors:1:1,click_on_colors:1:1"
```

This way topics are created **when container is started.**

## Kafka Docker Images Available

- wurstmeister: https://github.com/wurstmeister/kafka-docker
- bitnami: https://insertafter.com/en/blog/kafka_docker_compose.html - https://hub.docker.com/r/bitnami/kafka/
- confluentinc: https://www.baeldung.com/ops/kafka-docker-setup

## Kafka Useful Commands

https://gist.github.com/kim-hyunjin/bde9d52445cc791bc06a109a249ad753

# Database Implementation

Main tables to interact with:

## User

- `api_key`: String

## Colors

- `id`: Integer
- `name`: String (e.g.: "blue", "red")

## Actions

- `id`: Integer
- `name`: String (e.g.: "hover", "click")

## ActionColors

- `id`: Integer
- `api_key`: String
- `action_id`: Integer (e.g.: "Click")
- `color_id`: Integer (e.g.: "Red")
- `amount`: Integer (e.g.: "30")

# Automated Verification with Chef InSpec

Chef InSpec is an infrastructure security and compliance testing framework with a human- and machine-readable language for comparing actual versus desired system state.

Download and install Inspec: https://www.chef.io/downloads/tools/inspec

Source: https://joachim8675309.medium.com/docker-the-terraform-way-a7c16b5f59ed

```ruby
$ cd backend/infrastructure/tests

$ terraform apply

$ inspec exec validate_containers_state.rb
```
