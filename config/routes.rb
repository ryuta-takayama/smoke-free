Rails.application.routes.draw do
  devise_for :users
  get 'pages/home', to: 'pages#home'
end
