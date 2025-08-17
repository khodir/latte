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
      get "/", to: "category#show"
      get "/new", to: "category#new"
      get "/edit/:id", to: "category#edit"
      post "/", to: "category#create"
      put "/:id", to: "category#update"
      delete "/:id", to: "category#destroy"
    end

    # item
    scope "item" do
      get "/", to: "item#show"
      get "/new", to: "item#new"
      get "/edit/:id", to: "item#edit"
      post "/", to: "item#create"
      put "/:id", to: "item#update"
      delete "/:id", to: "item#destroy"
    end

    # customer
    scope "customer" do
      get "/", to: "customer#show", as: :customer_show
      get "/new", to: "customer#new", as: :customer_new
      get "/edit/:id", to: "customer#edit", as: :customer_edit
      post "/", to: "customer#create", as: :customer_create
      put "/:id", to: "customer#update", as: :customer_update
      delete "/:id", to: "customer#destroy", as: :customer_destroy
    end
  end
end
