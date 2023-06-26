Rails.application.routes.draw do
  get 'leads/new'
  get 'leads/create'

  devise_for :users
  root to: "pages#home"
  get '/main', to: 'pages#main'

  # get '/workshop', to: 'pages#workshop'


  resources :pages, only: [] do
    post 'submit', on: :collection
  end

  resources :leads, only: [:create]
  get '/workshop', to: 'leads#new'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
