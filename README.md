# Color Tracking App

<div align="left">
  <img width="800" src="https://github.com/juanroldan1989/color-tracking/blob/main/color-tracking-screenshot.png" />
</div>

## Thoughts and Inspiration

<div align="left">
  <img width="400" src="https://github.com/juanroldan1989/color-tracking/blob/main/color-tracking.jpeg" />
</div>

## Karafka trobleshooting

```ruby
$ brew services stop/start kafka
$ brew services stop/start zookeeper
```

## Kafka Docker Images available

- wurstmeister: https://github.com/wurstmeister/kafka-docker
- bitnami: https://insertafter.com/en/blog/kafka_docker_compose.html - https://hub.docker.com/r/bitnami/kafka/
- confluentinc: https://www.baeldung.com/ops/kafka-docker-setup

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
