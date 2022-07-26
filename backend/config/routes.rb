Rails.application.routes.draw do
  namespace :v1 do
    resources :action_colors, only: [:create, :index]
  end
end
