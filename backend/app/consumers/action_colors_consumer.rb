# frozen_string_literal: true

class ActionColorsConsumer < ApplicationConsumer

  # Consumes the messages by inserting all of them in one go into the DB
  def consume
    ActionColor.create!(messages.payloads)
  end

  # Run anything upon partition being revoked
  # def revoked
  # end

  # Define here any teardown things you want when Karafka server stops
  # def shutdown
  # end
end
