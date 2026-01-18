Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Root path - Welcome page
  root "pages#welcome"

  # Onboarding flow
  get "onboarding", to: "onboarding#start"
  post "onboarding/profile", to: "onboarding#save_profile", as: :onboarding_save_profile
  get "onboarding/question/:number", to: "onboarding#question", as: :onboarding_question
  post "onboarding/answer", to: "onboarding#answer"
  get "onboarding/portrait", to: "onboarding#portrait", as: :onboarding_portrait

  # Dashboard
  get "dashboard", to: "dashboard#index"

  # Actors
  resources :actors, only: [:index, :show]

  # Value Portrait
  get "my-values", to: "value_portraits#show"
end
