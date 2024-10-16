# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  devise_for :users
  resources :entry_tags
  resources :entry_people
  resources :entries do
    member do
      post :add_keyword, as: :add_keyword_to
      post :remove_keyword, as: :remove_keyword_from
    end
  end
  resources :tags
  resources :people
  resources :types

  controller :pages do
    get :util
  end

  get "/keywords" => "entries#keywords", as: :keywords
  get "/import" => "import#form", as: :import_form
  post "/import" => "import#import", as: :import

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "entries#index"
end
