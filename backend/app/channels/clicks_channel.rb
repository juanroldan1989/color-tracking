# frozen_string_literal: true

# TODO: associate stream with 1 API_KEY

class ClicksChannel < ApplicationCable::Channel
  STREAM = "live_clicks_dashboard"

  def subscribed
    stream_from STREAM
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
