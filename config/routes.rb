Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth/login', to: 'auth#login'
      post 'auth/register', to: 'auth#register'
      get 'profile', to: 'profile#show'
      put 'profile', to: 'profile#update'
      delete 'profile', to: 'profile#destroy'
      resources :projects do 
        resources :tasks
      end
    end
  end

  get "/404" => "errors#not_found"
  get "/500" => "errors#exception"


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
