Nytech::Application.routes.draw do
  resources :users
  resources :jobs do 
    collection { post :import }
  end
  resource :session, only: [:new, :create, :destroy]
  
  match '/home',    to: 'static_pages#home', via: :get
  match '/logout',  to: 'sessions#destroy', via: :delete
  match '/login',   to: 'sessions#new', via: :get
   
  root to: 'static_pages#home'
end
