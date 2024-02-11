# frozen_string_literal: true

# TODO: add resiliency workflow (e.g.: queues, DLQs, etc)
#       so we increase tracking coverage of events (clicks & hovers)

# https://faun.pub/aws-sns-dead-letter-queue-dlq-pattern-local-setup-272a206da3f

class HoversConsumer < ApplicationConsumer
  # Consumes the messages by inserting all of them in one go into the DB
  def consume
    if ENV["REDIS_AS_DB"]
      redis = Redis.new(host: "redis")

      action_name = Action.find(messages.payloads[0]["action_id"]).name
      color_name = Color.find(messages.payloads[0]["color_id"]).name

      key = "#{messages.payloads[0]["api_key"]}_#{action_name}_#{color_name}"
      value = redis.get(key)

      redis.set(key, value.to_i + 1)
    else
      ActionColor.create!(messages.payloads)
    end
  rescue => e
    # e.g.: `action_id` is nil -> `rollback transaction` error rescued
    #        so Karafka is able to continue processing events
    Rails.logger.error "HoversConsumer - consume failed: #{e.message}"
    nil
  end

  # Run anything upon partition being revoked
  # def revoked
  # end

  # Define here any teardown things you want when Karafka server stops
  # def shutdown
  # end
end
