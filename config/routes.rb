# Rails.application.routes.draw do
#   devise_for :users
#   # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

#   # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
#   # Can be used by load balancers and uptime monitors to verify that the app is live.
#   get "up" => "rails/health#show", as: :rails_health_check

#   # Defines the root path route ("/")
#   # root "posts#index"
# end

# config/routes.rb
require 'sidekiq/web'
Rails.application.routes.draw do

  devise_for :users,
  controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
  }

 
  namespace :api do
    namespace :v1 do
      resources :posts
    end
  end

  
mount Sidekiq::Web => '/sidekiq'

  # Your other routes...
  # get "up" => "rails/health#show", as: :rails_health_check
  # root to: 'home#index' # Change this to your root route
end

