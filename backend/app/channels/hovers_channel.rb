# frozen_string_literal: true

class HoversChannel < ApplicationCable::Channel
  STREAM = "live_hovers_dashboard"

  def subscribed
    stream_from STREAM
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
