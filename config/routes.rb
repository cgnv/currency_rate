# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    root 'rates#index'
    resources :rates, only: %i[index create]
  end
  root 'rates#index'
  resources :rates, only: :index
end
