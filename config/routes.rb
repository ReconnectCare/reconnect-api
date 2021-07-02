Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  #### ADMIN ####
  namespace :admin do
    authenticate :user, lambda { |u| u.admin? } do
      require "sidekiq/web"
      mount Sidekiq::Web => "/sidekiq"
    end
  end

  #### ROUTES ####
  resources :conferences, except: [:destroy] do
    member do
      get :recording
    end
  end
  resources :patients
  resources :providers
  resources :conference_numbers, except: [:update, :edit]
  resources :api_tokens
  resources :text_messages, only: [:index, :show]
  resources :voice_calls, only: [:index, :show]
  resources :settings

  devise_for :users

  #### API ####
  namespace :api do
    get "status", to: "api#status"
    api_version(
      module: "V1",
      header: {name: "Accept", value: "application/api.rails-starter-6.com; version=1"},
      path: {value: "v1"},
      default: true
    ) do
      resource :auth, only: [:create]
      resource :me, controller: :me
      resources :conferences, only: [:create]
    end
  end

  #### External Hooks ####
  namespace :hooks do
    # post "texts", to: "texts#create"
    post "texts/:id", to: "texts#status", as: :text_status
    post "voice", to: "voice#create"
    post "voice/call_status", to: "voice#call_status", as: :call_status
    post "voice/:id/status", to: "voice#status", as: :voice_status
    post "voice/:id/respond", to: "voice#respond", as: :voice_respond
    post "voice/:id/recorded", to: "voice#recorded", as: :voice_recorded
  end

  get :dashboard, to: "dashboard#index", as: :dashboard

  get "/healthcheck/", to: "health#check"
  root to: "home#index"
end
