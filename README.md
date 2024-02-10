<img src="https://github.com/juanroldan1989/color-tracking/blob/main/color-tracking-header.png" alt="juanroldan1989 color-tracking">

<h4 align="center">Events Tracking Platform 🚦 Clicks & Hovers on Colors 🎯 Live Graphs & Counters</h4>

<p align="center">
  <a href="https://github.com/juanroldan1989/color-tracking/commits/master">
  <img src="https://img.shields.io/github/last-commit/juanroldan1989/color-tracking.svg?style=flat-square&logo=github&logoColor=white" alt="GitHub last commit">
  <a href="https://github.com/juanroldan1989/color-tracking/issues">
  <img src="https://img.shields.io/github/issues-raw/juanroldan1989/color-tracking.svg?style=flat-square&logo=github&logoColor=white" alt="GitHub issues">
  <a href="https://github.com/juanroldan1989/color-tracking/pulls">
  <img src="https://img.shields.io/github/issues-pr-raw/juanroldan1989/color-tracking.svg?style=flat-square&logo=github&logoColor=white" alt="GitHub pull requests">
  <a href="https://github.com/juanroldan1989/color-tracking/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-brightgreen.svg">
  </a>
  <a href="https://twitter.com/intent/tweet?text=Hey%20I've%20just%20discovered%20this%20cool%20app%20on%20Github%20by%20@JhonnyDaNiro%20-%20Color%20Tracking%20Live%20Events%20With%20Dashboards&url=https://github.com/juanroldan1989/color-tracking/&via=Github">
  <img src="https://img.shields.io/twitter/url/https/github.com/juanroldan1989/color-tracking.svg?style=flat-square&logo=twitter" alt="GitHub tweet">
</p>

<p align="center">
  <a href="#core_features">Core Features</a> •
  <a href="#frontend">Frontend</a> •
  <a href="#backend">Backend</a> •
  <a href="#development">Development</a> •
  <a href="#testing">Testing</a> •
  <a href="#deployment">Deployment</a> •
  <a href="#wiki">Wiki</a> •
  <a href="#further_improvements">Further Improvements</a> •
  <a href="#contribute">Contribute</a>
</p>

# Core Features

<div align="left">
  <img width="800" src="https://github.com/juanroldan1989/color-tracking/blob/main/color-tracking-live-demo.gif" />
</div>

1. Track `hover` and `click` user events.

2. Record data either in `real time` or through `background processing`.

3. Display data through `dashboards` as close to real time as possible.

## Idea inception

<div align="left">
  <img width="400" src="https://github.com/juanroldan1989/color-tracking/blob/main/color-tracking.jpeg" />
</div>

# Development

## ![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)

Relevant folder: `backend`

```ruby
$ git clone git@github.com:juanroldan1989/color-tracking.git
$ cd color-tracking
$ cd backend

$ docker-compose up

# cleaning up
$ docker-compose down -v
```

Open static `frontend` page:

```ruby
$ cd frontend
$ open index.html
```

## ![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)

Relevant folder: `/backend/infrastructure/terraform`

1. Enable `Docker Local Development` section in `main.tf`

2. Run commands:

```ruby
$ terraform init

$ terraform plan

$ terraform apply
```

**Application is ready**

Open static `frontend` page:

```ruby
$ cd frontend
$ open index.html
```

To destroy all local containers managed by your Terraform configuration:

```ruby
$ terraform destroy
```

# Testing

## Backend

API tests written with RSpec

```ruby
$ cd backend
$ rspec spec
```

## Frontend

Frontend work has been **purposely** implemented using standalone libraries:

- jQuery (Easy DOM Handling)
- D3 (Graphs)
- Action Cable (Websockets)

```ruby
── frontend
    └── static
        ├── css
        │   └── main.css
        ├── index.html
        └── js
            ├── draw_colors_table.js
            ├── events
            │   └── clicks_and_hovers.js
            ├── polling
            │   ├── draw_clicks_dashboard.js
            │   └── draw_hovers_dashboard.js
            └── websockets
                ├── action_cable.js
                ├── draw_clicks_dashboard.js
                └── draw_hovers_dashboard.js
```

This way anyone can use their framework of choice to implement a `frontend` application that interacts with the `backend` and write `frontend` tests as well.

## Docker Containers

Automated Verification achieved through `Chef InSpec`

`Chef InSpec` is an infrastructure security and compliance testing framework with a human and machine-readable language for comparing **actual versus desired system state.**

Download and install Inspec: https://www.chef.io/downloads/tools/inspec

Source: https://joachim8675309.medium.com/docker-the-terraform-way-a7c16b5f59ed

