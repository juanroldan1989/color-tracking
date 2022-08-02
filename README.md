# Color Tracking App

<div align="left">
  <img width="800" src="https://github.com/juanroldan1989/color-tracking/blob/main/color-tracking-screenshot.png" />
</div>

## Thoughts and Inspiration

<div align="left">
  <img width="400" src="https://github.com/juanroldan1989/color-tracking/blob/main/color-tracking.jpeg" />
</div>

## Karafka troubleshooting

For local development:

```ruby
$ brew services stop/start kafka
$ brew services stop/start zookeeper
$ bundle exec karafka server (start and stop)
```

## Karafka Consumer troubleshooting

For Docker Compose development:

```ruby
$ docker stop/start karafka-consumer
```

**The above also triggers topics creation (in case they don't exist yet)**

- Run Karafka server and see the consumption magic happen
https://github.com/karafka/karafka#tldr-1-minute-from-setup-to-publishing-and-consuming-messages

## KAFKA_AUTO_CREATE_TOPICS_ENABLE = true

- Environment variable pass to `wurstmeister/kafka` container.
- Topics will be created **as and when they're first referenced** by the producer or consumer.

## KAFKA_AUTO_CREATE_TOPICS_ENABLE = false

Then we need to to pass to `wurstmeister/kafka` container:

```ruby
KAFKA_CREATE_TOPICS: "hover_on_colors:1:1,click_on_colors:1:1"
```

## Kafka Docker Images available

- wurstmeister: https://github.com/wurstmeister/kafka-docker
- bitnami: https://insertafter.com/en/blog/kafka_docker_compose.html - https://hub.docker.com/r/bitnami/kafka/
- confluentinc: https://www.baeldung.com/ops/kafka-docker-setup

## Kafka Useful Commands

https://gist.github.com/kim-hyunjin/bde9d52445cc791bc06a109a249ad753

## Database implementation

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
