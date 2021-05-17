Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :admin do
    authenticate :user, lambda { |u| u.admin? } do
      require "sidekiq/web"
      mount Sidekiq::Web => "/sidekiq"
    end
  end

  resources :conferences
  resources :patients
  resources :providers
  resources :conference_numbers

  devise_for :users

  get :dashboard, to: "dashboard#index", as: :dashboard

  get "/healthcheck/", to: "health#check"
  root to: "home#index"
end
