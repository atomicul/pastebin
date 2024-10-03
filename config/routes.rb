Rails.application.routes.draw do
  resources :pastedata, only: %i{show create new} do
    post '/', action: "view"
  end
  get "/", controller: "home", action: "index"
  get "up" => "rails/health#show", as: :rails_health_check
end
