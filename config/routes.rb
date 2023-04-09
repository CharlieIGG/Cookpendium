Rails.application.routes.draw do
  root "homepage#index"

  namespace :api do
    namespace :v1 do
      get "recipes/index"
      post "recipes/create"
      get "/show/:id", to: "recipes#show"
      delete "/recipes/:id", to: "recipes#destroy"
    end
  end

  get "/*path" => "homepage#index"
end
