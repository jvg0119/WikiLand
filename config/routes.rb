Rails.application.routes.draw do

  #get 'users/edit'


  devise_for :users
  resources :users, only: [:edit, :update]
  
  get 'about' => 'welcome#about'
  get 'index' => 'welcome#index'

  root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
