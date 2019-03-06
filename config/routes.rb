Rails.application.routes.draw do
  namespace :admin do
    root 'rates#index'
    resources :rates, only: :index
  end
  root 'rates#index'
  resources :rates, only: :index
end
