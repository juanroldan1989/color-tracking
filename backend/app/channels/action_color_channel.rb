class ActionColorChannel < ApplicationCable::Channel
  def subscribed
    stream_from "live_dashboards"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
