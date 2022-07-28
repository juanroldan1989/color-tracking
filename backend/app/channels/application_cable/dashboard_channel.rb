# https://guides.rubyonrails.org/action_cable_overview.html

module ApplicationCable
  class DashboardChannel < ApplicationCable::Channel

    def subscribed
      # consumer ready to receive data to populate graph dashboards
    end
  end
end