Tests for project present in [validate_containers_state.rb](https://github.com/juanroldan1989/color-tracking/blob/main/backend/infrastructure/tests/validate_containers_state.rb)

```ruby
PORT_DB = attribute("port", value: "5432", description: "DB port")
PORT_ZOO = attribute("port", value: "2181", description: "ZOOKEEPER port")
PORT_KAFKA = attribute("port", value: "9092", description: "KAFKA port")
PORT_API = attribute("port", value: "3000", description: "API port")
PORT_KARAFKA = attribute("port", value: "3001", description: "KARAFKA port")

control "db-container" do
  impact 1.0
  title "DB Container"
  desc "DB container should be running"

  describe docker_container "db" do
    it { should exist }
    it { should be_running }
    its("image") { should eq "postgres:9.6-alpine" }
    its("ports") { should eq "0.0.0.0:#{PORT_DB}->#{PORT_DB}/tcp" }
  end

  describe json({ command: "docker container inspect db" }) do
    its([0, "HostConfig", "NetworkMode"]) { should include "color-tracking-net" }
  end
end

control "zoopkeeper-container" do
  impact 1.0
  title "Zookeeper Container"
  desc "Zookeeper container should be running"

  describe docker_container "zookeeper" do
    it { should exist }
    it { should be_running }
    its("image") { should eq "wurstmeister/zookeeper" }
    its("ports") { should eq "22/tcp, 2888/tcp, 3888/tcp, 0.0.0.0:#{PORT_ZOO}->#{PORT_ZOO}/tcp" }
  end

  describe json({ command: "docker container inspect zookeeper" }) do
    its([0, "HostConfig", "NetworkMode"]) { should include "color-tracking-net" }
  end
end

control "kafka-container" do
  impact 1.0
  title "Kafka Container"
  desc "Kafka container should be running"

  describe docker_container "kafka" do
    it { should exist }
    it { should be_running }
    its("image") { should eq "wurstmeister/kafka" }
    its("ports") { should eq "0.0.0.0:#{PORT_KAFKA}->#{PORT_KAFKA}/tcp" }
  end

  describe json({ command: "docker container inspect kafka" }) do
    its([0, "HostConfig", "NetworkMode"]) { should include "color-tracking-net" }
  end
end

control "api-container" do
  impact 1.0
  title "API Container"
  desc "API container should be running"

  describe docker_container "api" do
    it { should exist }
    it { should be_running }
    its("image") { should eq "juanroldan1989/color-tracking-api" }
    its("ports") { should eq "0.0.0.0:#{PORT_API}->#{PORT_API}/tcp" }
  end

  describe json({ command: "docker container inspect api" }) do
    its([0, "HostConfig", "NetworkMode"]) { should include "color-tracking-net" }
  end
end

control "karafka-consumer-container" do
  impact 1.0
  title "Karafka Consumer Container"
  desc "Karafka Consumer container should be running"

  describe docker_container "karafka-consumer" do
    it { should exist }
    it { should be_running }
    its("image") { should eq "juanroldan1989/color-tracking-api" }
    its("ports") { should eq "0.0.0.0:#{PORT_KARAFKA}->3000/tcp" }
  end

  describe json({ command: "docker container inspect karafka-consumer" }) do
    its([0, "HostConfig", "NetworkMode"]) { should include "color-tracking-net" }
  end
end
```

Trigger tests:

```ruby
$ cd backend

$ docker-compose up

$ cd backend/infrastructure/tests

$ inspec exec validate_containers_state.rb
```

## CI/CD Integration

`[Work In Progress]` Provide Github Actions setup for triggering all frontend/backend and containers tests, THEN deploy.

# Deployment

## ![AWS ECS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)

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

## ![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)

Relevant folder: `/backend/infrastructure/terraform`

1. Enable `AWS DEPLOYMENT` section in `main.tf`

2. Run commands:

```ruby
$ terraform init

# Observe all resources to be added
$ terraform plan

# Build & Launch infrastructure required
$ terraform apply
```

**Application is ready**

Replace `http://localhost:3000` instances inside `frontend/static/index.html` file with `Public DNS` hostname:

1. Check AWS ECS console: https://console.aws.amazon.com/ecs/home#/clusters

2. Get `Public DNS` value provided within `ECS Cluster` -> `Container Instance` -> `Public DNS`

3. Open static `frontend` page:

```ruby
$ cd frontend
$ open index.html
```

To destroy all remote objects managed by your Terraform configuration:

```ruby
$ terraform destroy
```

# Frontend

Frontend work has been **purposely** implemented using standalone libraries:

- jQuery (Easy DOM Handling)
- D3 (Graphs)
- Action Cable (Websockets)

This way anyone can use their framework of choice to implement a `frontend` application that interacts with the `backend`

# Backend

Broadcasting Events from `backend` to `frontend`

- Websockets implementation in the `backend` achieved through Rails's own `ActionCable`

- Websockets implementation in the `frontend` achieved through `action_cable` Javascript library.

## Database Implementation

Main tables to interact with:

### User

- `api_key`: String

### Colors

- `id`: Integer
- `name`: String (e.g.: "blue", "red")

### Actions

- `id`: Integer
- `name`: String (e.g.: "hover", "click")

### ActionColors

- `id`: Integer
- `api_key`: String
- `action_id`: Integer (e.g.: "Click")
- `color_id`: Integer (e.g.: "Red")
- `amount`: Integer (e.g.: "30")

### Cable Ready (Optional)

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
# /v1/events_controller.rb
...

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

# Contribute

Got **something interesting** you'd like to **add or change**? Please feel free to [Open a Pull Request](https://github.com/juanroldan1989/color-tracking/pulls)

If you want to say **thank you** and/or support the active development of `Color Tracking API`:

1. Add a [GitHub Star](https://github.com/juanroldan1989/color-tracking/stargazers) to the project.
2. Tweet about the project [on your Twitter](https://twitter.com/intent/tweet?text=Hey%20I've%20just%20discovered%20this%20cool%20app%20on%20Github%20by%20@JhonnyDaNiro%20-%20Color%20Tracking%20Live%20Events%20With%20Dashboards&url=https://github.com/juanroldan1989/color-tracking/&via=Github).
3. Write a review or tutorial on [Medium](https://medium.com), [Dev.to](https://dev.to) or personal blog.
