Rails.application.routes.draw do
  mount ActionCable.server => "/v1/events/cable"

  namespace :v1 do
    resources :events, only: [:create, :index]
  end
end
