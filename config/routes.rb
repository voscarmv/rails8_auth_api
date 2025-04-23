Rails.application.routes.draw do
  resources :projects
  resource :session

  resources :passwords, param: :token
  resources :users, only: [ :index, :show, :create, :update, :destroy ]

  get "/standard_error" => "test_exceptions#standard_error", as: :standard_error
  get "/record_not_found" => "test_exceptions#record_not_found", as: :record_not_found
  get "/parameter_missing" => "test_exceptions#parameter_missing", as: :parameter_missing
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
