Rails.application.routes.draw do
  resources :users, only: [:new, :create, :show, :edit, :update, :destroy] do
  get :favorites, on: :collection
  end

  resources :pictures
  resources :sessions, only: [:new, :create, :destroy]
  resources :favorites, only: [:create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
