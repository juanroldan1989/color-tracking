<img src="https://github.com/juanroldan1989/color-tracking/blob/main/color-tracking-header.png" alt="juanroldan1989 color-tracking">

<h4 align="center">Events Tracking Platform 🚦 Clicks & Hovers on Colors 🎯 Live Graphs & Counters</h4>

<p align="center">
  <a href="https://github.com/juanroldan1989/color-tracking/commits/master">
  <img src="https://img.shields.io/github/last-commit/juanroldan1989/color-tracking.svg?style=flat-square&logo=github&logoColor=white" alt="GitHub last commit">
  <a href="https://github.com/juanroldan1989/color-tracking/issues">
  <img src="https://img.shields.io/github/issues-raw/juanroldan1989/color-tracking.svg?style=flat-square&logo=github&logoColor=white" alt="GitHub issues">
  <a href="https://github.com/juanroldan1989/color-tracking/pulls">
  <img src="https://img.shields.io/github/issues-pr-raw/juanroldan1989/color-tracking.svg?style=flat-square&logo=github&logoColor=white" alt="GitHub pull requests">
  <a href="https://twitter.com/intent/tweet?text=Hey%20I've%20just%20discovered%20this%20cool%20app%20on%20Github%20by%20@JhonnyDaNiro%20-%20Color%20Tracking%20Live%20Events%20With%20Dashboards&url=https://github.com/juanroldan1989/color-tracking/&via=Github">
  <img src="https://img.shields.io/twitter/url/https/github.com/juanroldan1989/color-tracking.svg?style=flat-square&logo=twitter" alt="GitHub tweet">
</p>

<p align="center">
  <a href="#demo">Demo</a> •
  <a href="#diagrams">Diagrams</a> •
  <a href="#development">Development</a> •
  <a href="#testing">Testing</a> •
  <a href="#deployment">Deployment</a> •
  <a href="#frontend">Frontend</a> •
  <a href="#backend">Backend</a> •
  <a href="#wiki">Wiki</a> •
  <a href="#contributing">Contributing</a>
</p>

# Demo

<div align="left">
  <img width="800" src="https://github.com/juanroldan1989/color-tracking/blob/main/color-tracking-screenshot.png" />
</div>

# Diagrams

## Docker

TODO

## AWS ECS

TODO

# Development

Starting up:

```ruby
$ git clone git@github.com:juanroldan1989/color-tracking.git
$ cd color-tracking
$ cd backend
$ docker-compose up
```

```ruby
$ cd frontend
$ open index.html
```

Cleaning up:

```ruby
$ cd backend
$ docker-compose down -v
```

# Testing

Automated Verification achieved through `Chef InSpec`

Chef InSpec is an infrastructure security and compliance testing framework with a human- and machine-readable language for comparing actual versus desired system state.

Download and install Inspec: https://www.chef.io/downloads/tools/inspec

Source: https://joachim8675309.medium.com/docker-the-terraform-way-a7c16b5f59ed

```ruby
$ docker-compose up

$ cd backend/infrastructure/tests

$ inspec exec validate_containers_state.rb
```

# Deployment

## AWS ECS

1. Official steps for ECS CLI Configuration:
https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_CLI_installation.html

2. Place both `ecs-cli.asc` and `public_key_ecs.txt` files inside `backend/infrastructure/aws-ecs` folder.

3. Login into AWS Console -> EC2 -> Key pairs -> Create key pair

4. Download `private-ecs-key.cer` and place it inside `backend/infrastructure/aws-ecs` folder

5. Deployment instructions:

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

6. Cluster deletion and resources cleanup
```ruby
$ ecs-cli down --cluster color-tracking --force
```

## Terraform

- TODO

# Frontend

Frontend work has been **purposely** implemented using standalone libraries:

- jQuery (Easy DOM Handling)
- D3 (Graphs)
- Action Cable (Websockets)

This way anyone can use their framework of choice to implement a `frontend` application that interacts with the `backend`

## Dashboards updates achieved by 3 approaches

### Approach 1

1. `Click/Hover` event triggered in `frontend`
2. Dashboards updated accordingly in `frontend`
3. Event sent to `backend`
4. `ActionColor` record is created

**Pros:**
- UX is amazing. 100% `real-time`

**Cons:**
- If record creation fails in backend (including `resiliency workflow`), dashboards won't match users actions after page reload.
- UI updated for `1 client` with given API Key.

### Approach 2

1. `Click/Hover` event triggered in `frontend`
2. Event sent to `backend`
3. `ActionColor` record is created
4. Dashboards data is sent back to `frontend` via `websockets`
5. Dashboards updated accordingly in `frontend`

**Pros:**
- Data displayed always matches records in database, even after page reload.
- UI updated for `all clients` with given API Key.

