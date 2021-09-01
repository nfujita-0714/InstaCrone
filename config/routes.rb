Rails.application.routes.draw do
  root 'pictures#index'
  resources :users, only: [:new, :create, :show, :edit, :update, :destroy] do
  get :favorites, on: :collection
  end

  resources :pictures do 
    collection do
      post :confirm 
    end
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :favorites, only: [:create, :destroy]
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

