Rails.application.routes.draw do
  mount ActionCable.server => "/cable"

  namespace :v1 do
    resources :action_colors, only: [:create, :index]
  end
end
