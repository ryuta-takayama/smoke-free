Rails.application.routes.draw do
  get 'dashbords/show'
  devise_for :users, controllers: { registrations: "users/registrations" }
  root to: "pages#home"
  
  resources :users, only: [] do
    resource :dashbords, only: [:show]
  end


end
