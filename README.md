# Color Tracking App

Implementation details:

<div align="left">
  <img width="400" src="https://github.com/juanroldan1989/color-tracking/blob/main/color-tracking.jpeg" />
</div>

# Karafka trobleshooting

```ruby
$ brew services stop/start kafka
$ brew services stop/start zookeeper
```

# Database implementation

## User

- `id`: Integer (`session[:visitor_id] ||= SecureRandom.uuid`)
- `created_at`: DateTime (`Time.zone.now`)

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
