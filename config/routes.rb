Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  root to: "pages#home"
  resource :dashbords, only: [:show]
  resource :posts
  

end
