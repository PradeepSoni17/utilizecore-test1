Rails.application.routes.draw do
  # devise_for :users
  devise_scope :user do
    root :to => 'users/sessions#new'
  end
  devise_for :users, controllers: { 
    registrations: 'users/registrations' ,
    sessions: 'users/sessions' 
  }
  
  resources :roles
  resources :service_types
  resources :parcels
  resources :addresses
  resources :users
  post '/users/new_user', to: 'users#new_user'
  # root to: 'parcels#index'
  get '/search', to: 'search#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/parcels/change_status/:id', to: 'parcels#change_status'
  post '/parcels/update_status/:id', to: 'parcels#update_status'
  get '/parcels/history/:id', to: 'parcels#history'
  get '/parcel_export_reports' , to: 'parcels#parcel_export_reports'
  get '/download_excel_file', to: 'parcels#download_excel_file'
end
