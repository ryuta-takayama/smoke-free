Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  root to: "pages#home"
  resource :dashboard, only: [:show]
  resource :posts


end
