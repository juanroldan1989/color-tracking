# frozen_string_literal: true

# TODO: add resiliency workflow (e.g.: queues, DLQs, etc)
#       so we increase tracking coverage of events (clicks & hovers)

class HoversConsumer < ApplicationConsumer
  # Consumes the messages by inserting all of them in one go into the DB
  def consume
    ActionColor.create!(messages.payloads)
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
