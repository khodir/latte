Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  # devise routes
  devise_for :users,
    controllers: {
      sessions: "user/sessions"
    },
    only: [ :sessions ]

  root "application#show_home"
  get "login", to: "application#show_login", as: :login

  # master
  scope "master" do
    # category
    scope "category" do
      get "/", to: "category#show", as: :show_category
      get "/new", to: "category#new", as: :new_category
      get "/edit/:id", to: "category#edit", as: :edit_category
      post "/", to: "category#create", as: :create_category
      put "/:id", to: "category#update", as: :update_category
      delete "/:id", to: "category#destroy", as: :destroy_category
    end

    # item
    scope "item" do
      get "/", to: "item#show", as: :show_item
      get "/new", to: "item#new", as: :new_item
      get "/edit/:id", to: "item#edit", as: :edit_item
      post "/", to: "item#create", as: :create_item
      put "/:id", to: "item#update", as: :update_item
      delete "/:id", to: "item#destroy", as: :destroy_item
    end
  end
end
