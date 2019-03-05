Rails.application.routes.draw do
  namespace :admin do
    get 'rates/index'
  end
  get 'rates/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
