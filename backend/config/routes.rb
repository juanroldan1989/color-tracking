Rails.application.routes.draw do
  mount ActionCable.server => "/v1/cable"

  namespace :v1 do
    resources :action_colors, only: [:create, :index]
  end
end