**Cons:**
- UX is less performant than `Approach 1`

### Approach 3

1. `Click/Hover` event triggered in `frontend`
2. Event sent to `backend`
3. `ActionColor` record is created
4. Dashboards data is fetched from `frontend` via `polling` every X seconds
5. Dashboards updated accordingly in `frontend`

**Pros:**
- Data displayed always matches records in database, even after page reload.
- UI updated for `1 client` with given API Key after X seconds.

**Cons:**
- UX is less performant than `Approach 2`

# Backend

Broadcasting Events from BE to FE

- Websockets implementation in the backend achieved through Rails's own `ActionCable`

- Websockets implementation in the frontend achieved through `action_cable` Javascript library.

## Cable Ready

`cable_ready` ruby gem is a great extension on `ActionCable` capabilities

Provides `operations` to be broadcasted to the frontend.

https://cableready.stimulusreflex.com/#what-can-i-do-with-cableready
https://cableready.stimulusreflex.com/cableready-everywhere

`Backend` adjustments when working with `cable_ready`:

```ruby
# Gemfile

...

gem "cable_ready", "~> 4.5.0"

...
```

```ruby
# /v1/action_colors_controller.rb
...

stream = case action_title
  when Action::CLICK
    ClicksChannel::STREAM
  when Action::HOVER
    HoversChannel::STREAM
  end

cable_ready[stream].console_log(message: { results: results })
cable_ready.broadcast

...
```

`Frontend` adjustments when working with `cable_ready`:

```ruby

# js/websockets/draw_hovers_dashboard.js
...

console.log("Received data: ", data);

var results = data.operations.consoleLog[0].message.results;

...
```

# Wiki

Do you **need some help**? Check the _articles_ from the [wiki](https://github.com/juanroldan1989/color-tracking/wiki/).

# Contributing

Got **something interesting** you'd like to **share**? Please feel free to [Open a Pull Request](https://github.com/juanroldan1989/color-tracking/pulls)

--------

# To be added inside Wiki

# Inspiration

<div align="left">
  <img width="400" src="https://github.com/juanroldan1989/color-tracking/blob/main/color-tracking.jpeg" />
</div>

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

# ActionCable Links

https://guides.rubyonrails.org/action_cable_overview.html

https://www.npmjs.com/package/actioncable#npm-usage

https://cableready.stimulusreflex.com/installation

https://medium.com/@the.asantiagojr/how-to-setup-actioncable-with-a-rails-api-backend-1f1807c2d908

Generate frontend Node project: https://nroulston.github.io/want_your_rails_api_to_be_multiplayer_lets_talk_actioncable - https://www.youtube.com/watch?v=1BfCnjr_Vjg&ab_channel=Fireship

Websocket API in Javascript and AWS API Gateway
https://www.youtube.com/watch?v=_hS2EWMY758&ab_channel=LambertLabs

-------------

# TODO

Add Logo structure from: https://github.com/thelounge/thelounge#readme

Add Table of contents https://github.com/Ileriayo/markdown-badges

Add badges from https://github.com/Ileriayo/markdown-badges

Twitter link from: https://github.com/ArmynC/ArminC-AutoExec/#readme

Video walkthrough like this: https://github.com/ajeetdsouza/zoxide#readme - https://github.com/create-go-app/cli#readme

Say Thanks link like this: https://github.com/amitmerchant1990/electron-markdownify#readme

Add Mobile view of how app looks like: https://github.com/gitpoint/git-point#introduction

Contribute section like this: https://github.com/gofiber/fiber#-contribute

API could store "coordenates":
- Then "replay mouse movement" functionality can be built on top
- Then "heatmap" generation functionality can be built on top
- Then "live mouse movements" could be replicated in an Admin Dashboard having an endpoint reading from Kafka and sending live data via websockets

**Rising Wave**

RisingWave makes it possible to do real-time ad performance analysis in a low code manner.

https://www.risingwave.dev/docs/latest/perform-real-time-ad-performance-analysis/

https://www.risingwave.dev/docs/latest/architecture/

**UUID in frontend**

https://github.com/uuidjs/uuid

**AWS Diagrams**

https://aws.amazon.com/architecture/icons/
https://alanblackmore.medium.com/aws-diagram-architecture-afb50ea569a4?s=03

Great diagrams on this article: https://javascript.plainenglish.io/how-to-create-a-dynamic-ecs-cluster-with-terraform-86d6b11d0db9
https://aws.amazon.com/blogs/containers/developers-guide-to-using-amazon-efs-with-amazon-ecs-and-aws-fargate-part-1/
https://aws.amazon.com/ecs

IDEAL Diagram for ECS Tasks: https://github.com/voyagegroup/terraform-aws-ecs-task-sequential-execution
